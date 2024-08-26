
# Ashmortar's dotfiles repo

strategy is taken from [this hacker news thread](https://news.ycombinator.com/item?id=11070797)
but basically on the initial machine:

```sh
git init --bare $HOME/.myconf
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

then files are added as one normally would with git, but instead using `config`

```sh
config status
config add ~/.config/nvim
config commit -m "Add nvim config"
config push
```

on a new machine to do setup

```sh
git clone --separate-git-dir=$HOME/.myconf https://github.com/ashmortar/dotfiles $HOME/myconf-tmp
cp ~/myconf-tmp ~
rm -r ~/myconf-tmp/
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```
