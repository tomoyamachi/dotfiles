[[ $EMACS = t ]] && unsetopt zle
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

/bin/zsh

##canythings
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/dotfiles/shells:$PATH
#alias tmux="tmux -f $HOME/.tmux.`uname`.conf new `which zsh`"

# alias sbash="source $HOME/.bash_profile"
alias e="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias ee="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
alias bkrs="ssh amachi@bkrs2"
alias pe="ps -ax | grep Emacs"

alias ll="ls -l"
alias la="ls -a"
