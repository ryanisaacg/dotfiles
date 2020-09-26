function edit
    # Check if there is already a running vim instance
    set jobline (jobs | grep 'vim' -m 1)
    # Get the job index from the job line
    set job (string match -r '\W+\w*' $jobline)
    if [ "$job" ]
        # Foreground the existing editor
        fg "$job"
    else
        # Launch a new editor instance
        vim
    end
end
