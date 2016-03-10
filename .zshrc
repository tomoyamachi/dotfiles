######################## 基本設定 .bash_profileとほぼ同じ
eval `ssh-agent -s`
# ssh-add ~/.ssh/id_dsa
## emacs用の環境変数を作成
perl -wle \
    'do {print qq/(setenv "$_" "$ENV{$_}")/if exists $ENV{$_}} for @ARGV' \
    PATH > ~/.emacs.d/shellenv.el

case "${OSTYPE}" in
# MacOSX
    darwin*)
        alias e="/Applications/Emacs.app/Contents/MacOS/Emacs"
        alias ee="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
        alias se="sudo /Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
        alias tc="tmux-pbcopy" # tmuxのコピーボードにあるものをMacと共有
        alias tp="pbpaste" # Macのクリップボードにあるものをtmuxにはりつけ
        alias tmux="tmuxx"
        ;;
    #linux
    linux*)
        alias e="emacs"
        alias ee="emacsclient -n"
        alias se="sudo emacsclient -n"
        ;;
esac

alias hg='history 100 | grep '
alias ql="qlmanage -p 2>/dev/null"
alias reload="source $HOME/.zshrc"
alias mute='/usr/bin/osascript -e "set volume 0"'
alias cdcopy='pwd|pbcopy'
alias imgdim='sips -g pixelHeight -g pixelWidth $1'
alias gip="curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias clock='while :; do printf "%s\r" "$(date +%T)"; sleep 1 ; done'
alias server='sudo service nginx'

function girn() {
   grep -irn "$1" `pwd` --exclude-dir=$2
}

# alias server='sudo service apache
export ncnf="/etc/nginx/conf.d"

# eval "$(rbenv init - zsh)"

# bkrs2サーバ設定
if [ "$HOSTNAME" = 'bkrs2' ]; then
  # screenでログインした場合、ssh-agent未起動なら起動する
  if [ $TERM = 'screen' ]; then
    if [ -e ~/.ssh/environment ]; then
      # 設定ファイルがすでにある場合は、それを設定する
      . ~/.ssh/environment
    else
      # ssh-agent環境設定ファイルが存在しない場合
      # 設定ファイルを作成して読み込む
      ssh-agent > ~/.ssh/environment
     . ~/.ssh/environment
    fi
  fi
fi

# systgサーバ設定
if [ "$HOSTNAME" = 'systg' ]; then
    . ~/.sshagent
fi

[[ $EMACS = t ]] && unsetopt zle
export PATH=$HOME/dotfiles/bkrs_shells:$HOME/dotfiles/shells:$PATH:$HOME/bkcd_shells

alias h='cd ~'
alias pa='ps auxwwww'
alias pspgid='ps axwww -o "ppid pgid pid user fname args"'
alias iops='ps auxwwww -L|awk "\$10 ~ /(D|STAT)/{print}"'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias ddu='du -sm ./*|sort -n|tail'
# カレントフォルダ以下のファイル名を一覧表示
iname() { find . -type d -name .svn -prune -o \( -iname "*$1*" -print \); }
alias fnuniq='cut -d: -f1|uniq'

# 拡張子に応じて適切なアプリケーションでファイルを開く
# http://d.hatena.ne.jp/itchyny/20130227/1361933011
alias -s sh=sh
alias -s rb=ruby
alias -s php=php
function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -dc $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

if [ `uname` = "Darwin" ]; then
  alias eog='open -a Preview'
  alias firefox='open -a Firefox '
fi
alias -s {png,jpg,bmp,PNG,JPG,BMP}=eog
alias -s html=firefox

# runapp() {
# $app=`find /Applications/ -name “*.app” | grep $1`;
# shift;
# open -a “$app/” “$2″;
# }

# brew install ctags
alias ctags='/usr/local/Cellar/ctags/5.8/bin/ctags'
#cd コマンドでそれぞれの場所へ移動
alias server="sudo /etc/init.d/httpd"
alias cache="sudo /etc/init.d/memcached"
alias cron="sudo /etc/init.d/crond"

# エラーログやシステムログをtailで見る(デフォルト30行)
alias debug="tail -f -n 100 ${SY_LOG}zend/zend.log"
alias aerror="tail -f -n 100 ${SY_LOG}apache/error.log"
alias aaccess="tail -f -n 100 ${SY_LOG}apache/access.log"
alias "sd"="svn diff -x -w"

# $1以下のフォルダから $2が含まれる文字列を表示
alias fgrep='. $HOME/dotfiles/shells/find_string_in_folder'
alias sp='. $HOME/dotfiles/shells/change_project'
alias c='. $HOME/dotfiles/shells/change_directory_in_project'
alias pe="ps -ax | grep Emacs"
alias ke="ps -ax | grep 'Emac[s]' | awk '{print $1}' | xargs kill -9"

#export SVN_SSH="ssh -l amachi -i /Users/amachitomoya/.ssh/id_rsa"
#. ~/docs/synphonie/shells/kinnosuke
export SHUTDOWN_CONFIRM_FLAG=0
# $1以下のフォルダから $2が含まれる文字列を表示
alias fgrep='. find_string_in_folder'
alias sp='. change_project'
alias c='. change_directory_in_project'

_Z_CMD=j
. ~/dotfiles/z/z.sh
precmd() {
  _z --add "$(pwd -P)"
}

# tmux
alias -g CA='| canything'
# tmuxでの移動
alias tmux="tmux -f $HOME/.tmux.`uname`.conf new `which zsh`"
#function chpwd(){
#  [ -n $TMUX ] && tmux setenv TMUXPWD_$(tmux display -p "#I") $PWD /bin/zsh
#}

#rbenv
# path=($HOME/.rbenv/bin(N) $path)
# eval "$(rbenv init -)"
# rbenv global 1.9.2-p290

# #tmuxでsshが破棄されてもWindowをとじない
# function ssh_tmux() {
#   eval server=\${$#}
#   tmux set set-remain-on-exit on\; \
#       new-window -n s:$server "ssh $*"\; \
#       set set-remain-on-exit off > /dev/null
# }

# ホスト毎に色を変えたい場合
# if [ "$TMUX" != "" ]; then
#     tmux set-option status-bg colour$(($(echo -n $(whoami)@$(hostname) | sum | cut -f1 -d' ') % 8 + 8)) | cat > /dev/null
# fi
DOTFILE=~/dotfiles
alias fgrep='. $DOTFILE/shells/find_string_in_folder'

alias where="command -v"
case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"

################################################ Environment variable configuration
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac


################################################ フォルダ移動 ################################################################################
setopt auto_cd # auto change directory
setopt auto_pushd # auto directory pushd that you can get dirs list by cd -[tab]
setopt pushd_ignore_dups # ディレクトリスタックに同じディレクトリを追加しないようになる
# setopt correct # コマンドのスペルチェックをする
# setopt correct_all # コマンドライン全てのスペルチェックをする
setopt no_clobber # 上書きリダイレクトの禁止
#setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt chase_links # シンボリックリンクは実体を追うようになる

## カレントディレクトリ中に指定されたディレクトリが見つからなかった場合に
## 移動先を検索するリスト。
cdpath=(~)
## ディレクトリが変わったらディレクトリスタックを表示。
#chpwd_functions=($chpwd_functions dirs)


setopt correct # command correct edition before each completion attempt
setopt pushd_to_home # pushd を引数なしで実行した場合 pushd $HOME と見なされる

## 補完フォルダを選択
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

### 補完機能
setopt auto_list # 補完候補が複数ある時に、一覧表示する
setopt list_packed # 補完候補リストを詰めて表示
setopt list_types # auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt auto_param_slash # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt brace_ccl # {a-c} を a b c に展開する機能を使えるようにする
setopt auto_menu # 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin # sudoも補完の対象
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**' # 大文字小文字の区別をしない

## Alias configuration
# expand aliases before completing
setopt complete_aliases     # aliased ls needs if file/dir completions work

setopt noautoremoveslash # no remove postfix slash of command line
setopt nolistbeep # no beep sound when complete list displayed
setopt auto_param_keys # カッコの対応などを自動的に補完する


########### キーバインド設定 ################
bindkey -e # emacsライクなキーバインド設定

function cdup() {
    cd ..
    zle reset-prompt
}
zle -N cdup # ^ で上の階層へ

bindkey "^F" forward-word # C-f, C-bキーで単語移動
bindkey "^B" backward-word # C-f, C-bキーで単語移動
bindkey "^?" backward-delete-char # Backspace key

# historical backward/forward search with linehead string binded to ^P/^N
# C-p,C-nでヒストリ表示
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
setopt ignore_eof # Ctrl+D では終了しないようになる（exit, logout などを使う）

# glob(*)によるインクリメンタルサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
bindkey "\e[Z" reverse-menu-complete # reverse menu completion binded to Shift-Tab


bindkey "^[[1~" beginning-of-line # ホームボタンで行頭へ
bindkey "^[[4~" end-of-line # ENDボタンで行末へ
bindkey "^[[3~" delete-char # Del

# back-wordでの単語境界の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# setopt extended_glob # # 正規表現にマッチしないものを決める /  ex.)  ls *~patterns
#setopt NO_hup # シェルが終了しても裏ジョブに HUP シグナルを送らないようにする
#setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす



################ コマンド履歴設定 ################
HISTFILE=$HOME/.zsh_history
alias history='fc -il 1'

HISTIGNORE=ls:history
HISTIGNORE=pwd:history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt hist_ignore_all_dups # 登録済コマンド行は古い方を削除
setopt hist_reduce_blanks # 余分な空白は詰める
setopt inc_append_history # add history when command executed.
setopt hist_ignore_space # コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_no_store # history (fc -l) コマンドをヒストリリストから取り除く。
setopt extended_glob # ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
#setopt auto_resume # サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
#setopt equals # =command を command のパス名に展開する
setopt extended_history  # zsh の開始・終了時刻をヒストリファイルに書き込む
#setopt NO_flow_control  # Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt hist_verify # ヒストリを呼び出してから実行する間に一旦編集できる状態になる
autoload zed ## zsh editor
## Prediction configuration
#autoload predict-on
#predict-off

################## terminal の表示設定等 ################

## Default shell configuration
# set prompt
autoload colors
colors
case ${UID} in
0)
    PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
*)
    PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
    PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac

case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

case "${TERM}" in
xterm|xterm-color)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
xterm|xterm-color|kterm|kterm-color)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# エラーメッセージ本文出力に色付け
e_normal=`echo -e "¥033[0;30m"`
e_RED=`echo -e "¥033[1;31m"`
e_BLUE=`echo -e "¥033[1;36m"`

function make() {
    LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}
function cwaf() {
    LANG=C command ./waf "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}


## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine


# ## terminal configuration
# # http://journal.mycom.co.jp/column/zsh/009/index.html
# unset LSCOLORS

# case "${TERM}" in
# xterm)
#     export TERM=xterm-color

#     ;;
# kterm)
#     export TERM=kterm-color
#     # set BackSpace control character

#     stty erase
#     ;;

# cons25)
#     unset LANG
#   export LSCOLORS=ExFxCxdxBxegedabagacad

#     export LS_COLORS='di=01;32:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
#     zstyle ':completion:*' list-colors \
#         'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#     ;;

# kterm*|xterm*)
#    # Terminal.app
# # precmd() {
# # echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
# # }
#     # export LSCOLORS=exfxcxdxbxegedabagacad
#     # export LSCOLORS=gxfxcxdxbxegedabagacad
#     # export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

#     export CLICOLOR=1
#     export LSCOLORS=ExFxCxDxBxegedabagacad

#     zstyle ':completion:*' list-colors \
#         'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#     ;;

# dumb)
#     echo "Welcome Emacs Shell"
#     ;;
# esac


# expand-to-home-or-insert () {
#         if [ "$LBUFFER" = "" -o "$LBUFFER[-1]" = " " ]; then
# LBUFFER+="~/"
#         else
# zle self-insert
#         fi
# }

# # C-M-h でチートシートを表示する
# cheat-sheet () { zle -M "`cat ~/dotfiles/.zsh/cheat-sheet`" }
# zle -N cheat-sheet
# # bindkey "^[^h" cheat-sheet

# # zsh の exntended_glob と HEAD^^^ を共存させる。
# # http://subtech.g.hatena.ne.jp/cho45/20080617/1213629154

# magic-abbrev-expand () {
#   local MATCH
#   LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9^]#}
#   LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
# }

# magic-abbrev-expand-and-insert () {
#   magic-abbrev-expand
#   zle self-insert
# }

# magic-abbrev-expand-and-accept () {
#   magic-abbrev-expand
#   zle accept-line
# }

# no-magic-abbrev-expand () {
#   LBUFFER+=' '
# }

# zle -N magic-abbrev-expand
# zle -N magic-abbrev-expand-and-insert
# zle -N magic-abbrev-expand-and-accept
# zle -N no-magic-abbrev-expand
# bindkey "\r" magic-abbrev-expand-and-accept # M-x RET はできなくなる
# bindkey "^J" accept-line # no magic
# bindkey " " magic-abbrev-expand-and-insert
# bindkey "." magic-abbrev-expand-and-insert
# bindkey "^x " no-magic-abbrev-expand

# # Incremental completion on zsh
# # http://mimosa-pudica.net/src/incr-0.2.zsh
# # やっぱりauto_menu使いたいのでoff
# # source ~/.zsh/incr*.zsh

# # auto-fuの設定。^PとかのHistory検索と相性が悪いのでひとまず無効に。
# # http://d.hatena.ne.jp/tarao/20100531/1275322620
# # incremental completion
# # if is-at-least 4.3.10; then
#     # function () { # precompile
#         # local A
#         # A=~/.zsh/auto-fu.zsh/auto-fu.zsh
#         # [[ -e "${A:r}.zwc" ]] && [[ "$A" -ot "${A:r}.zwc" ]] ||
#         # zsh -c "source $A; auto-fu-zcompile $A ${A:h}" >/dev/null 2>&1
#     # }
#     # source ~/.zsh/auto-fu.zsh/auto-fu; auto-fu-install
#     # function zle-line-init () { auto-fu-init }
#     # zle -N zle-line-init
#     # zstyle ':auto-fu:highlight' input bold
#     # zstyle ':auto-fu:highlight' completion fg=white
#     # zstyle ':auto-fu:var' postdisplay ''
#     # function afu+cancel () {
#         # afu-clearing-maybe
#         # ((afu_in_p == 1)) && { afu_in_p=0; BUFFER="$buffer_cur"; }
#     # }
#     # function bindkey-advice-before () {
#         # local key="$1"
#         # local advice="$2"
#         # local widget="$3"
#         # [[ -z "$widget" ]] && {
#             # local -a bind
#             # bind=(`bindkey -M main "$key"`)
#             # widget=$bind[2]
#         # }
#         # local fun="$advice"
#         # if [[ "$widget" != "undefined-key" ]]; then
#             # local code=${"$(<=(cat <<"EOT"
#                 # function $advice-$widget () {
#                     # zle $advice
#                     # zle $widget
#                 # }
#                 # fun="$advice-$widget"
# # EOT
#             # ))"}
#             # eval "${${${code//\$widget/$widget}//\$key/$key}//\$advice/$advice}"
#         # fi
#         # zle -N "$fun"
#         # bindkey -M afu "$key" "$fun"
#     # }
#     # bindkey-advice-before "^G" afu+cancel
#     # bindkey-advice-before "^[" afu+cancel
#     # bindkey-advice-before "^J" afu+cancel afu+accept-line

#     # # delete unambiguous prefix when accepting line
#     # function afu+delete-unambiguous-prefix () {
#         # afu-clearing-maybe
#         # local buf; buf="$BUFFER"
#         # local bufc; bufc="$buffer_cur"
#         # [[ -z "$cursor_new" ]] && cursor_new=-1
#         # [[ "$buf[$cursor_new]" == ' ' ]] && return
#         # [[ "$buf[$cursor_new]" == '/' ]] && return
#         # ((afu_in_p == 1)) && [[ "$buf" != "$bufc" ]] && {
#             # # there are more than one completion candidates
#             # zle afu+complete-word
#             # [[ "$buf" == "$BUFFER" ]] && {
#                 # # the completion suffix was an unambiguous prefix
#                 # afu_in_p=0; buf="$bufc"
#             # }
#             # BUFFER="$buf"
#             # buffer_cur="$bufc"
#         # }
#     # }
#     # zle -N afu+delete-unambiguous-prefix
#     # function afu-ad-delete-unambiguous-prefix () {
#         # local afufun="$1"
#         # local code; code=$functions[$afufun]
#         # eval "function $afufun () { zle afu+delete-unambiguous-prefix; $code }"
#     # }
#     # afu-ad-delete-unambiguous-prefix afu+accept-line
#     # afu-ad-delete-unambiguous-prefix afu+accept-line-and-down-history
#     # afu-ad-delete-unambiguous-prefix afu+accept-and-hold
# # fi


# function rmf(){
#    for file in $*
#    do
# __rm_single_file $file
#    done
# }

# function __rm_single_file(){
#        if ! [ -d ~/.Trash/ ]
#        then
# command /bin/mkdir ~/.Trash
#        fi

# if ! [ $# -eq 1 ]
#        then
# echo "__rm_single_file: 1 argument required but $# passed."
#                exit
# fi

# if [ -e $1 ]
#        then
# BASENAME=`basename $1`
#                NAME=$BASENAME
#                COUNT=0
#                while [ -e ~/.Trash/$NAME ]
#                do
# COUNT=$(($COUNT+1))
#                        NAME="$BASENAME.$COUNT"
#                done

# command /bin/mv $1 ~/.Trash/$NAME
#        else
# echo "No such file or directory: $file"
#        fi
# }

# ## alias設定
# #
# # [ -f ~/dotfiles/.zshrc.alias ] && source ~/dotfiles/.zshrc.alias

# # case "${OSTYPE}" in
# # # Mac(Unix)
# # darwin*)
# #     # ここに設定
# #     [ -f ~/dotfiles/.zshrc.osx ] && source ~/dotfiles/.zshrc.osx
# #     ;;
# # # Linux
# # linux*)
# #     # ここに設定
# #     [ -f ~/dotfiles/.zshrc.linux ] && source ~/dotfiles/.zshrc.linux
# #     ;;
# # esac
