[[ $EMACS = t ]] && unsetopt zle
export GOPATH="$HOME/go"
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"



for shellenv in `cat /etc/shells`; do
   if [ "$shellenv" = "/bin/zsh" ];then
       chsh -s /bin/zsh `whoami`;
   fi
done
