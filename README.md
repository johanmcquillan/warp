# Warp

Simple shell function to *warp* through your files.

Powered by [fzf](https://github.com/junegunn/fzf).

## Controls

| Input                         | Action                                |
| ----------------------------- | ------------------------------------- |
| Left                          | Go to parent directory                |
| Enter/Right/Tab/Forward Slash | Enter selected directory or open file |

## Installation

Simply run:
`curl https://raw.githubusercontent.com/johanmcquillan/warp/master/install.sh | bash`

### Requirements

#### Hard requirements

- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat)
- [exa](https://github.com/ogham/exa)

#### Soft requirements

- [ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter) (for displaying previews of images)

#### Notes

Only tested on Linux, macOS with Bash and zsh.
