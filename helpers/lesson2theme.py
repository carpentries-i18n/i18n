from argparse import ArgumentParser
import datetime
import difflib
import glob
import os
from pathlib import Path
import shutil
from subprocess import Popen, PIPE, TimeoutExpired
import tempfile

from git import Repo
from github import Github
from ruamel.yaml import YAML


def clone_repo_as_submodule(org, project, tmpdir='/tmp'):
    '''
    org: swcarpentry
    project: git-novice
    '''

    tmpdir = Path(tmpdir)
    if os.environ['gh_access_token']:
        g = Github(os.environ['gh_access_token'])
    else:
        # ask for user name and password
        # g = Github(username, password)
        raise NotImplementedError
    github_user = g.get_user()

    # from carpentries URL git repo to new Repo in swc-i18n
    repo = g.get_repo(f'{org}/{project}')
    # Fork repository
    carp_18n_org = [n for n in github_user.get_orgs() if "i18n" in n.login][0]
    # it doesn't create it if it exists.
    carp_i18n_fork = carp_18n_org.create_fork(repo)
    carp_i18n_fork.edit(homepage=f"https://carpentries-i18n.github.io/{project}/")

    i18n_local = Repo(".") # FIXME How should I pass the directory?


    sm_exists = any(filter(lambda x: f"{project}" in x.name, i18n_local.submodules))

    if sm_exists:
        project_sm = next(filter(lambda x: x.name == project, i18n_local.submodules), None)
        return i18n_local, Repo(f"{project}"), repo, carp_i18n_fork, project_sm, github_user

    # Creates a new branch for keep this lesson changes
    project_branch = i18n_local.create_head(project)
    i18n_local.head.reference = project_branch
    project_sm = i18n_local.create_submodule(project, project, url=carp_i18n_fork.clone_url)
    project_sm.update()
    # Clone repository
    i18n_local.index.commit(f"Adds {project} submodule.")
    return i18n_local, Repo(f"{project}"), repo, carp_i18n_fork, project_sm, github_user

def run_shell(bash_cmd, directory, timeout=20):
    run = Popen(bash_cmd.split(), cwd=directory)
    try:
        outs, errs = run.communicate(timeout=timeout)
    except TimeoutExpired:
        run.kill()
        outs, errs = run.communicate()
        print(f"Exceeded the {timeout/60} min time limit.")
        print(errs)
        raise TimeoutExpired
    if run.returncode:
        print(outs)
        print(errs)
        raise ValueError("Code failed")

def rmd2md(directory):
    # FIXME How to install the right dependencies?

    # Execute R command
    bash_cmd = "make lesson-md"
    run_shell(bash_cmd, directory, timeout=1800)

def md_replacements(filename, directory):
    lesson = directory.split('/')[-1]
    replacements = ((directory, f"/home/travis/build/datacarpentry/{lesson}"),)
    with open(filename, 'r') as f_in, open(f'{filename}_new', 'w') as f_out:
        data = f_in.read()
        for t1, t2 in replacements:
            data = data.replace(t1, t2)
        f_out.write(data)
    shutil.move(f'{filename}_new', filename)


def clean_wrong_format(directory):
    changes = 0
    answer = input("Do you have a fixed version? Copy it now and say how many files have changed when ready:")
    changes = int(answer)

    is_R_lesson = bool(glob.glob(f"{directory}/**/*Rmd"))
    if is_R_lesson:
        rmd2md(directory)

    files = glob.glob(f"{directory}/**/*.md", recursive=True)
    for f in files:
        with open(f, 'r') as mdfile:
            all_lines = mdfile.readlines()
            bad_lines = []
            for i, line in enumerate(all_lines):
                if "{:" in line:
                    # This is to cover whether the line starts with {: or with > {:
                    if set(all_lines[i-1].split()) == set('>'):
                           bad_lines.append(i-1)

        if is_R_lesson:
            # Change local path to Travis's as original
            md_replacements(f, directory)
            shutil.copyfile(f, f"{f}_orig")

        if bad_lines:
            changes += 1
            bad_lines.reverse()
            with open(f, 'w') as mdfile:
                for bad_line in bad_lines:
                    all_lines.pop(bad_line)
                mdfile.writelines(all_lines)

    if is_R_lesson:
        if changes:
            print("Propagate manually the changes to the Rmd files")
            for f in files:
                print("*"*20, f"{f}", "*"*20)
                show_diff(f"{f}_orig", f)
            answer = input("Press Y/y when completed:")
            assert answer in ['Y', 'y'], "Process cancel" #  TODO: cleanup
        # remove unmodified files
        for f in files:
            os.remove(f"{f}_orig")
    return changes

def file_mtime(path):
    t = datetime.datetime.fromtimestamp(os.stat(path).st_mtime,
                               datetime.timezone.utc)
    return t.astimezone().isoformat()

def show_diff(fromfile, tofile):
    # Copied from difflib documentation
    fromdate = file_mtime(fromfile)
    todate = file_mtime(tofile)
    with open(fromfile) as ff:
        fromlines = ff.readlines()
    with open(tofile) as tf:
        tolines = tf.readlines()

    diff = difflib.unified_diff(fromlines, tolines,
                                fromfile, tofile,
                                fromdate, todate, n=3)
    print(''.join(diff))

def check_theme(clone):
    yaml = YAML()
    with open(clone.working_dir + '/_config.yml') as mm:
        config = yaml.load(mm)
    return "i18n" in config.get('remote_theme', '')


def themetise_lesson(clone, default_branch):

    if check_theme(clone):
        return
    branch_ghpages = clone.create_head("gh_pages_theme") #  FIXME: changed gh_pages by default branch (master on R lessons)
    clone.head.reference = branch_ghpages
    is_R_lesson = bool(glob.glob(os.path.join(clone.working_dir, '_episodes_rmd/') + "*.Rmd"))

    # Clean repository
    # what's provided by theme
    dir_remove = ['_layouts', '_includes', 'assets', 'code', 'css'] #, 'files']
    # If it's not an R-lesson:  '_episodes_rmd' and bin
    if not is_R_lesson:
        dir_remove.extend(['_episodes_rmd', 'bin'])
    else:
        dir_remove.append('bin/boilerplate')

    for entry in os.listdir(clone.working_dir):
        if entry in dir_remove and os.path.isdir(os.path.join(clone.working_dir, entry)):
            shutil.rmtree(os.path.join(clone.working_dir, entry))

    # add theme to `_config.yml`
    yaml = YAML()
    with open(clone.working_dir + '/_config.yml') as mm:
        config = yaml.load(mm)

    config.insert(1, 'remote_theme', "carpentries-i18n/carp-theme", comment="Theme URL")

    elem_remove = ['amy_site', 'carpentries_github', 'carpentries_pages', 'carpentries_site',
                   'dc_site', 'example_repo', 'example_site', 'lc_site', 'swc_github',
                   'swc_pages', 'swc_site', 'template_repo', 'training_site',
                   'workshop_repo', 'workshop_site', 'pre_survey', 'post_survey',
                   'training_post_survey']
    for elem in elem_remove:
        if elem in config:
            config.pop(elem)

    with open(clone.working_dir + '/_config.yml', 'w') as mm:
        yaml.dump(config, mm)


    clone.git.add(update=True)
    clone.index.commit('Removed all files that are provisioned by theme.')

    # Add locale bits to config
    with open(clone.working_dir + '/_config.yml') as mm:
        config = yaml.load(mm)

    config['collections']['locale'] = {'output': True,
                                       'permalink': '/:path/index.html'}
    config['defaults'].append({'scope': {'path': "", 'type': "locale"},
                               'values': {'root': "..", 'layout': "episode"}})
    with open(clone.working_dir + '/_config.yml', 'w') as mm:
        yaml.dump(config, mm)

    with open(clone.working_dir + "/aio.md", "r") as f:
        contents = f.readlines()

    to_add = ['layout: page\n', 'permalink: /aio/\n']
    for i, line in enumerate(to_add):
        if line not in contents:
            contents.insert(i+1, line)
    contents = "".join(contents)

    with open(clone.working_dir + "/aio.md", "w") as f:
        f.write(contents)

    clone.git.add(update=True)
    clone.index.commit('add bits to _config.yml to allow translations.')

    # push repository
    clone.git.push("topush", f"gh_pages_theme")
    clone.git.push("topush", f"gh_pages_theme:{default_branch}")
    return True

def main(project):

    org, project = project.split('/')
    parent, clone, upstream, fork, submod, github_user = clone_repo_as_submodule(org, project)
    # add new remote with token so we can push
    new_url = fork.html_url.replace('://',
                                    f"://{github_user.login}:{os.environ['gh_access_token']}@")
    topush = next(filter(lambda x: x.name == 'topush', clone.remotes), None)
    if not topush:
        clone.create_remote("topush", url=new_url)
    default_branch = clone.head.ref.name

    changes = clean_wrong_format(clone.working_dir)
    if changes:
        branch_format = clone.create_head("update_format")
        clone.head.reference = branch_format
        clone.git.add(update=True)
        clone.index.commit(f"[translations] Fixed format that affects translations on {changes} file(s).")
        clone.git.push("topush", "update_format")
        # FIXME Create PR
        # NOTE - this only seem to work on repositories where I have permission.
        # upstream.create_pull("[translations] Clean lessons to create po files",
        #                      "The `po` files are the tokenised version of the lessons. The [tool we are using](https://github.com/carpentries-i18n/po4gitbook) complains if the following *typos* or empty lines at the end of sections are not fixed.",
        #                      default_branch,
        #                      'carpentries-i18n:update_format',
        #                      True)

    #TODO  Test if builds cleanly.
    themed = themetise_lesson(clone, default_branch)
    print(f"Check {fork.html_url}/settings to see whether page is building OK")

    if changes or themed:
        submod.binsha = submod.module().head.commit.binsha
        parent.index.add([submod])
        parent.index.commit(f"Updates {project} to include theme.")
        parent.git.push("origin", f"{project}")

    # TODO:
    # - Create PR with the formatting changes

if __name__ == "__main__":
    parser = ArgumentParser(description="Cleanup of repository according translation template")
    parser.add_argument('project', help='org/repo that you want to fork and theme from the carpentries')
    arguments = parser.parse_args()

    main(arguments.project)

    project = arguments.project.split('/')[1]
    print("If successful, run the following:")
    print(f"1. Generate the po with po4gitbook/update.sh")
    print(f"2. Break the file into chunks with python helpers/splitpot.py po/{project}.pot")
    print(f"3. Create a language directory on the transifex lesson directory: e.g., mkdir -p transifex/{project}/es")
    print(f"4. Build the transifex lesson: ")
    print(f"       - cd transifex/{project}")
    print(f"       - tx config mapping-bulk -p {project} --source-language en --type PO -f '.pot' \ ")
    print("                   --source-file-dir pot --expression \"<lang>/{filename}.po\" --execute ")
    print(f"5. Create the project {project} in transifex: https://www.transifex.com/carpentries-i18n/add/")
    print(f"6. Push the project to transifex: tx push -s --parallel")


# Clean up if something failed.
# 0. remove fork?
# 1. rm -rf lesson
# 2. back to the previous branch and delete previous. git branch -D lesson
# 3. remove modules: rm -rf .git/modules/lesson
# 4. remove if from .gitmodules if exists: sed -i '/lesson/d' .gitmodules
# 5. remove branch on i18n! https://github.com/carpentries-i18n/i18n/branches


# TODO as to add instructions
# 1. Travis is enable on all repositories at i18n
# 2. Need to set the keys
#   0. env vars: `export R_BROWSER='firefox'; export R_TRAVIS_COM="..."` (or in ~/.Renviron; usethis::edit_r_environ() )
#   a. `travis::browse_travis_token(endpoint = '.com')` => to get R_TRAVIS_COM
#   a. `travis::use_travis_deploy()` that needs of
#   b. `usethis::browse_github_token()` open gh url:  3692d98398c111a26d5c064db9651383ad438ba7
#   c. `export GITHUB_PAT="..."
#   "jkK_qnpSBpcKyw0ndldSLQ" - travis api
#   e. run: `travis::use_travis_deploy(remote='topush')` within the directory and sets everything.
#      it thows an error! But it seemed it work. The error is because doesn't recognise it is in a submodule!


# 1. Generate the po with po4gitbook/update.sh
# 2. Break the file into chunks with python helpers/splitpot.py po/r-intro-geospatial.pot
# 3. Create a language directory on the transifex lesson directory: e.g., mkdir -p transifex/r-intro-geospatial/es
# 4. Build the transifex lesson:
#        - cd transifex/r-intro-geospatial
#        - tx config mapping-bulk -p r-intro-geospatial --source-language en --type PO -f '.pot' \
#                    --source-file-dir pot --expression "<lang>/{filename}.po" --execute
# 5. Create the project r-intro-geospatial in transifex: https://www.transifex.com/carpentries-i18n/add/
# 6. Push the project to transifex: tx push -s --parallel
