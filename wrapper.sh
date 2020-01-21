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
            if [[ $1 != "" ]]; then
                create=true
                next=true
            else
                create=false
                next=true
            fi
            ;;
        -u|--update)
        shift
            if [[ $1 != "" ]]; then
                update=true       
                next=true
            else
                update=false
                next=true
            fi
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
            if [[ $1 != "" ]]; then
                render=true
                next=true
            else
                render=false
                next=true
            fi
            ;;
        -*)
            echo "Error: Invalid option: $op"
            exit 1
            ;;
    esac
done

echo create ${repo} : $create
echo create ${update} : $update
echo render webpages : $render
