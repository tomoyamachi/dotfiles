;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;load-path設定;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;~/.emacs.d/以下のディレクトリをすべてload-pathに追加;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d")
(require 'cl)
(loop for f in (directory-files "~/.emacs.d" t)
      when (and (file-directory-p f)
                (not (member (file-name-nondirectory f) '("." ".."))))
      do (add-to-list 'load-path f))

;; プラットフォームを判定して分岐する
(cond
 ((string-match "apple-darwin" system-configuration)
  (load "~/.emacs.d/etc/cocoa.el")
  )
 ((string-match "linux" system-configuration)
  (load "~/.emacs.d/etc/linux.el")
  )
 ((string-match "freebsd" system-configuration)
  (load "~/.emacs.d/etc/freebsd.el")
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;基本設定;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key global-map (kbd "C-h") 'delete-backward-char) ; 削除
(define-key global-map (kbd "M-?") 'help-for-help) ; ヘルプ
(define-key global-map (kbd "C-z") 'undo) ; undo
(define-key global-map (kbd "C-c i") 'indent-region) ; インデント
(define-key global-map (kbd "C-c C-i") 'hippie-expand) ; 補完
(define-key global-map (kbd "C-c ;") 'comment-dwim) ; コメントアウト
(define-key global-map (kbd "C-x C-o") 'toggle-input-method) ; 日本語入力切替
(define-key global-map (kbd "C-o") 'other-window) ; 日本語入力切替
(define-key global-map (kbd "M-C-g") 'grep) ; grep
(global-set-key "\M-n" 'find-file-other-frame);;M-nで別窓でファイルを開く
(global-set-key "\C-m" 'newline-and-indent);; 改行時にインデント

(setq text-mode-hook 'turn-off-auto-fill)
(transient-mark-mode 1);リージョンを見易く
(delete-selection-mode 1);regionをBS,DELキーで一括削除
(setq inhibit-startup-message t);; 起動時のメッセージを非表示
(setq backup-inhibited t);;; バックアップファイルを作らない
(setq delete-auto-save-files t);; バックアップファイルを作らない
(setq auto-save-dafault nil);;; オートセーブファイルを作らない
(add-hook 'before-save-hook 'delete-trailing-whitespace);;; 行末の空白を保存前に削除。
(icomplete-mode 1);;; 補完可能なものを随時表示
(column-number-mode t);;; カーソルの位置を表示する
(line-number-mode t);;; カーソルの位置を表示する
(setq-default indent-tabs-mode nil);; Tabの代わりにスペースでインデント
(setq-default tab-width 4);; Tabの幅をスペース2つ分に
(show-paren-mode 1);; 対応する括弧を光らせる。
(set-face-attribute 'default nil :height 100);;フォントのheight設定
(global-set-key "\C-x\C-b" 'bs-show);; バッファ一覧の情報をさらに表示
(defalias 'yes_or_no_p 'y_or_n_p);;; yes_or_no=>y_or_n
(setq history-length 1000);;ミニバッファ履歴リスト
(setq gc-cons-threshold (* 10 gc-cons-threshold));;ガベッジコレクションの頻度を下げる
(setq x-select-enable-clipboard t);X11とクリップボードを共有
;; 同名のファイルの場合ディレクトリ名を付ける
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;;bookmarkを変更したら、即保存
(setq bookmark-save-flag 1)

;;; package-installにmelpaなど主要なレポジトリを追加
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/pac\
kages/") t)
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/pac\
kages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;;;http://www.emacswiki.org/emacs/RevertBuffer
(global-auto-revert-mode 1);;;自動でrevert-buffer
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))
(global-set-key "\C-x\C-r" 'revert-buffer-no-confirm);; バッファ一覧の情報をさらに表示

;;;   shell 設定 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'multi-term)
;; (setq multi-term-program shell-file-name)
;; (setq multi-term-program "/bin/zsh")
;; (add-to-list 'term-unbind-key-list '"C-o")
;; (custom-set-variables
;;    '(term-default-bg-color "#000000")        ;; background color (black)
;;    '(term-default-fg-color "#dddd00"))       ;; foreground color (yellow)
;; (global-set-key (kbd "C-t") '(lambda ()
;;                                 (interactive)
;;                                 (multi-term)))
;; (global-set-key (kbd "C-}") 'multi-term-next)
;; (global-set-key (kbd "C-{") 'multi-term-prev)
;; (require 'shell-pop)
;; ;; multi-term に対応
;; (add-to-list 'shell-pop-internal-mode-list '("multi-term" "*terminal<1>*" '(lambda () (multi-term))))
;; (shell-pop-set-internal-mode "multi-term")
;; ;; 25% の高さに分割する
;; (shell-pop-set-window-height 25)
;; (shell-pop-set-internal-mode-shell shell-file-name)
;; ;; ショートカットも好みで変更してください
;; (global-set-key (kbd "C-c t") 'shell-pop)

;;;;;;;;;;;;;;;;;;;anything ;;;;;;;;;;;;;;;;;;;;;
(require 'anything-startup)
(define-key anything-map "\C-p" 'anything-previous-line)
(define-key anything-map "\C-n" 'anything-next-line)
(define-key anything-map (kbd "C-M-n") 'anything-next-source)
(define-key anything-map (kbd "C-M-p") 'anything-previous-source)
(define-key anything-map "\C-v" 'anything-next-page)
(define-key anything-map "\M-v" 'anything-previous-page)
(define-key anything-map "\C-z" 'anything-execute-persistent-action)
(global-set-key (kbd "C-l") 'anything)

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)


;; subversion
;; (require 'vc-svn)
;; (autoload 'svn-status "dsvn" "Run `svn status'." t)
;; (autoload 'svn-update "dsvn" "Run `svn update'." t)


;;http://cx4a.blogspot.com/2011/12/popwineldirexel.html
;; direx:direx-modeのバッファをウィンドウ左辺に幅25でポップアップ
;; :dedicatedにtを指定することで、direxウィンドウ内でのバッファの切り替えが
;; ポップアップ前のウィンドウに移譲される
(require 'direx)

;; ひとまずpopwinをoffに。
(push '(direx:direx-mode :position left :width 25 :dedicated t)
     popwin:special-display-config)
(global-set-key (kbd "C-;") 'direx:jump-to-directory-other-window)

;;; 関数名をバッファの部分に表示する
(which-func-mode 1)
(setq which-func-modes t)
(delete (assoc 'which-func-mode mode-line-format) mode-line-format)
(setq-default header-line-format '(which-func-mode("" which-func-format)))


;;;diffをわかりやすく表示
;; diffの表示方法を変更
(defun diff-mode-setup-faces ()
  ;; 追加された行は緑で表示
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "dark green")
  ;; 削除された行は赤で表示
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "dark red")
  ;; 文字単位での変更箇所は色を反転して強調
  (set-face-attribute 'diff-refine-change nil
                      :foreground nil :background nil
                      :weight 'bold :inverse-video t))
(add-hook 'diff-mode-hook 'diff-mode-setup-faces)

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

;; diff関連の設定
(defun magit-setup-diff ()
  ;; diffを表示しているときに文字単位での変更箇所も強調表示する
  ;; 'allではなくtにすると現在選択中のhunkのみ強調表示する
  (setq magit-diff-refine-hunk 'all)
  ;; diff用のfaceを設定する
  (diff-mode-setup-faces)
  ;; diffの表示設定が上書きされてしまうのでハイライトを無効にする
  (set-face-attribute 'magit-item-highlight nil :inherit nil))
(add-hook 'magit-mode-hook 'magit-setup-diff)



;dabbrev
;; http://d.hatena.ne.jp/itouhiro/20091122 http://d.hatena.ne.jp/peccu/20100221/dabbrev
(defadvice dabbrev-expand (around jword (arg) activate)
   (interactive "*P")
   (let* ((regexp dabbrev-abbrev-char-regexp)
          (dabbrev-abbrev-char-regexp regexp)
          char ch)
     (if (bobp)
         ()
       (setq char (char-before)
             ch (char-to-string char))
       (cond
        ;; ァ～ヶの文字にマッチしてる時はァ～ヶが単語構成文字とする
        ((string-match "[ァ-ヶー]" ch)
         (setq dabbrev-abbrev-char-regexp "[ァ-ヶー]"))
        ((string-match "[ぁ-んー]" ch)
         (setq dabbrev-abbrev-char-regexp "[ぁ-んー]"))
        ((string-match "[亜-瑤]" ch)
         (setq dabbrev-abbrev-char-regexp "[亜-瑤]"))
        ;; 英数字にマッチしたら英数字とハイフン(-)を単語構成文字とする
        ((string-match "[A-Za-z0-9]" ch)
         (setq dabbrev-abbrev-char-regexp "[A-Za-z0-9-]")) ; modified by peccu
        ((eq (char-charset char) 'japanese-jisx0208)
         (setq dabbrev-abbrev-char-regexp
               (concat "["
                       (char-to-string (make-char 'japanese-jisx0208 48 33))
                       "-"
                       (char-to-string (make-char 'japanese-jisx0208 126 126))
                       "]")))))
     ad-do-it))
(global-set-key "\C-i" 'dabbrev-expand)


;tramp有効にする。ssh/sudoでのファイル編集を有効に
;; (add-to-list 'load-path "/usr/share/emacs/22.1/lisp/net/")
(require 'tramp)
(setq tramp-default-method "ssh")
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '("localhost" nil nil))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))

;;tramp with ssh
(eval-after-load "tramp"
  '(progn
     (defvar sudo-tramp-prefix
       "/sudo::"
       (concat "Prefix to be used by sudo commands when building tramp path "))

     (defun sudo-file-name (filename) (concat sudo-tramp-prefix filename))

     (defun sudo-find-file (filename &optional wildcards)
       "Calls find-file with filename with sudo-tramp-prefix prepended"
       (interactive "fFind file with sudo ")
       (let ((sudo-name (sudo-file-name filename)))
         (apply 'find-file
                (cons sudo-name (if (boundp 'wildcards) '(wildcards))))))

     (defun sudo-reopen-file ()
       "Reopen file as root by prefixing its name with sudo-tramp-prefix and by clearing buffer-read-only"
       (interactive)
       (let*
           ((file-name (expand-file-name buffer-file-name))
            (sudo-name (sudo-file-name file-name)))
         (progn
           (setq buffer-file-name sudo-name)
           (rename-buffer sudo-name)
           (setq buffer-read-only nil)
           (message (concat "Set file name to " sudo-name)))))

     (global-set-key "\C-x+" 'sudo-find-file)
     (global-set-key "\C-c\C-s" 'sudo-reopen-file)))

;;; Shift + 矢印 でバッファ移動
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;;; セッションを保存する
;;; 初めは手動でM-x desktop-saveしなければいけない
(autoload 'desktop-save "desktop" nil t)
(autoload 'desktop-clear "desktop" nil t)
(autoload 'desktop-load-default "desktop" nil t)
(autoload 'desktop-remove "desktop" nil t)
(desktop-load-default)
;; C-x bでミニバッファにバッファ候補を表示
(iswitchb-mode t)
;(iswitchb-default-keybindings)
;; terminalでファイルを開くときにemacsで開けるようにする
;; .bashrcに「alias e='emacsclient -n'」と書く
(if window-system (server-start))


;;表示されているバッファを入れ替える。
(defun swap-screen()
  "Swap two screen,leaving cursor at current window."
  (interactive)
  (let ((thiswin (selected-window))
        (nextbuf (window-buffer (next-window))))
    (set-window-buffer (next-window) (window-buffer))
    (set-window-buffer thiswin nextbuf)))
(defun swap-screen-with-cursor()
  "Swap two screen,with cursor in same buffer."
  (interactive)
  (let ((thiswin (selected-window))
        (thisbuf (window-buffer)))
    (other-window 1)
    (set-window-buffer thiswin (window-buffer))
    (set-window-buffer (selected-window) thisbuf)))
(global-set-key [f2] 'swap-screen)
(global-set-key [S-f2] 'swap-screen-with-cursor)

;; カーソル行をハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "DarkRed"))
    (((class color)
      (background light))
     (:background "DarkRed"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

;; 行をコピーするコマンド
(defun copy-line (&optional arg)
  (interactive "p")
  (copy-region-as-kill
   (line-beginning-position)
   (line-beginning-position (1+ (or arg 1))))
  (message "Line copied"))
;; リージョンを選択していないときに行をキルするコマンド
(defadvice kill-region (around kill-line-or-kill-region activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (kill-whole-line)
    ad-do-it))
;; リージョンを選択していないときに行をコピーするコマンド
(defadvice kill-ring-save (around kill-line-save-or-kill-ring-save activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (copy-line)
    ad-do-it))

;; 括弧を自動で挿入
;; ref: http://www.emacswiki.org/cgi-bin/wiki/SkeletonMode
(require 'skeleton)
(setq skeleton-pair t)
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "<") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(add-to-list 'skeleton-pair-alist '(?` _ ?`))
(global-set-key (kbd "`") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(add-to-list 'skeleton-pair-alist '(?「 _ ?」))
(global-set-key (kbd "「") 'skeleton-pair-insert-maybe)

;;view-modeをよりつかいやすく
;; view-minor-modeの設定
(add-hook 'view-mode-hook
          '(lambda()
             (progn
               ;; C-b, ←
               (define-key view-mode-map "h" 'backward-char)
               ;; C-n, ↓
               (define-key view-mode-map "j" 'next-line)
               ;; C-p, ↑
               (define-key view-mode-map "k" 'previous-line)
               ;; C-f, →
               (define-key view-mode-map "l" 'forward-char)
               )))
;;http://www.bookshelf.jp/soft/meadow_24.html
;; - yes/no の確認なしで、ファイルの再読込み
(defun reopen-file ()
  (interactive)
  (let ((file-name (buffer-file-name))
        (old-supersession-threat
         (symbol-function 'ask-user-about-supersession-threat))
        (point (point)))
    (when file-name
      (fset 'ask-user-about-supersession-threat (lambda (fn)))
      (unwind-protect
          (progn
            (erase-buffer)
            (insert-file file-name)
            (set-visited-file-modtime)
            (goto-char point))
        (fset 'ask-user-about-supersession-threat
              old-supersession-threat)))))
;;C-rでバッファを再読込み
(define-key ctl-x-map "\C-R" 'reopen-file)
;;;shiftキーではなく、「;→アルファベット」で大文字に変換。
;;;http://homepage1.nifty.com/blankspace/emacs/sticky.html
(defvar sticky-key ";")
(defvar sticky-list
  '(("a" . "A")("b" . "B")("c" . "C")("d" . "D")("e" . "E")("f" . "F")("g" . "G")
    ("h" . "H")("i" . "I")("j" . "J")("k" . "K")("l" . "L")("m" . "M")("n" . "N")
    ("o" . "O")("p" . "P")("q" . "Q")("r" . "R")("s" . "S")("t" . "T")("u" . "U")
    ("v" . "V")("w" . "W")("x" . "X")("y" . "Y")("z" . "Z")
    ("1" . "!")("2" . "\"")("3" . "#")("4" . "$")("5" . "%")("6" . "&")("7" . "\'")
    ("8" . "(")("9" . ")")("0" . "=")
    ("`" . "~")("[" . "{")("]" . "}")("-" . "_")("=" . "+")("," . "<")("." . ">")
    ("/" . "?")("@" . "=")("\\" . "|")
    ))
(defvar sticky-map (make-sparse-keymap))
(define-key global-map sticky-key sticky-map)
(mapcar (lambda (pair)
          (define-key sticky-map (car pair)
            `(lambda()(interactive)
               (setq unread-command-events
                     (cons ,(string-to-char (cdr pair)) unread-command-events)))))
        sticky-list)
(define-key sticky-map sticky-key '(lambda ()(interactive)(insert sticky-key)))

;; 起動時のウィンドウについて設定
(if window-system (progn
                    (setq initial-frame-alist '((width . 450)(height . 85)(top . 10)(left . 10)))
                    (set-background-color "Black")
                    (set-foreground-color "White")
                    (set-cursor-color "tomato1")
                    ))

;;; line-number
(require 'linum)
(global-linum-mode t)
(setq linum-format "%5d")



;;; color-moccur.elの設定
(require 'color-moccur)

;;; anything-c-moccurの設定
(require 'anything-c-moccur)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)

;;; キーバインドの割当(好みに合わせて設定してください)
(global-set-key (kbd "M-s") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(define-key isearch-mode-map (kbd "C-o") 'anything-c-moccur-from-isearch)
(global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur) ;ディレクトリ

;;;マウススクロールをスムーズに
;; (defun smooth-scroll (number-lines increment)
;; (if (= 0 number-lines)
;; t
;; (progn
;; (sit-for 0.02)
;; (scroll-up increment)
;; (smooth-scroll (- number-lines 1) increment))))
;; (global-set-key [(mouse-5)] '(lambda () (interactive) (smooth-scroll 6 1)))
;; (global-set-key [(mouse-4)] '(lambda () (interactive) (smooth-scroll 6 -1)))

;; ;;ddskk
;; (add-to-list 'load-path "~/.emacs.d/elisp/skk")
;; (require 'skk-autoloads)
;; (global-set-key "\C-o" 'skk-mode)
;; ;(global-set-key "\C-x\C-j" 'skk-auto-fill-mode)
;; (global-set-key "\C-xt" 'skk-tutorial)
;; (setq skk-show-inline t)
;; (setq skk-large-jisho "~/.emacs.d/skk-jisyo/SKK-JISYO.ML")
;; (setq skk-egg-like-newline t)
;; (setq skk-auto-insert-paren t)
;; (setq skk-dcomp-activate t)
;; (setq skk-date-ad t)
;; (setq skk-number-style 0)
;; (require 'skk-study)

;; (add-hook 'skk-mode-hook
;; '(lambda () (setq skk-kutouten-type 'jp-en)))

;; (defun skk-insert-hyphen (arg)
;;   (interactive "P")
;;   (insert
;;    (let (s
;; (c (char-before (point))))
;;      (if c (setq s (char-to-string (char-before (point)))))
;;      (cond ((null s) "ー")
;; ((string-match "[0-9]" s) "-")
;; ((string-match "[０-９]" s) "−")
;; (t "ー")))))

;; ; from kitamoto tsuyoshi さん
;; (defun skk-period (arg)
;;   (let ((c (char-before (point))))
;;     (cond ((null c) (cadr (assoc skk-kutouten-type skk-kuten-touten-alist)))
;; ((and (<= ?0 c) (>= ?9 c)) ".")
;; ((and (<= ?０ c) (>= ?９ c)) "．")
;; (t (cadr (assoc skk-kutouten-type skk-kuten-touten-alist))))))

;; (defun skk-comma (arg)
;;   (let ((c (char-before (point))))
;;     (cond ((null c) (cddr (assoc skk-kutouten-type skk-kuten-touten-alist)))
;; ((and (<= ?0 c) (>= ?9 c)) ",")
;; ((and (<= ?０ c) (>= ?９ c)) "，")
;; (t (cddr (assoc skk-kutouten-type skk-kuten-touten-alist))))))

;; (setq skk-rom-kana-rule-list
;;       (nconc skk-rom-kana-rule-list
;;              '(
;;                ("!" nil "!")
;;                (":" nil ":")
;;                (";" nil ";")
;;                ("?" nil "?")
;;                ("-" nil skk-insert-hyphen)
;;                ("." nil skk-period)
;;                ("," nil skk-comma)
;;                )))

;; ;; ;;辞書 skk サーバ用の設定
;; ;; (setq skk-server-host "127.0.0.1")
;; ;; (setq skk-server-portnum 1178)
;; ;; (setq skk-server-report-response t);;変換時サーバーの文字を受けとるまでの accept-process-output 実行回数を表示
;; ;;isearchでskkを
;; (add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
;; (add-hook 'isearch-mode-hook 'skk-isearch-mode-cleanup)
;; (setq skk-henkan-strict-okuri-precedence t);;送り仮名が厳密に正しい候補を優先して表示
;; (setq skk-dcomp-activate t);;日本語をダイナミックに補完する
;; (setq skk-use-look t);;英単語補完
;; (setq skk-check-okurigana-on-touroku 'auto);;余分な送り仮名も辞書に自動登録、嫌なら 'nil 質問方式なら 'ask

;; ;; かなモードの入力でモード変更を行わずに、数字入力中の
;; ;; 小数点 (.) およびカンマ (,) 入力を実現する。
;; ;; (例) かなモードのまま 1.23 や 1,234,567 などの記述を行える。
;; ;; period
;; (setq skk-rom-kana-rule-list
;; (cons '("." nil skk-period)
;; skk-rom-kana-rule-list))
;; (defun skk-period (arg)
;;   (let ((c (char-before (point))))
;;     (cond ((null c) "。")
;;           ((and (<= ?0 c) (>= ?9 c)) ".")
;;           ((and (<= ?０ c) (>= ?９ c)) "．")
;;           (t "。"))))

;; ;; comma
;; (setq skk-rom-kana-rule-list
;; (cons '("," Nil skk-comma)
;; skk-rom-kana-rule-list))
;; (defun skk-comma (arg)
;;   (let ((c (char-before (point))))
;;     (cond ((null c) "、")
;;           ((and (<= ?0 c) (>= ?9 c)) ",")
;;           ((and (<= ?０ c) (>= ?９ c)) "，")
;;           (t "、"))))

;; ;;;sticky-shiftをskkでもつかう
;; (setq skk-sticky-key ";")


;; (require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)
;; (setq ediff-window-setup-function 'ediff-setup-windows-plain)

(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t)
(setq undo-limit 60000)
(setq undo-strong-limit 600000)

(require 'recentf-ext)
(setq recentf-max-saved-items 500)
(setq recentf-exclude '("/TAGS$" "/var/tmp/"))
(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1))



(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-file-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)
(setq eldoc-minor-mode-string "")

; open-junk-file
(require 'open-junk-file)
(global-set-key (kbd "C-x C-z") 'open-junk-file)
; 式の評価結果を注釈
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxml)
; カッコの対応を保持して編集
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)
; find-functionをキー割り当て
;(find-function-setup-keys)


;; (require 'w3m-load)
;; (setq w3m-home-page "http://www.google.co.jp/") ;起動時に開くページ
;; (setq w3m-use-cookies t) ;クッキーを使う
;; (setq w3m-bookmark-file "~/.w3m/bookmark.html") ;;ブックマークを保存するファイル


;; (require 'shell-pop)
;; (shell-pop-set-internal-mode "ansi-term")
;; (shell-pop-set-internal-mode-shell "/bin/bash")

;; (defvar ansi-term-after-hook nil)
;; (add-hook 'ansi-term-after-hook
;;           (function
;;            (lambda ()
;;              (define-key term-raw-map "\C-t" 'shell-pop))))
;; (defadvice ansi-term (after ansi-term-after-advice (arg))
;;   "run hook as after advice"
;;   (run-hooks 'ansi-term-after-hook))
;; (ad-activate 'ansi-term)

;; (global-set-key "\C-t" 'shell-pop)

;; (setq ansi-term-color-vector
;;       [unspecified "black" "red1" "lime green" "yellow2"
;;                    "DeepSkyBlue3" "magenta2" "cyan2" "white"])


;;;;;;;;;;; org mode
;;http://lists.gnu.org/archive/html/emacs-orgmode/2010-12/msg01057.html
;; Make windmove work in org-mode:
(setq org-disputed-keys '(([(shift up)] . [(meta p)])
                          ([(shift down)] . [(meta n)])
                          ([(shift left)] . [(meta -)])
                          ([(shift right)] . [(meta +)])
                          ([(control shift right)] . [(meta shift +)])
                          ([(control shift left)] . [(meta shift -)])))
(setq org-replace-disputed-keys t)


;;
;; Evernote mode
;;http://at-aka.blogspot.com/2010/12/emacs-evernote-mode-emacs-evernote.html
;; (setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; optional
;; (require 'evernote-mode)
;; (global-set-key "\C-cec" 'evernote-create-note)
;; (global-set-key "\C-ceo" 'evernote-open-note)
;; (global-set-key "\C-ces" 'evernote-search-notes)
;; (global-set-key "\C-ceS" 'evernote-do-saved-search)
;; (global-set-key "\C-cew" 'evernote-write-note)
;; (global-set-key "\C-cep" 'evernote-post-region)
;; (global-set-key "\C-ceb" 'evernote-browser)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; programming;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-library "hideshow")
(require 'fold-dwim)
(defvar my-hs-state-hide nil)

(defun hs-toggle()
  (interactive)
  (hs-toggle-mode)
  (if my-hs-state-hide
      (progn (hs-show-all) (setq my-hs-state-hide nil))
    (progn  (hs-hide-array)(hs-hide-function)(setq my-hs-state-hide t) )))

(defun hs-toggle-mode()
  (if (not hs-minor-mode)
      (hs-minor-mode)))

(defun hs-hide-function()
  (interactive)
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "function.*?(.*?)" nil t)
	(if (search-forward "{" nil t )
	    (hs-hide-block)))))

(defun hs-hide-array()
  (interactive)
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "array(" nil t)
	    (hs-hide-block))))


;; ruby-mode
;; (autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
;; (setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.watchr$" . ruby-mode) auto-mode-alist))
;; (setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
;; (autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
;; (autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
;; (add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; ;; (require 'rspec-mode)
;; ;; (add-to-list 'auto-mode-alist '("\\spec.rb\\'" . rspec-mode))

;; ;; (require 'ruby-electric)
;; ;; (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; ;; ;(require 'ido)
;; ;; ;(ido-mode t)
;; ;; (require 'rinari)
;; ;; (require 'rhtml-mode)
;; ;; (add-hook 'rhtml-mode-hook
;; ;; (lambda () (rinari-launch)))
(require 'yasnippet) ;; not yasnippet-bundle
(require 'anything-c-yasnippet)
(setq anything-c-yas-space-match-any-greedy t) ;スペース区切りで絞り込めるようにする デフォルトは nil
(global-set-key (kbd "C-c y") 'anything-c-yas-complete) ;C-c yで起動 (同時にお使いのマイナーモードとキーバインドがかぶるかもしれません)

(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
;; (yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets")
;; (require 'ruby-block)
;; (ruby-block-mode t)
;; (setq ruby-block-highlight-toggle t)

;;;;;;;;php-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'php-mode)
(add-hook 'php-mode-hook
          '(lambda ()
             (hs-minor-mode)
             (flymake-mode t)
             (setq tab-width 4)
             (setq c-basic-offset 4)
             (setq indent-tabs-mode nil)
             (setq c-hanging-comment-ender-p nil)
             (setq indent-tabs-mode nil))
          )


;; (add-hook 'c-mode-common-hook
;;     (setq c-basic-offset tab-width))

(setq standard-indent 4)
(setq php-indent-level 4)
;; ;; (setq ruby-indent-level 4)
;; ;; 補完のためのマニュアルのパス
(setq php-completion-file "~/.emacs.d/php.dict")
;; ;; M-TAB が有効にならないので以下の設定を追加
(define-key php-mode-map "\C-\M-i" 'php-complete-function)
(define-key php-mode-map (kbd "C-c C-o") 'hs-toggle-hiding)
(define-key php-mode-map (kbd "C-c C-f") 'hs-toggle)

;; (add-to-list 'auto-mode-alist '("\\.php$" . html-mode))
;; (add-to-list 'load-path "~/.emacs.d/elisp/mmm-mode")
;; (require 'mmm-mode)
;; (setq mmm-global-mode 'maybe)

;; ;(mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
;; (mmm-add-classes
;;  '((html-php
;;     :submodep php-mode
;;     :front "<\\?\\(php\\)?"
;;     :back "\\?>")))
;; ;(add-to-list 'auto-mode-alist '("\\.php?\\'" . html-mode))
;; (setq mmm-submode-decoration-level 1)
;; ;; decoration-level: 1 のときに使用されるface
;; (set-face-background 'mmm-default-submode-face "gray15")

;;;;;;;;sass-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))

;; ;; flymake for ruby と rvmを併用
;; (require 'rvm)
;; (rvm-use-default)
;; ;; flymake for ruby
;; (require 'flymake)
;; ;; Invoke ruby with '-c' to get syntax checking
;; (defun flymake-ruby-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "ruby" (list "-c" local-file))))
;; (push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
;; (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
;; (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
;; (add-hook
;;  'ruby-mode-hook
;;  '(lambda ()
;;     ;; Don't want flymake mode for ruby regions in rhtml files
;;     (if (not (null buffer-file-name)) (flymake-mode))
;;     ;; エラー行で C-c d するとエラーの内容をミニバッファで表示する
;;     (define-key ruby-mode-map "\C-cd" 'credmp/flymake-display-err-minibuf)))

;; (defun credmp/flymake-display-err-minibuf ()
;;   "Displays the error/warning for the current line in the minibuffer"
;; (defun credmp/flymake-display-err-minibuf ()
;;   "Displays the error/warning for the current line in the minibuffer"
;;   (interactive)
;;   (let* ((line-no (flymake-current-line-no))
;;          (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
;;          (count (length line-err-info-list))
;;          )
;;     (while (> count 0)
;;       (when line-err-info-list
;;         (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
;;                (full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
;;                (text (flymake-ler-text (nth (1- count) line-err-info-list)))
;;                (line (flymake-ler-line (nth (1- count) line-err-info-list))))
;;           (message "[%s] %s" line text)
;;           )
;;         )
;;       (setq count (1- count)))))

;; (setq flymake-coffeescript-err-line-patterns
;; '(("\\(Error: In \\([^,]+\\), .+ on line \\([0-9]+\\).*\\)" 2 3 nil 1)))

;; (defconst flymake-allowed-coffeescript-file-name-masks
;; '(("\\.coffee$" flymake-coffeescript-init)))

;; (defun flymake-coffeescript-init ()
;; (let* ((temp-file (flymake-init-create-temp-buffer-copy
;; 'flymake-create-temp-inplace))
;; (local-file (file-relative-name
;; temp-file
;; (file-name-directory buffer-file-name))))
;; (list "coffee" (list local-file))))

;; (defun flymake-coffeescript-load ()
;; (interactive)
;; (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;; (setq flymake-check-was-interrupted t))
;; (ad-activate 'flymake-post-syntax-check)
;; (setq flymake-allowed-file-name-masks
;; (append flymake-allowed-file-name-masks
;; flymake-allowed-coffeescript-file-name-masks))
;; (setq flymake-err-line-patterns flymake-coffeescript-err-line-patterns)
;; (flymake-mode t))

;; (add-hook 'coffee-mode-hook 'flymake-coffeescript-load);;   (interactive)
;;   (let* ((line-no (flymake-current-line-no))
;;          (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
;;          (count (length line-err-info-list))
;;          )
;;     (while (> count 0)
;;       (when line-err-info-list
;;         (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
;;                (full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
;;                (text (flymake-ler-text (nth (1- count) line-err-info-list)))
;;                (line (flymake-ler-line (nth (1- count) line-err-info-list))))
;;           (message "[%s] %s" line text)
;;           )
;;         )
;;       (setq count (1- count)))))

;; (setq flymake-coffeescript-err-line-patterns
;; '(("\\(Error: In \\([^,]+\\), .+ on line \\([0-9]+\\).*\\)" 2 3 nil 1)))

;; (defconst flymake-allowed-coffeescript-file-name-masks
;; '(("\\.coffee$" flymake-coffeescript-init)))

;; (defun flymake-coffeescript-init ()
;; (let* ((temp-file (flymake-init-create-temp-buffer-copy
;; 'flymake-create-temp-inplace))
;; (local-file (file-relative-name
;; temp-file
;; (file-name-directory buffer-file-name))))
;; (list "coffee" (list local-file))))

;; (defun flymake-coffeescript-load ()
;; (interactive)
;; (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;; (setq flymake-check-was-interrupted t))
;; (ad-activate 'flymake-post-syntax-check)
;; (setq flymake-allowed-file-name-masks
;; (append flymake-allowed-file-name-masks
;; flymake-allowed-coffeescript-file-name-masks))
;; (setq flymake-err-line-patterns flymake-coffeescript-err-line-patterns)
;; (flymake-mode t))

;; (add-hook 'coffee-mode-hook 'flymake-coffeescript-load)


;;gtagsをつかう
(autoload 'gtags-mode "gtags" "" t)
(add-hook 'php-mode-hook 'gtags-mode)

;; カタカナをすべて半角に
(defun ktai-hankaku-katakana-region (start end)
  (interactive "r")
  (while (string-match
          "[０-９Ａ-Ｚａ-ｚァ-ンー：；＄]+\\|[！？][！？]+"
          (buffer-substring start end))
    (save-excursion
      (japanese-hankaku-region
       (+ start (match-beginning 0))
       (+ start (match-end 0))
       ))))

(defun ktai-hankaku-katakana-buffer ()
  (interactive)
  (ktai-hankaku-katakana-region (point-min) (point-max)))

(require 'vc)

(defun vc-root-dir ()
  (let ((backend (vc-deduce-backend)))
    (and backend
         (ignore-errors
           (vc-call-backend backend 'root default-directory)))))

(require 'auto-rsync)
(auto-rsync-mode t)

(custom-set-variables
 '(auto-rsync-command-option "-avzq --exclude '*flymake*' --exclude '\\.git/*' --exclude '\\#.*' --exclude 'test/data/csv/*' --exclude 'config/schema/*' --exclude 'config/config\\.d/schema\\.d/*'"))

(setq auto-rsync-dir-alist
      '(
        ("/Users/amachi/programs/linebot" . "pf_dev:/home/amachi/linebot")
        ("/Users/amachi/programs/platform-api" . "pf_dev:/home/amachi/platform-api")
        ("/Users/amachi/programs/product-api" . "pf_dev:/home/amachi/product-api")
        ("/Users/amachi/programs/api-phalcon" . "pf_dev:/home/amachi/api-phalcon")
        ("/Users/amachi/programs/php-common" . "pf_dev:/home/amachi/php-common")
        ("/Users/amachi/programs/php-phalcon" . "pf_dev:/home/amachi/php-phalcon")
        ("/Users/amachi/programs/gcpn_connect" . "pf_prod:/home/ec2-user/gcpn_connect")
        ("/Users/amachi/programs/dp-elplano" . "news_dev:/home/bitnami/apps/wordpress/htdocs/wp-content/themes/dp-elplano")
        ("/Users/amachi/programs/drive_optimizer" . "pf_dev:/home/amachi/drive_optimizer")
        ("/Users/amachi/programs/carrier-settlement" . "docomo_aws:/home/snout/vhost/henteko.jp")
        ;;("/Users/amachi/programs/relocal" . "mer:/home/amachi/relocal")
        ;; ("/path/to/src2/" . "username@hostname:/path/to/dest2/")
        ))

;; (require 'flycheck)
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))
;; (define-key yaml-mode-map "\C-m" 'newline-and-indent)

(defconst *dmacro-key* "\C-t" "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; golang用
(with-eval-after-load 'go-mode
  ;; auto-complete
  (require 'go-autocomplete)

  ;; company-mode
  ;; (add-to-list 'company-backends 'company-go)

  ;; eldoc
  (add-hook 'go-mode-hook 'go-eldoc-setup)

  ;; key bindings
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "M-,") 'pop-tag-mark))
