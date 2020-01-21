#! /bin/bash

pc_user=`whoami`
echo $pc_user account for pc `hostname`
git_user=`git config user.name`
echo $git_user account detected for git
next=false
create=false
update=false
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
            create=false
            next=true
            ;;
        -u|--update)
        shift
            update=true       
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
        -*)
            echo "Error: Invalid option: $op"
            exit 1
            ;;
    esac
done

if [[ update == true ]]; then
    if [[ create == true ]]; then
        echo "Warning: it is not recommended to --create and --update at the same time" 
    fi
    create=$create
fi

if [[ update == true ]] || [[ create == true ]]; then
    if [[ -z $repo ]]; then
        echo all available repos to update: $all_repos
    else
        echo repo to create or update: $repo
    fi
fi


echo create ${repo} : $create
echo update ${repo} : $update
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


if [[ create == true ]];then
    if [[ -d i18n ]]; then
        cd i18n
    fi
    wd = "${PWD##*/}"
    echo $wd
    if [[ $wd != "i18n" ]]; then  
    echo "create i18n directory"
    git clone https://github.com/${git_user}/i18n.git
    cd i18n
    fi
    
   echo "update local submodules"
   git submodule update --recursive --remote --merge

fi

if [[ update == true ]]; then
   echo "update local submodules"
   git submodule update --recursive --remote --merge 
fi
