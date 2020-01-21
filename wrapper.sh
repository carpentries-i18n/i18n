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

echo create ${repo} : $create
echo create ${update} : $update
echo render webpages : $render
