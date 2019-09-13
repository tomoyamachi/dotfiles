[[ $EMACS = t ]] && unsetopt zle
export GOPATH="$HOME/go"
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ユーザのシェルにzshを追加
for shellenv in `cat /etc/shells`; do
   if [ "$shellenv" = "/bin/zsh" ];then
       chsh -s /bin/zsh `whoami`;
   fi
done

export PATH="$HOME/.cargo/bin:$PATH"
