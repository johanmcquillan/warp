#!/usr/bin/env bash

# Check dependencies.
_warp_dependencies=(fzf bat exa isutf8 ascii-image-converter)
for dependency in $_warp_dependencies
do
    if ! which $dependency &> /dev/null
    then
        echo "warp: Failed to source: '${dependency}' not installed" 1>&2
        return 1
    fi
done

# _warp prompts the user to choose one of the files or directories.
function _warp {
    # To get consistent colours when running `ls` on MacOS we use `gls` if it is installed.
    local _warp_ls='ls'
    if which gls &> /dev/null
    then
        _warp_ls='gls'
    fi

    # Use exa for detailed previews inside folders.
    _warp_exa='exa -la --group-directories-first --color=always --no-filesize --no-user --no-permissions'

    # Run `fzf` from `ls` output.
    # We use `ls` instead of `exa` because it shows `.` and `..`.
    # We add bindings:
    #   tab: accept (would be nice if this did a tab completion)
    #   right: accept
    #   left: select and accept `..`
    $_warp_ls -ap --group-directories-first --color | \
        fzf --height 70% --ansi --reverse --cycle \
        --bind=tab:accept-non-empty,right:accept-non-empty,left:first+down+accept \
        --preview-window=right:70% \
        --preview="
            [ -d {} ] && $_warp_exa {} ||
            (file -b --mime-type {} 2> /dev/null | grep image &> /dev/null && ascii-image-converter --complex --color -W "'$FZF_PREVIEW_COLUMNS'" {}) ||
            ($_warp_exa {} && bat --style=plain --force-colorization --tabs=4 {})"
}

# _warp_gwd returns a compact format of `pwd`, truncated on the left to the current git repo.
# Errors if not in git repo.
function _warp_gwd {
    gwd="$(git rev-parse --show-toplevel 2> /dev/null)" || return 1
    local repo_name="$(basename $gwd)"
    echo "${repo_name}${PWD/#$gwd}/"
}

# _warp_wd returns a compact format of `pwd`, with `~` shown instead of the full value of $HOME.
function _warp_wd {
    local wd="${PWD/#$HOME}"
    if [[ "$wd" == "$PWD" ]]
    then
        # $HOME is not a prefix of $PWD, so just return unchanged $PWD.
        echo "${PWD}/"
    else
        echo "~$wd/"
    fi
}

# _warp_pwd returns a compact format of `pwd`.
function _warp_pwd {
    _warp_gwd || _warp_wd
}

# warp is the public function that provides a GUI for navigating a file system.
# It accepts an optional argument for where to start traversing files.
function warp {
    local cursor_up="\033[1A"
    local erase="\033[K"
    local prose_color="\033[38;5;35m"
    local path_color="\033[38;5;69m"
    local file_color="\033[38;5;214m"
    local reset="\033[0m"
    if [ -n "$1" ]
    then
        cd "$1" || return
    fi
    echo
    while true
    do
        echo -e "${cursor_up}${erase}${prose_color}Warping${reset} -> ${path_color}$(_warp_pwd)${reset}"
        choice=$(_warp) || return
        if [[ "$choice" == "./" ]]
        then
            # Selected current working directory, so simply exit.
            return
        fi
        if [[ ! -d "$choice" ]]
        then
            # Selected a file.
            if [[ -z "$EDITOR" ]] 
            then
                echo "warp: Failed to open $PWD/$choice: "'$EDITOR is not set' 1>&2
                return 1
            fi
            if ! isutf8 "$PWD/$choice" &> /dev/null
            then
                echo "warp: Not opening $PWD/$choice: non-text format" 1>&2
                return
            fi
            echo -e "${cursor_up}${erase}${prose_color}Warping${reset} -> ${path_color}$(_warp_pwd)${reset}${file_color}${choice}${reset}"
            "$EDITOR" "$PWD/$choice"
            return
        fi

        cd "$PWD/$choice" || return
    done
}
