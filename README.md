# dotfiles
These are my configuration for `vim`, `zsh`, and `tmux`.

![screenshot](https://i.imgur.com/1I6as6m.png)

## Getting Started
**Disclaimer:** These dotfiles work best on WSL2 and mac. **Use at your own risk!**

### Prerequisites
* `awk` is required.
* `oh-my-zsh` should be installed. Follow the instruction [here](https://github.com/robbyrussell/oh-my-zsh).

### Basic Installation
* The repository will be cloned into `~/dotfiles` by executing the following command via `git`.
* The `backup` process in `scripts.sh` will backup the existing configs into `~/dotfiles_backup`.
```
$ git clone "http://github.com/williamhsieh/dotfiles" ~/dotfiles && sh ~/dotfiles/scripts.sh backup
```

## Feedback
Comments and suggestions are [welcome](https://github.com/WilliamHsieh/dotfiles/issues)!

## About me
* [William Hsieh](https://github.com/williamhsieh/)
* [YouTube](https://www.youtube.com/playlist?list=PL9_ICC0aO5tjEbqj4ivBFsafBx8Rw74fg): Vim tutorial

## Acknowledgements
Inspiration and code were taken from many sources, including:
* [Maxin Cardamom](https://github.com/changemewtf/no_plugins)
* [Damian Conway](http://damian.conway.org/About_us/Bio_formal.html) and his [vim configuration](https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup)
* [Nick Nisi](https://nicknisi.com/) and his [presentation](https://github.com/nicknisi/vim-workshop)
* [Hermann Vocke](https://www.hamvocke.com/) and his [dotfiles repository](https://github.com/hamvocke/dotfiles)
* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles/)
* Anyone who made a helpful [suggestion](https://github.com/WilliamHsieh/dotfiles/issues)

