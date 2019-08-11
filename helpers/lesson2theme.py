from argparse import ArgumentParser
import os
import shutil

from git import Repo
from github import Github
from ruamel.yaml import YAML


def main(project):
    if os.environ['gh_access_token']:
        g = Github(os.environ['gh_access_token'])
    else:
        # ask for user name and password
        # g = Github(username, password)
        raise NotImplementedError
    github_user = g.get_user()

    # from carpentries URL git repo to new Repo in swc-i18n
    repo = g.get_repo(project)
    # Fork repository
    sw18n_org = [n for n in github_user.get_orgs() if "i18n" in n.login][0]
    # doesn't create it if it exists...
    myfork = sw18n_org.create_fork(repo)


    # Clone repository
    clone = Repo.clone_from(myfork.html_url, f'/tmp/{myfork.name}')

    # Clean repository
    # what's provided by theme
    dir_remove = ['_layouts', '_includes', '_episodes_rmd', 'assets', 'bin', 'code'] #, 'files']
    for entry in os.listdir(clone.working_dir):
        if entry in dir_remove and os.path.isdir(os.path.join(clone.working_dir, entry)):
            shutil.rmtree(os.path.join(clone.working_dir, entry))

    # add theme to `_config.yml`
    yaml = YAML()
    with open(clone.working_dir + '/_config.yml') as mm:
        config = yaml.load(mm)

    config.insert(1, 'remote_theme', "swcarpentry-i18n/carp-theme", comment="Theme URL")

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
    # add new remote with token
    new_url = myfork.html_url.replace('://',
                                      f"://{github_user.login}:{os.environ['gh_access_token']}@")
    clone.create_remote("topush", url=new_url)
    clone.git.push("topush")
    print(f"Check {myfork.html_url}/settings to see whether page is building OK")

    # TODO remove the repository cloned on /tmp/



if __name__ == "__main__":
    parser = ArgumentParser(description="Cleanup of repository according translation template")
    parser.add_argument('project', help='org/repo that you want to fork and theme from the carpentries')
    arguments = parser.parse_args()

    main(arguments.project)
