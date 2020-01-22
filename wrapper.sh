#! /bin/bash

### example
# sh wrapper.sh --repo make-novice --create

# create (implemented):      subroutine to create new PO files from an English lesson not currently being translated
# import (testing):          subroutine to pull a lesson being translated from remote to make changes locally
# render (work-in-progress): subroutine to render webpages from current PO files and export Japanese lessons to remote repos
# update (to-do later):      subroutine to pull updates from remote English lesson and merge based on archived ancestor (only new sections need to be translated)


pc_user=`whoami`
echo $pc_user account for pc `hostname`
git_user=`git config user.name`
git_email=`git config user.email`                                                            
echo $git_user \<${git_email}\> account detected for git
next=false
create=false
import=false
render=false
for op in "$@"; do
    if $next; then
        next=false;
        continue;
    fi
    case "$op" in
        -u|--user)
        shift
            if [[ $1 != "" ]]; then
                # pass different git user name to local account
                git_user="${1/%\//}"
                # keep username case-sensitive
                # git_user=`echo "$git_user" | tr '[:upper:]' '[:lower:]'`
                next=true
                shift
            else
                git_user=`git config user.name`
                next=true
            fi
            ;;
        -c|--create)
        shift
            create=true
            next=true
            ;;
        -i|--import)
        shift
            import=true       
            next=true
            ;;
        -r|--repo)
        shift
            if [[ $1 != "" ]]; then
                repo="${1/%\//}"       
                next=true
            else
                all_repo=true
                next=true
            fi
            ;;
       -w|--webpages)
        shift
            render=true
            next=true
            ;;
        -u|--update)
        shift
            import=true
            next=
        -*)
            echo "Error: Invalid option: $op"
            exit 1
            ;;
    esac
done

if [[ $import == true ]]; then
    if [[ $create == true ]]; then
        echo "Warning: it is not recommended to --create and --import at the same time" 
    fi
    create=$create
fi

if [[ $import == true ]] || [[ $create == true ]]; then
    if [[ -z $repo ]]; then
        echo all available repos to import: $all_repos
    else
        echo repo to create or import: $repo
    fi
fi


echo create ${repo} : $create
echo import ${repo} : $import
echo render webpages : $render

#check if remote i18n repo exists
root_dir=`git ls-remote https://github.com/$git_user/i18n.git | grep "ja" | wc -l`
echo i18 repo: $root_dir
if [ $root_dir -eq 1 ]; then
    echo "remote found:  https://github.com/$git_user/i18n.git"
elif [ $root_dir -eq 0 ]; then
    echo remote not found for user repo:  https://github.com/$git_user/i18n.git \n please create a fork
    exit 1
else
    echo ambiguous repo:
    git ls-remote https://github.com/$git_user/i18n.git
    exit 1
fi

if [[ $create == true ]]; then
    echo "runnning"
    if [[ -d i18n ]]; then
        cd i18n
    fi
    #check if current working directory is i18n
    wd="${PWD##*/}"
    echo $wd

    if [[ $wd != "i18n" ]]; then  
    echo "create i18n directory"
    git clone https://github.com/${git_user}/i18n.git
    cd i18n
    fi

    #checkout Japanese branch
    git checkout ja
    git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
    git pull swc-ja ja
   
    #import submodules
    git submodule init
    git submodule import
 
    echo "import local submodules"
    git submodule import --recursive --remote --merge

    if [[ ! -z $repo ]]; then
        if [[ -d $repo ]]; then
            echo submodule $repo found
        else
            git submodule add https://github.com/swcarpentry/${repo}.git
        fi
    fi
    if [[ -z $repo ]];then
        echo "warning $repo not found, specify --repo <lesson name> --create"
        exit 1
    fi

    echo "run import on po4gitbook"
    po4gitbook/import.sh > /dev/null 2>&1
    echo "upated PO files exported"
    if [[ -f po/${repo}.ja.po ]]; then
        echo "Warning: file po/${repo}.ja.po already exists: check for conflicts and import"
        exit 1
    else
        echo "creating PO file for $repo"
        cp po/${repo}.pot po/${repo}.ja.po 
        #fill in missing information for Japanese
        year=`date +%Y`
        sed -i '1s/# SOME DESCRIPTIVE TITLE./# Japanese translation of the Software Carpentry ${repo} Lesson/g' po/${repo}.ja.po
        sed -i "2s/# Copyright \(C\) YEAR THE PACKAGE\'S COPYRIGHT HOLDER/# Copyright \(C\) ${year} Software Carpentry Foundation; Japanese Translation Team/g" po/${repo}.ja.po
        sed -i '3s/# This file is distributed under the same license as the PACKAGE package./# This file is distributed under the same license as the git4pobook package./g'  po/${repo}.ja.po
        sed -i '4s/# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR./# ${git_user} <${git_email}>, ${year}./g' po/${repo}.ja.po
        sed -i '12s/"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"/"Last-Translator: ${git_user} <${git_email}>\n"/g'  po/${repo}.ja.po
        sed -i '13s/Language-Team: LANGUAGE <LL@li.org>\n/Language-Team: Japanese <tomkellygenetics@gmail.com>\n/g'  po/${repo}.ja.po
        sed -i '14 i "Language: ja\n"' po/${repo}.ja.po
        #remove Japanese from LINGUAS if already exists
        sed -i '1s/ ja//g' po/LINGUAS
        #add Japanese to LINGUAS
        sed -i '1s/$/ ja/g' po/LINGUAS 
    fi   
    echo "removing extraneous PO files"
    rm po/*.pot
    echo "run compile on po4gitbook to create new lessson"
    po4gitbook/compile.sh  > /dev/null 2>&1
    echo lesson $repo created in locale/ja/$repo
fi

if [[ $import == true ]]; then
    echo "runnning"
    if [[ -d i18n ]]; then
        cd i18n
    fi
    #check if current working directory is i18n
    wd="${PWD##*/}"
    echo $wd

    if [[ $wd != "i18n" ]]; then  
    echo "create i18n directory"
    git clone https://github.com/${git_user}/i18n.git
    cd i18n
    fi

    #checkout Japanese branch
    git checkout ja
    git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
    git pull swc-ja ja
   
    #import submodules
    git submodule init
    git submodule import
 
    echo "import local submodules"
    git submodule import --recursive --remote --merge

    if [[ ! -z $repo ]]; then
        if [[ -d $repo ]]; then
            echo "lesson repo found: ${repo} found"
        else
            echo "lesson repo ${repo} not found, run:\n sh wrapper.sh --repo ${repo} --create"
        fi
    fi
    if [[ -z $repo ]];then
        echo "warning $repo not found, specify --repo <lesson name> --import"
        exit 1
    fi

    if [[ -f po/${repo}.ja.po ]]; then
        echo "Warning: file po/${repo}.ja.po exists: please edit file and submit pull request"
        exit 0
    else
        echo "Warning: file po/${repo}.ja.po not found, run:\n sh wrapper.sh --repo ${repo} --create"
        exit 1
    fi   
fi

