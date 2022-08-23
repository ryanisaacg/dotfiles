function git_smartlog
    set branches (git for-each-ref --format='%(refname:short)' refs/heads)
    set remote_branches (git branch -r)
    set prs (gh pr status --json headRefName,number,title | jq '.createdBy')
    set current (git branch --show-current)
    for branch in $branches
        if [ "$branch" = "$current" ]
            echo -n "* "
        else
            echo -n "  "
        end
        set commits_behind (git rev-list --left-only --count origin/dev...$branch)
        set commits_ahead (git rev-list --right-only --count origin/$branch...$branch 2>&1)
        # TODO: clean this up, current logic is a mess
        if [ $status = 0 ]; and [ "$commits_ahead" != "0" ];
            if [ "$commits_behind" = "0" ]
                set commits " ↑$commits_ahead"
            else
                set commits " B$commits_behind|↑$commits_ahead"
            end
        else
            if [ "$commits_behind" = "0" ]
                set commits ""
            else
                set commits " B$commits_behind"
            end
        end
        set branch_info (echo "$prs" | jq "map(select(.headRefName==\"$branch\"))[0]")
        set prefix "$branch [$commits] -"
        if [ "$branch_info" != "null" ]
            set number (echo "$branch_info" | jq ".number")
            set title (echo "$branch_info" | jq ".title" -r)
            set cols (expr (tput cols) - 5)
            echo "$branch$commits - [$number] $title" | sed "s/\(.\{$cols\}\).*/\1.../"
        else if contains "  origin/$branch" $remote_branches
            echo "$branch$commits - Remote"
        else
            echo "$branch$commits - Local"
        end
    end
end
