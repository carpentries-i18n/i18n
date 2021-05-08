#

# After split the updated source pot file, compare with downloaded translations
from argparse import ArgumentParser
import os
import datetime
import glob
import logging
from pathlib import Path
import subprocess

from github import Github, GithubException

from outdated2md import generate_output
from trans2lesson import init_gh

LESSONS_PROJECTS = (Path(os.path.dirname(__file__)).absolute() / '..' / 'transifex').resolve()

def select_lesson(lesson=None):
    lessons = sorted(glob.glob(f"{LESSONS_PROJECTS}/*"))
    lessons_names = [x.split('/')[-1] for x in lessons]

    if lesson:
        if lesson in lessons_names:
            return Path(lessons[lessons_names.index(lesson)]).resolve()
        else:
            logging.critical(f"The lesson: {lesson} hasn't been found, prompting for manual selection.")

    for i, lesson in enumerate(lessons_names, start=1):
        print(f" {i:3d}: {lesson}")
    try:
        select = int(input("Select which lesson to generate output: ")) - 1
        assert select >= 0
        selected_lesson = lessons[select]
    except (ValueError, IndexError, AssertionError):
        raise ValueError(f"Value entered is not a valid input - select a value between 1-{len(lessons)}" )

    return Path(selected_lesson).resolve()

def generate_updates(lesson_path):
    """

    This is a semi-python way to do the following:

   * merge the new template with the previous translations:
    `for i in $(find ./pot/ -type f -printf '%P\n'); do lang='es'; msgmerge -U ${lang}/${i/md.pot/po} pot/${i}; done`

   * Obtain which translations has been marked as obsolete:
    `grep -E '^#~' 04__01-introduction.po`
    read this for more information about obsoleted translations:  http://pology.nedohodnik.net/doc/user/en_US/ch-poformat.html#sec-poobsol

    """


    # find current languages:
    languages = [x.split('/')[-1] for x in sorted(glob.glob(f"{lesson_path}/*"))]
    languages.remove('pot')
    updated_templates = sorted(glob.glob(f"{lesson_path}/pot/*.pot"))

    print(f" {len(languages)} translations found for {lesson_path.name}")
    languages = ['es']
    outdated = {}
    for i, lang in enumerate(languages, start=1):
        outdated[lang] = {}
        print(f" {i:3d}: {lang}")
        for template in updated_templates:
            trans_file = template.replace('md.pot', 'po').replace('/pot/', f"/{lang}/")
            trans_file_name = trans_file.split('/')[-1]
            each_file = subprocess.run(["msgmerge", "-U", f"{trans_file}", f"{template}"], capture_output=True)
            if each_file.stdout:
                logging.info(f"file: {trans_file_name} for {lang} produced this output\n\t {each_file.stdout}")
            if each_file.stderr and b'done' not in each_file.stderr:
                logging.critical(f"file: {trans_file_name} for {lang} produced an error\n\t {each_file.stderr}")
            outdated_find = subprocess.run(f"grep -E '^#~' {trans_file}", capture_output=True, shell=True)
            #print(outdated_find)
            if outdated_find.stdout:
                outdated[lang][trans_file_name] = outdated_find.stdout.decode()
            if outdated_find.stderr:
                logging.critical(f"file: {trans_file_name} for {lang} produced an error while grepping\n\t {outdated_find.stderr}")

    return outdated

def issue_content(language, updates):
    output = []
    if not updates[language]:
        return
    output.append("# Obsolete translations from last update")

    desc = "The last update from upstream  - [#XX]();  FIXME (add link to gitref/PR?) - has made the following translations obsoleted"
    output.append(desc)

    for file_name, file_content in updates[language].items():
        output.append(f"### {file_name}")
        output.append(generate_output(file_content))

    return "\n\n".join(output)


def create_issue(lesson, language, content, g):
    today = datetime.datetime.now()
    org_repo = f"carpentries-i18n/{lesson}-{language}"
    repo = g.get_repo(org_repo)
    # TODO: define a label to tag obsolete translations.
    # label = repo.get_label("My Label")
    title = f"New obsolete translations - {today:%Y-%m-%d}"
    print(f"The following issue will be created at {org_repo}")
    print(f"# {title}")
    print(content)
    confirm = input("Do you want to create the issue? [y/N] ")
    if confirm.upper in ['Y', 'YES']:
        issue = repo.create_issue(title=title , body=content)
        # labels=[label]
        logging.info(f"Issue #{issue.number} created: {issue.html_url}")
    else:
        logging.info("Issue not created.")


def main(lesson=None):
    g, user = init_gh()
    logging.basicConfig(level=logging.INFO)
    lesson_path = select_lesson(lesson)
    outdated = generate_updates(lesson_path)
    for lang in outdated:
        content = issue_content(lang, outdated)
        if content:
            create_issue(lesson_path.name, lang, content, g)

if __name__ == "__main__":
    parser = ArgumentParser(description="Analyse the new updates for a particular lesson")
    parser.add_argument('--lesson', "-l", help='the lesson to analyse')
    arguments = parser.parse_args()

    main(arguments.lesson)
