# starship
eval "$(starship init zsh)"

# syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# disable underling
# (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHTLIGHT_STYLES
# ZSH_HIGHTLIGHT_STYLES[path]=none
# ZSH_HIGHTLIGHT_STYLES[path_prefix]=none

# activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# -- change to fd -- 
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github..com/sharkdp/fd) for listing path candidates.
#  - The first argument to the function ($1) jis the base path to start traveral
#  - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

# activate [mise](https://mise.jdx.dev) for managing versions of node, python, etc
eval "$(~/.local/bin/mise activate zsh)"

 # make ls better via eza
alias ls="eza --color=always --icons=always -1 --hyperlink -a --git-ignore -l --no-permissions --no-user --group-directories-first --time=accessed --time-style=relative"

# better shell history with [atuin](https://atuin.sh/)
. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

# setup config alias
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no

export PATH=$PATH:$GOPATH/bin

export PATH="$PATH:$GOBIN"

# any machine local configs that cannot be sent to a public
# git repo go into ~/.zshrc.local. test if ~/.zshrc.local exists, if not create it
if [ ! -f ~/.zshrc.local ]; then
   touch ~/.zshrc.local
fi
# now source it
source ~/.zshrc.local
