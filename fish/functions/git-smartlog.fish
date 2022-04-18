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
        set branch_info (echo "$prs" | jq "map(select(.headRefName==\"$branch\"))[0]")
        if [ "$branch_info" != "null" ]
            set number (echo "$branch_info" | jq ".number")
            set title (echo "$branch_info" | jq ".title" -r)
            set cols (expr (tput cols) - 5)
            echo "$branch - [$number] $title" | sed "s/\(.\{$cols\}\).*/\1.../"
        else if contains "  origin/$branch" $remote_branches
            echo "$branch - Remote"
        else
            echo "$branch - Local"
        end
    end
end
