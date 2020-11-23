#! /bin/bash

### example
# sh wrapper.sh --repo make-novice --locale ja --create
# sh wrapper.sh --repo make-novice --locale ja --import
# sh wrapper.sh --repo make-novice --locale ja --account GitHubUser --import
# sh wrapper.sh --repo r-novice-gapminder --locale ja --account swcarpentry-ja --import --webpages 

# create (implemented):      subroutine to create new PO files from an English lesson not currently being translated
# import (testing):          subroutine to pull a lesson being translated from remote to make changes locally
# webpages (testing): subroutine to render webpages from current PO files and export Japanese lessons to remote repos
# update (to-do later):      subroutine to pull updates from remote English lesson and merge based on archived ancestor (only new sections need to be translated)


pc_user=`whoami`
echo $pc_user account for pc `hostname`
git_user=`git config user.name`
remote_user=$git_user
git_email=`git config user.email`                                                            
remote_account=$git_user
echo $git_user \<${git_email}\> account detected for git
next=false
create=false
import=false
render=false
locale="default"
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
            ;;
        -i|--import)
        shift
            import=true       
            ;;
        -a|--account)
        shift
            if [[ $1 != "" ]]; then
                remote_user="${1/%\//}"       
                next=true
            else
                echo "specify remote account for: $git_user"
                remote_user=$git_user
                next=true
            fi
         shift
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
        shift
            ;;
        -l|--locale)
        shift
            if [[ $1 != "" ]]; then
                locale="${1/%\//}"
                next=true
                shift
            else
                next=true
            fi
            ;;
        -w|--webpages)
        shift
            render=true
            ;;
        -u|--update)
        shift
            update=true
            ;;
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

if [[ -z $locale ]] || [[ ! ${#locale} -eq 2 ]] && [[ ! ${#locale} -eq 5 && $locale==*"_"* ]]; then
    echo "must specify locale with \"--locale xx\" or \"--locale xx_YY\"  for example:
          English(Great Britain) (en_GB),
          Deutsche (de),
          Español (es),
          Français (fr),
          हिन्द(hi_IN),
          한국어(ko_KR),
          日本語 (ja),
          Nederlands (nl)
          Português(Brasil) (pt_BR)
          中文(中华人民共和国) (zh_CN)
          中文(中華民國) (zh_TW)
        See here for a full list: http://docs.wp-event-organiser.com/i18n/locale-codes/
        Note that Endonyms are often used (not English names)." 
    exit 1
else
    lang=$(echo $locale | cut -d"_" -f1 | tr '[:upper:]' '[:lower:]')
    if [[ ${#locale} -eq 5 && $locale==*"_"* ]]; then
         country=$(echo $locale | cut -d"_" -f2 | tr '[:lower:]' '[:upper:]')
         locale=${lang}_${country}
    else
        locale=${lang}
    fi    
    if [[ $locale == "ja_JP" ]]; then
        locale="ja"
    fi
    if [[ $locale == "en_US" ]]; then
        locale="en"
    fi
    if [[ $locale == "es_LA" || $locale == "es_419" ]]; then
        locale="es"
    fi
    if [[ $locale == "nl_NL" ]]; then
        locale="nl"
    fi
    echo "locale: $locale"
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
echo https://github.com/${remote_user}/i18n.git 
root_dir=`git ls-remote https://github.com/${remote_user}/i18n.git | grep "${locale}$" | wc -l`
echo i18n repo: $root_dir
if [ $root_dir -eq 1 ]; then
    echo "remote found:  https://github.com/${remote_user}/i18n.git"
elif [ $root_dir -eq 0 ]; then
    echo remote not found for user repo:  https://github.com/${remote_user}/i18n.git \n please create a fork and ${locale} branch
    exit 1
else
    echo ambiguous repo:
    git ls-remote https://github.com/${remote_user}/i18n.git
    exit 1
fi

#check if remote repo exists
root_dir=`git ls-remote https://github.com/${remote_user}/${repo}.git | grep "gh-pages$" | wc -l`
echo $repo repo: $root_dir
if [ $root_dir -eq 1 ]; then
    echo "remote found:  https://github.com/${remote_user}/${repo}.git"
elif [ $root_dir -eq 0 ]; then
    echo remote not found for user repo:  https://github.com/${remote_user}/${repo}.git \n please create a fork
    exit 1
else
    echo ambiguous repo:
    git ls-remote https://github.com/${remote_user}/${repo}.git
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
    git clone https://github.com/${remote_user}/i18n.git
    cd i18n
    fi
    git pull origin ${locale}

    #checkout Japanese branch
    git checkout ${locale}
    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]; then
        git remote remove remote-repo
    fi
    if [[ -z $GITHUB_TOKEN ]]; then
        url=https://github.com/${remote_user}/i18n.git
    else
        url="https://${git_user}:${GITHUB_TOKEN}@github.com/${git_user}/i18n.git"
    fi
    git remote add remote-repo $url
    git pull remote-repo ${locale}
   
    #import submodules
    git submodule init
    git submodule add git@github.com:${remote_user}/${repo}
 
    echo "update local submodules"
    git submodule update -f --recursive $repo

    #remove _locale directory (only translate English lessons)
    for dir in `git submodule |  grep "^+"  | cut -d" " -f2`
        do
        if [ -d $dir ]
            then
            cd $dir
            if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
                then
                git remote remove remote-repo
            fi
            #reset all repos to remote
            if [[ -z $GITHUB_TOKEN ]]; then
                url=https://github.com/${remote_user}/${dir}.git
            else
                url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/${dir}.git"
            fi
            git remote add remote-repo $url
             if [[ `git branch -v | grep "master" | wc -l` -ge 1 ]]
                then
                git pull master -f
            fi
            git remote add remote-repo $url                                          
            if [[ `git branch -v | grep "gh-pages" | wc -l` -ge 1 ]]
                then
                git branch -D gh-pages
            fi
            git checkout -b gh-pages  `git rev-list HEAD | tail -n 1`
            git pull remote-repo gh-pages -f
            git add -u
            git commit -m "reset branch"
            git checkout HEAD
            rm -rf _locale
            cd ..
        fi
    done


    if [[ ! -z $repo ]]; then
        if [[ -d $repo ]]; then
            echo submodule $repo found
        else
            git submodule add git@github.com:${remote_user}-${locale}/{repo}.git
        fi
    fi
    if [[ -z $repo ]];then
        echo "warning $repo not found, specify --repo <lesson name> --create"
        exit 1
    fi

    echo "run import on po4gitbook"
    po4gitbook/import.sh > /dev/null 2>&1
    echo "upated PO files exported"
    if [[ -f po/${repo}.${locale}.po ]]; then
        echo "Warning: file po/${repo}.${locale}.po already exists: check for conflicts and import"
        exit 1
    else
        echo "creating PO file for $repo"
        cp po/${repo}.pot po/${repo}.${locale}.po 
        git add  po/${repo}.${locale}.po
        #archive PO file from English lessons for merging updates
        if [[ -f po/.ancestors/.${repo}.jp.po.ancestor ]]; then
            echo "Warning file po/${repo}.${locale}.po already archived in po/.ancestors"
       else
            echo "archiving PO file for $repo"
            mkdir -p po/.ancestors
            cp po/${repo}.pot po/.ancestors/.${repo}.${locale}.po.ancestor
            git add po/.ancestors/.${repo}.${locale}.po.ancestor
       fi

        #fill in missing information for Japanese
        year=`date +%Y`
        sed -i '1s/# SOME DESCRIPTIVE TITLE./# Japanese translation of the Software Carpentry ${repo} Lesson/g' po/${repo}.${locale}.po
        sed -i "2s/# Copyright \(C\) YEAR THE PACKAGE\'S COPYRIGHT HOLDER/# Copyright \(C\) ${year} Software Carpentry Foundation; Japanese Translation Team/g" po/${repo}.${locale}.po
        sed -i '3s/# This file is distributed under the same license as the PACKAGE package./# This file is distributed under the same license as the git4pobook package./g'  po/${repo}.${locale}.po
        sed -i '4s/# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR./# ${git_user} <${git_email}>, ${year}./g' po/${repo}.${locale}.po
        sed -i '12s/"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"/"Last-Translator: ${git_user} <${git_email}>\n"/g'  po/${repo}.${locale}.po
        sed -i '13s/Language-Team: LANGUAGE <LL@li.org>\n/Language-Team: Japanese <tomkellygenetics@gmail.com>\n/g'  po/${repo}.${locale}.po
        sed -i '14 i "Language: ${locale}\n"' po/${repo}.${locale}.po
        #remove Japanese from LINGUAS if already exists
        sed -i '1s/ ${locale}//g' po/LINGUAS
        #add Japanese to LINGUAS
        sed -i '1s/$/ ${locale}/g' po/LINGUAS 
    fi   
    git add  po/${repo}.${locale}.po
    echo "removing extraneous PO files"
    rm po/*.pot
    echo "run compile on po4gitbook to create new lessson"
    po4gitbook/compile.sh  > /dev/null 2>&1
    echo lesson $repo created in _locale/${locale}/$repo

    #restore _locale directory (only translate English lessons)
    for dir in `git submodule |  grep "^+"  | cut -d" " -f2`
        do
        if [ -d $dir ]
            then
            cd $dir
            git reset --hard
            cd ..
        fi
    done

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
    git clone https://github.com/${remote_user}/i18n.git
    cd i18n
    fi

    #checkout Japanese branch
    git checkout ${locale}
    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
        then
        git remote remove remote-repo
    fi
    git remote add remote-repo https://github.com/${remote_user}/i18n.git
    git pull remote-repo ${locale}
   
    #import submodules
    git submodule init
    git submodule foreach 'git pull remote-repo'       
    git submodule add https://github.com/${remote_user}/${repo}.git
 
    echo "update local submodules"
    git submodule update -f --recursive

    #remove _locale directory (only translate English lessons)
    for dir in `git submodule |  grep "^+"  | cut -d" " -f2`
        do
        if [ -d $dir ]
            then
            cd $dir
            if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
                then
                git remote remove remote-repo
            fi
            #reset all repos to remote
            if [[ -z $GITHUB_TOKEN ]]; then
                url=https://github.com/${remote_user}/${dir}.git
            else
                url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/i18n.git"
            fi
            git remote add remote-repo $url                                          
             if [[ `git branch -v | grep "master" | wc -l` -ge 1 ]]
                then
                git pull master -f      
            fi
            git remote add remote-repo $url
            if [[ `git branch -v | grep "gh-pages" | wc -l` -ge 1 ]]
                then
                git branch -D gh-pages
            fi
            git checkout -b gh-pages  `git rev-list HEAD | tail -n 1`
            git pull remote-repo gh-pages -f
            git add -u
            git commit -m "reset branch"
            git checkout HEAD
            rm -rf _locale
            cd ..
        fi
    done


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

    if [[ -f po/${repo}.${locale}.po ]]; then
        echo "Warning: file po/${repo}.${locale}.po exists: please edit file and submit pull request"
        exit 0
    else
        echo "Warning: file po/${repo}.${locale}.po not found, run:\n sh wrapper.sh --repo ${repo} --create"
        exit 1
    fi   
fi

if [[ $render == true ]]; then
    echo "runnning"
    if [[ -d i18n ]]; then
        cd i18n
    fi
    #check if current working directory is i18n
    wd="${PWD##*/}"
    echo $wd

    if [[ $wd != "i18n" ]]; then
    echo "create i18n directory"
    git clone https://github.com/${remote_user}/i18n.git
    cd i18n
    fi

    #checkout Japanese branch
    git checkout ${locale}
    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
        then
        git remote remove remote-repo
    fi
    if [[ -z $GITHUB_TOKEN ]]; then
        url=https://github.com/${remote_user}/i18n.git
    else
        url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/i18n.git"
    fi
    git remote add remote-repo $url
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git pull remote-repo ${locale}
    fi

    #import submodules
    git submodule init
    git submodule add https://github.com/${remote_user}/${repo}.git

    echo "import local submodules"
    git submodule update -f --recursive

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

    if [[ -f po/${repo}.${locale}.po ]]; then
        echo "File po/${repo}.${locale}.po exists: exporting translated lesson"
    else
        echo "Warning: file po/${repo}.${locale}.po not found, run:\n sh wrapper.sh --repo ${repo} --create"
        exit 1
    fi   

    #correct dates in headers
    year=`date +%Y`
    past_year=$(( $year-1 ))
    #replace past year with current year
    sed -i "2s/$past_year/$year/g" po/*.po
    # append current year if different to previous year
    sed -i "4s/, ${past_year}\./, ${past_year}, ${year}./g" po/*po

    #create all Japanese lessons
    mkdir -p locale
    mkdir -p locale/${locale}    
    echo "run compile on po4gitbook"
    po4gitbook/compile.sh > /dev/null 2>&1

    #commit updates to source PO files
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git pull remote-repo ${locale}
    fi
    git add -u po/*${locale}.po
    git commit -m "update PO files"
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git push remote-repo ${locale}
    fi

    echo "translated lessons from  po/${repo}.${locale}.po  exported to _locale/${locale}/$repo"

    #check if remote translated lesson exists 
    lesson_dir=`git ls-remote https://github.com/${remote_user}/${repo}-${locale}.git | grep "master" | wc -l`
    echo ${repo}-${locale} repo: $lesson_dir
    if [ $lesson_dir -eq 1 ]; then
        echo "remote found:  https://github.com/${remote_user}/${repo}-${locale}.git"
    elif [ $root_dir -eq 0 ]; then
        echo remote not found for user repo:  https://github.com/${remote_user}/${repo}-${locale}.git please create a new empty repo
        exit 1
    else
        echo ambiguous repo:
        git ls-remote https://github.com/${remote_user}/${repo}-${locale}.git
        exit 1
    fi
   
    #create as submodule
    #git submodule add https://github.com/${remote_user}/${repo}-${locale}.git _locale/${locale}/$repo
    ##git submodule absorbgitdirs <path>

    #create external ${locale} repo
    mkdir -p ../${repo}-${locale}

    #add update lessons to remote
    cd ../${repo}-${locale}
    git init
    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
        then
        git remote remove remote-repo
    fi
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -le 0 ]]; then
        if [[ -z $GITHUB_TOKEN ]]; then
            url=https://github.com/${remote_user}/${repo}-${locale}.git
        else
            url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/${repo}-${locale}.git"
        fi
        git remote add remote-repo $url
    fi
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git pull remote-repo master
    fi

    #move files to external repo
    rsync -r ../i18n/locale/${locale}/${repo}/*md .
    rsync -r ../i18n/locale/${locale}/${repo}/_episodes/*md _episodes
    rsync -r ../i18n/locale/${locale}/${repo}/_extras/*md _extras

    #correct links for locale
    sed -i "s/permalink: \/conduct\//permalink: \/${locale}\/conduct\//g" CODE_OF_CONDUCT.md
    sed -i "s/permalink: \/conduct\//permalink: \/${locale}\/conduct\//g" CONDUCT.md
    sed -i "s/permalink: \/aio\//permalink: \/${locale}\/aio\//g" aio.md
    sed -i "s/root: \.$/root: \/${locale}\/\npermalink: \/${locale}\/index.html/g" index.md
    sed -i "s/permalink: \/setup\//permalink: \/${locale}\/setup\//g" setup.md
    sed -i "s/permalink: \/reference\//permalink: \/${locale}\/reference\//g" reference.md
    sed -i "s/permalink: \/about\//permalink: \/${locale}\/about\//g " _extras/about.md
    sed -i "s/permalink: \/discuss\//permalink: \/${locale}\/discuss\//g " _extras/discuss.md
    sed -i "s/permalink: \/figures\//permalink: \/${locale}\/figures\//g " _extras/figures.md
    sed -i "s/permalink: \/guide\//permalink: \/${locale}\/guide\//g " _extras/guide.md

    # remove files provided by template
    rm -rf bin/boilerplate
    rm -rf _layouts _includes _episodes_rmd assets bin code 

    git add *
    git commit -m "update lesson files"
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -le 0 ]]; then
        if [[ -z $GITHUB_TOKEN ]]; then
            url=https://github.com/${remote_user}/${repo}-${locale}.git
        else
            url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/${repo}-${locale}.git"
        fi
        git remote add remote-repo $url
    fi
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
       git push remote-repo master
    fi
    echo "lesson $repo-${locale} pushed to ${remote_user}/$repo-${locale}"

    #update original lesson to import translated content
    cd ../i18n # or English lesson
    # restore to version from remote
    git submodule update -f --recursive

    if [[ ! -d ../${repo} ]]; then
        if [[ -z $GITHUB_TOKEN ]]; then
            url=$(echo "https://github.com/${remote_user}/${repo}.git")
        else
            url=$(echo "https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/${repo}.git")
        fi
        git clone -b gh-pages $url ../${repo}
    fi

    #create external repo
    mkdir -p ../${repo}

    #add update lessons to remote
    cd ../${repo}
    git init
    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
        then
        git remote remove remote-repo
    fi
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -le 0 ]]; then
        if [[ -z $GITHUB_TOKEN ]]; then
            url=https://github.com/${remote_user}/${repo}.git
        else
            url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/${repo}.git"
        fi
        git remote add remote-repo $url
    fi
    if [[ `git branch -v | grep "gh-pages" | wc -l` -le 0 ]]; then
         git checkout -b gh-pages
         #git checkout `git rev-list --max-parents=0 HEAD | tail -n 1` -b gh-pages
    fi
    git checkout gh-pages
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git pull remote-repo gh-pages
        git submodule update -f --recursive 
    fi

    #rename code of conduct if needed
    if [ -f CODE_OF_CONDUCT.md ]; then
        mv CODE_OF_CONDUCT.md CONDUCT.md
    fi

    #update links
    # add title if missing
    sed -i "3s/root: \./Title: "Licenses"\nroot: \./g" LICENSE.md
    sed -i "3s/root: \./Title: "Contributor Code of Conduct"\nroot: \./g" CONDUCT.md
    sed -i "3s/root: \./Title: "Reference"\nroot: \./g" reference.md
    sed -i "3s/root: \./Title: "Setup"\nroot: \./g" setup.md

    # add root if missing
    sed -i "3s/---/root: \/\n---/g" index.md
    sed -i "3s/root: \./root: \//g" index.md
    sed -i "4s/---/root: \.\n---/g" LICENSE.md CONDUCT.md 
    sed -i "4s/---/root: \.\.\n---/g" reference.md setup.md 
    sed -i "3s/---/root: \.\n---/g" LICENSE.md CONDUCT.md
    sed -i "3s/---/root: \.\.\n---/g" reference.md setup.md
    sed -i "3s/---/root: \.\n---/g" aio.md 

    # add permlink if missing
    sed -i "s/root\: \/\$/root\: \/\npermalink\: index.html/g" index.md
    sed -i "s/root\: \.\$/root\: \.\npermalink\: \/LICENSE\//g" LICENSE.md
    sed -i "s/root\: \.\$/root\: \.\npermalink\: \/conduct\//g"  CONDUCT.md
    sed -i "s/root\: \.\.\$/root\: ..\npermalink\: \/reference\//g"  reference.md
    sed -i "s/root\: \.\.\$/root\: ..\npermalink\: \/setup\//g"  setup.md
    sed -i "s/root\: \.\.\$/root\: ..\npermalink\: \/aio\//g"  aio.md

    # remove if appears twice
    sed -i '5{/permalink: index\.html/d;}' index.md
    sed -i '6{/permalink\: \/LICENSE\//d;}' LICENSE.md
    sed -i '6{/permalink\: \/conduct\//d;}' CONDUCT.md
    sed -i '6{/permalink\: \/reference\//d;}' reference.md
    sed -i '6{/permalink\: \/setup\//d;}' setup.md
    sed -i '5{/permalink\: \/aio\//d;}' aio.md

    #add changes
    git add -u
    git add index.md CONDUCT.md LICENSE.md reference.md setup.md aio.md

    git submodule update -f --recursive
    git submodule add https://github.com/${remote_user}/${repo}.git  ./_locale/${locale}

    cd _locale/${locale}
    git init

    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
        then
        git remote remove remote-repo
    fi

    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -le 0 ]]; then
        git remote add remote-repo  https://github.com/${remote_user}/${repo}-${locale}.git
    fi

    if [[ `git branch -v | grep "master" | wc -l` -le 0 ]]; then
         git checkout -b master
    fi
    git checkout master

    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git pull remote-repo master
    fi

    if [[ `git branch -v | grep "master" | wc -l` -le 0 ]]; then
         git checkout -b master
    fi

    git checkout master
    cd ../..
    #push updated _locale lessons to English lesson
    git checkout gh-pages
    git pull remote-repo gh-pages
    git add -u 
    git commit -m "update Japanese lessons"
    if [ `git remote | grep "remote-repo" | wc -l` -ge 1 ]
        then
        git remote remove remote-repo
    fi
    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -le 0 ]]; then
        if [[ -z $GITHUB_TOKEN ]]; then
            url=https://github.com/${remote_user}/${repo}.git
        else
            url="https://${git_user}:${GITHUB_TOKEN}@github.com/${remote_user}/${repo}.git"
        fi
        git remote add remote-repo $url
    fi

    remotes=`git remote | grep "remote-repo" | wc -l`
    if [[ remotes -ge 1 ]]; then
        git push remote-repo gh-pages
        echo "lesson $repo pushed to ${remote_user}/$repo with locale $repo-${locale}"
    fi

    cd ../i18n

git submodule update -f --recursive  

fi

echo "run complete!"
