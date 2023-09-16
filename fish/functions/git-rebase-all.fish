function git-rebase-all
    echo "* Pulling latest from origin..."
    git checkout main
    git pull
    set branches (git for-each-ref --format='%(refname:short)' refs/heads)
    echo "* Looping over your branches..."
    set prs (gh pr status --json headRefName,number,title | jq '.createdBy')
    for branch in $branches
        if [ "$branch" = "main" ]
            continue
        end
        git checkout $branch
        set branch_info (echo "$prs" | jq "map(select(.headRefName==\"$branch\"))[0]")
        if [ "$branch_info" != "null" ]
            echo "This branch is pushed to GitHub! Recommend merge instead of rebase"
        end
        read -l -P 'Rebase, merge, or skip this branch? quit? [R/m/s/q] ' action
       switch $action
          case R r ''
            git rebase -i main
          case M m
            git merge main
          case S s
          case Q q
            break
        end
        if test $status -ne 0
            read -l -P "Likely merge conflict occurred; resolve and hit 'enter'" _
        end
    end
end
