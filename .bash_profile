[[ $EMACS = t ]] && unsetopt zle
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

for shellenv in `cat /etc/shells`; do
   if [ "$shellenv" = "/bin/zsh" ];then
       chsh -s /bin/zsh `whoami`;
   fi
done
