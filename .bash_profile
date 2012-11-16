[[ $EMACS = t ]] && unsetopt zle
/bin/zsh
export PATH=$HOME/dotfiles/shells:$PATH
##canythings
alias tmux="tmux -f $HOME/.tmux.`uname`.conf new `which zsh`"

alias sbash="source $HOME/.bash_profile"
alias e="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias ee="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
alias bkrs="ssh amachi@bkrs2"
alias pe="ps -ax | grep Emacs"

alias ll="ls -l"
alias la="ls -a"