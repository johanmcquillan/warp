#!/usr/bin/env bash

set -eo pipefail

rc_file=""
case "$SHELL" in
    *bash)
        rc_file=".bashrc"
        ;;
    *zsh)
        rc_file=".zshrc"
        ;;
    *)
        echo "Unsupported shell: $SHELL" &> /dev/stderr
        echo "Please use either Bash or Zsh" &> /dev/stderr
        ;;
esac

curl https://raw.githubusercontent.com/johanmcquillan/warp/master/warp.sh -so "$HOME/.warp.sh"

if [ ! -f "$HOME/$rc_file" ]
then
    touch "$HOME/$rc_file"
fi

# If '$HOME/.warp' appears in the rc file, assume it's already installed.
grep '$HOME/.warp' "$HOME/$rc_file" &> /dev/null && exit

echo '
if [ -f "$HOME/.warp.sh" ]
then
    source "$HOME/.warp.sh"
fi' >> "$HOME/$rc_file"
