# Initial commands
mac での利用を想定。
事前に homebrew のインストールを行う。
インストール手順は[公式](https://brew.sh/index_ja.html)を参考。
インストール後に以下のコマンドを実行する。

```
$ xcode-select --install
$ homebrew install コマンド
$ brew install zsh rbenv evm cmigemo
$ evm list # check installable emacs versions
$ evm insatll emacs-<version>
$ evm use emacs-<version>
$ which Emacs # => /Users/<user>/.evm/bin/Emacs
```

# zsh 設定
よく利用する ssh-key を ssh-add しておく。

```.zshrc.mine
# デフォルトで利用する秘密鍵ファイル
export KEY_FILENAME='id_dsa'
# パスフレーズを登録すれば自動で ssh-add する
export PASSPHRASE='<enter passphrase>'
```

# emacs について
[spacemacs](http://spacemacs.org/)を利用。
コマンド補助 : helm
日本語入力 : ddskk
I-Search :migemo

## よく利用するコマンド

| C-l   | helm-mini (find-files)   |
| C-x   | helm-M-x (find-commands) |
| S-C-y | helm-show-kill-ring      |
| C-i   | yas-expand               |
| C-x j | skk-mode                 |

## skk について
sticky-key を `;` に設定。
http://www.bookshelf.jp/texi/skk/skk_4.html

| q   | かな<->カナ      |
| l   | かな/カナ->ascii |
| C-j | ascii->かな/カナ |
