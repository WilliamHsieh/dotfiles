# dotfiles
These are my configuration for `neovim`, `zsh`, and `tmux` using [nix](https://nixos.org/manual/nix/stable/) and [home-manager](https://github.com/nix-community/home-manager).

<img width="1440" alt="Screenshot 2023-01-16 at 13 39 33" src="https://user-images.githubusercontent.com/23206205/212606291-498b2c3b-c891-4567-8305-0ad438aad286.png">
<img width="1440" alt="Screenshot 2023-01-16 at 13 39 41" src="https://user-images.githubusercontent.com/23206205/212606308-24b3b4a8-9ce8-409b-85cb-6b3a1c4a4ce0.png">

## Getting Started
1. install [nix](https://nixos.org/download.html)
```bash
sh <(curl -L https://nixos.org/nix/install)
```
2. clone this repo and modify the personal info in `config.nix`
```bash
git clone http://github.com/williamhsieh/dotfiles ~/dotfiles && cd ~/dotfiles
```
3. apply home-manager settings (leaving `USER` empty will call `.#william` by default)
```bash
NIX_CONFIG="experimental-features = flakes nix-command" nix run . switch -- -b bak --flake .#USER
```
4. download [nerd fonts](https://www.nerdfonts.com/) for the terminal emulator

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
* [Michael Peter](https://mijope.de/) and his [nvim configuration](https://github.com/Allaman/nvim)
* [Christian Chiarulli](https://www.chrisatmachine.com/) and his [nvim configuration](https://github.com/ChristianChiarulli/nvim)
* Anyone who made a helpful [suggestion](https://github.com/WilliamHsieh/dotfiles/issues)
