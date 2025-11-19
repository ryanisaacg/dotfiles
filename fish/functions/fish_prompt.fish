set fish_color_ssh      yellow
set fish_color_cwd      cyan
set fish_color_git      magenta
set fish_color_hg_clean magenta
set fish_color_hg_dirty magenta
set fish_color_hg_modified magenta

set fish_color_success  green
set fish_color_failure  red

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'

set fish_prompt_hg_show_informative_status

# Status Chars
set __fish_git_prompt_char_dirtystate '?'
set __fish_git_prompt_char_stagedstate '!'
set __fish_git_prompt_char_untrackedfiles '.'
set __fish_git_prompt_char_stashstate '$'
set __fish_git_prompt_char_upstream_equal ''
set __fish_git_prompt_char_upstream_ahead ' ↑'
set __fish_git_prompt_char_upstream_behind ' ↓'
set __fish_git_prompt_char_upstream_diverged ' ↑↓'

set fish_prompt_hg_status_added $__fish_git_prompt_char_dirtystate
set fish_prompt_hg_status_modified $__fish_git_prompt_char_dirtystate
set fish_prompt_hg_status_deleted $__fish_git_prompt_char_dirtystate
set fish_prompt_hg_status_untracked $__fish_git_prompt_char_untrackedfiles

function prompt_section
    set_color $argv[1]
    printf '%s' $argv[2]
    set_color normal
end

function fish_jj_prompt
    jj log 2>/dev/null --no-graph --ignore-working-copy --color=never --revisions @ \
      --template '
      separate(
          " ",
          bookmarks.join(", "),
          change_id.shortest(),
          if(conflict, label("conflict", "×")),
          if(divergent, label("divergent", "??")),
          if(hidden, label("hidden prefix", "hidden")),
          if(immutable, label("node immutable", "◆")),
          label("description", if(description.len() == 0,
              "(no description)",
              if(description.first_line().len() > 40,
                  description.first_line().substr(0, 37).trim() ++ "...",
                  description.first_line()))),
          coalesce(
              if(
                  empty,
                  coalesce(
                      if(
                          parents.len() > 1,
                          label("empty", "(merged)"),
                      ),
                      label("empty", "(empty)"),
                  ),
              ),
          ),
      )
  '
end

function fish_prompt
    set last_status $status

    echo

    # Line 1
    prompt_section $fish_color_cwd (prompt_pwd)

    set git (fish_vcs_prompt ' ')
    if test -n "$git"
        printf ' on '
        prompt_section $fish_color_git $git
    end

    # Line 2
    echo
    [ $last_status -eq 0 ]; and set col $fish_color_success; or set col $fish_color_failure
    prompt_section $col 'λ '
end
