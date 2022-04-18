function review
    set pr (gh pr status --json number,title,url | jq ".createdBy|map(select(.number==$argv[1]))[0]")
    set title (echo "$pr" | jq ".title" -r)
    set url (echo "$pr" | jq ".url" -r)
    echo "Copied! $title $url"
    echo -n "$title $url" | pbcopy
end
