# dotfiles
These are my configuration for vim, zsh, and tmux.

![screenshot](https://i.imgur.com/1I6as6m.png)

## Getting Started
### Prerequisites
**Disclaimer:** These dotfiles work best on WSL2. **Use at your own risk!**

* I'm using ```zsh```, and ```oh-my-zsh``` is recommended. Installed it by following the [instruction](https://github.com/robbyrussell/oh-my-zsh).
* ```xclip``` is the tool I used to copy content from vim/tmux buffer to clipboard. Install if needed.
* ```git```

### Basic Installation
The repository will be cloned into ```~/dotfiles``` by executing the following command via ```git```.
```
$ git clone "http://github.com/williamhsieh/dotfiles" ~/dotfiles && ~/dotfiles/init.sh
```
* the ```init.sh``` process will backup the existing dotfiles to ```~/dotfiles_backup```
* execute ```chmod +x init.sh``` if permission denied

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
* Anyone who  [made a helpful suggestion](https://github.com/WilliamHsieh/dotfiles/issues)

