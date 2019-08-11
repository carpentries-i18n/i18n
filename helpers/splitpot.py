from argparse import ArgumentParser
import glob
from pathlib import Path

# Input the lesson file that we want to split: splitplot.py lessonX.pot

# Create directory with the file name: lessonX.pot => lessonX/

# Save header in memory; read till first empty line

# Read first line, pattern: -> extract filename function
# #: lessonX/filename.md:YY
# if '#:' in line[:2]
#   read till `:` => line[:2]
# Add to the filename with a number, for later join them properly together. -> save as 01_[folder-name_]file.pot
# Keep searching for whitespaces, look next line, same filename? add to it.

def extract_filename(line):
    '''
    provides the filename of a file from the po sections, like:

    "#: /path/to/file/with/courious.name:55"

    parameters
    ----------
    line: a string containing a line with a filename.

    returns
    -------
    filename: the name of the file.
    '''
    if '#:' not in line[:2]:
        raise TypeError("The current line is not one that contains a filename.")
    line_bits = line.split(':')
    filename = line_bits[1].strip().split('/')[-1]
    return filename



class Pofiles:
    def __init__(self, filename):
        self.filename = self._check_filename(filename)
        self.lesson = self.filename.split('/')[-1].split('.')[0]

    def _check_filename(self, filename):
        # filename is a pot/po file?
        if '.po' not in filename[-4:]:
            raise TypeError(f"The file {filename} doesn't has the right extension (.pot/.po)")
        try:
            with open(filename, 'r') as file_handler:
                self.pot_content = file_handler.readlines()
            # TODO Check file follows the pot format standard
        except:
            raise TypeError("There's been some error reading the file")
        return filename

    def split(self, directory='transifex'):
        # Check the given directory exists, if not create it:
        split_directory = Path(directory)
        if not split_directory.is_dir():
            split_directory.mkdir(parents=True)
        # Create a directory for this lessons
        lesson_directory = split_directory / self.lesson
        lesson_directory.mkdir()
        first_blank = self.pot_content.index('\n')
        self.header = self.pot_content[:first_blank + 1]
        all_files = {} # To contain filename: [content]
        rest_file = self.pot_content[first_blank + 1:]
        file_sect = None

        for line in rest_file:
            if not file_sect:
                file_sect = extract_filename(line)
            if file_sect not in all_files.keys():
                all_files[file_sect] = self.header + [line]
            else:
                all_files[file_sect].append(line)
                if line == '\n':
                    file_sect = None

        # Write dictionary into files
        for order_file, (file_sect, content_sect) in enumerate(all_files.items()):
            with open(lesson_directory / f"{order_file:02d}__{file_sect}.pot", 'w') as section:
                section.writelines(content_sect)

    def join(self, source_dir, language):
        # TODO check that filenames are there to be joint
        # get all the files on source_dir/*.language.po
        list_translations = glob.glob(f"{source_dir}/*.{language}.po")
        list_translations.sort()
        # read them all and join them with a single header # NOTE should we join the header info too? (eg., authors)
        all_content = []
        for file_translated in list_translations:
            with open(file_translated, 'r') as section:
                lines = section.readlines()
            if all_content:
                lines = lines[lines.index('\n') + 1:]
            all_content.extend(lines)

        # path from the original filename
        path_filename = Path(self.filename).parent
        # Write file next to original with the language key.
        with open(path_filename / f"{self.lesson}.es.po", 'w') as full_translation:
            full_translation.writelines(all_content)

if __name__ == "__main__":
    command = ArgumentParser(description="Breaks a pot files into smaller chunks for better management for the translators.")
    command.add_argument('filename', help="pot file to be split.")
    command.add_argument('--join', '-j', dest='source', help="source directory from where to join split files")
    command.add_argument('--lang', '-l', dest='language', help="which language you want to combine")
    arguments = command.parse_args()

    pof = Pofiles(arguments.filename)

    if arguments.source and not arguments.language:
        command.error("--join requires --lang")

    if arguments.source and arguments.language:
        pof.join(arguments.source, arguments.language)
    else:
        pof.split()
