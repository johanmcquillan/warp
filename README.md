# Warp

Simple shell function `warp` to travel through your files at warp speed.

Powered by [fzf](https://github.com/junegunn/fzf).

## Controls

| Input                         | Action                                |
| ----------------------------- | ------------------------------------- |
| Left                          | Go to parent directory                |
| Enter/Right/Tab/Forward Slash | Enter selected directory or open file |

## Installation

Simply run:

``` sh
curl -s https://raw.githubusercontent.com/johanmcquillan/warp/master/install.sh | bash
```

and then resource your `.bashrc` or `.zshrc`.

### Requirements

#### Hard requirements

- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat)
- [exa](https://github.com/ogham/exa)

#### Soft requirements

- [ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter) (for displaying previews of images)

#### Notes

Only tested on Linux, macOS with Bash and Zsh.
