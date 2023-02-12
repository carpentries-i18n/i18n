from argparse import ArgumentParser
from distutils import dir_util
import glob
import os
from pathlib import Path
import tempfile

from git import Repo
from github import Github, GithubException


def create_repo_tmp(path_files, tmpdirname):
    # 1 create tmp dir
    print(tmpdirname)
    # 2 move the files there
    dir_util.copy_tree(path_files, tmpdirname)
    # 3 create that dir as a repo
    repo = Repo.init(tmpdirname)
    repo.index.add(glob.glob(f'{tmpdirname}/**/*.md', recursive=True))
    repo.index.commit("First set of translations")
    return repo

def clone_repo_tmp(path_files, tmpdirname, gh_repo):
    repo = Repo.clone_from(gh_repo.html_url, tmpdirname)
    dir_util.copy_tree(path_files, tmpdirname)
    repo.index.add(glob.glob(f'{tmpdirname}/**/*.md', recursive=True))
    repo.index.commit("New set of translations")
    return repo

def update_local_repo(path_files, tmpdirname):
    repo = Repo(tmpdirname)
    dir_util.copy_tree(path_files, str(tmpdirname))
    repo.index.add(glob.glob(f'{tmpdirname.absolute()}/**/*.md', recursive=True))
    repo.index.commit("New set of translations")
    return repo


def init_gh():
    if os.environ['gh_access_token']:
        g = Github(os.environ['gh_access_token'])
    else:
        # ask for user name and password
        # g = Github(username, password)
        raise NotImplementedError
    github_user = g.get_user()
    return g, github_user

def extract_lesson_language(path_translation):
    *_, lang, lesson = path_translation.split('/')
    return (lang, lesson)
def convert_url(url, gh_user):
    ourl = url.replace('://',
                       f"://{gh_user.login}:{os.environ['gh_access_token']}@")
    return ourl

def main(path_translation, path_lesson):
    assert Path(path_translation).exists() and Path(path_lesson).exists(), \
        "Provided directories don't exist"
    g, user = init_gh()
    organization = g.get_organization("carpentries-i18n")
    lang, lesson = extract_lesson_language(path_translation)
    # 3) create submodule on path lesson under _locale/lang
    #   before commit, check whether the repo is in the right branch.
    lesson_repo = Repo(path_lesson)
    locale = Path(path_lesson) / '_locale'
    locale.mkdir(exist_ok=True)

    with tempfile.TemporaryDirectory() as tmpdirname:
        try:
            # 2) create repo on GH and push
            gh_repo = organization.create_repo(f'{lesson}-{lang}', auto_init=False)
            # 1) create repo on tmp
            repo = create_repo_tmp(path_translation, tmpdirname)
        except GithubException as e:
            if e.status == 422:
                # Repository exists already - clone and update
                gh_repo = g.get_repo(f'carpentries-i18n/{lesson}-{lang}')
                repo = update_local_repo(path_translation, locale / lang)
        origin_url = convert_url(gh_repo.html_url, user)
        origin = next(filter(lambda x: x.name == 'origin', repo.remotes), None)
        if origin:
            origin.set_url(origin_url)
        else:
            origin = repo.create_remote('origin', origin_url)
        origin.push('master')#('+refs/heads/*:refs/remotes/origin/*')
    # 4) create submodule from translation.
    locale_sm = next(filter(lambda x: x.name == lang, lesson_repo.submodules), None)
    if not locale_sm:
        locale_sm = lesson_repo.create_submodule(name=f'{lang}',
                                                 path=f'_locale/{lang}',
                                                 url=gh_repo.html_url)
        action = "Adds"
        locale_sm.update()
    else:
        action = "Updates"
        locale_sm.binsha = locale_sm.module().head.commit.binsha
        lesson_repo.index.add([locale_sm])

    lesson_repo.index.commit(f"[Translations] {action} {lang} language")
    # 5) push it!
    lesson_repo.remotes.topush.push()
    print(f"Repository {lesson_repo.remotes.origin.url} updated with {lang}.")

if __name__ == "__main__":
    parser = ArgumentParser(description="Move the translated files into its own repository and link it with the source")
    parser.add_argument('path_translation', help='the path to the generated md translated files')
    parser.add_argument('path_lesson', help='the path to the source lesson')
    arguments = parser.parse_args()

    main(arguments.path_translation, arguments.path_lesson)
