;;;;;;;;;;;;;;;;;;;Mac setting ;;;;;;;;;;;;;;;;;;;;
(setq default-input-method "MacOSX")
(setq ns-command-modifier (quote meta))
(define-key global-map [ns-drag-file] 'ns-find-file)
(setq ns-pop-up-frames nil)
(tool-bar-mode 0);;; ツールバーを出さない

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
;;; (setq-default buffer-file-coding-system 'utf-8-unix)

;; フォントセットを作る
(let* ((fontset-name "myfonts") ; フォントセットの名前
       (size 10) ; ASCIIフォントのサイズ [9/10/12/14/15/17/19/20/...]
       (asciifont "Menlo") ; ASCIIフォント
       (jpfont "Hiragino Kaku Gothic ProN") ; 日本語フォント
       (font (format "%s-%d:weight=normal:slant=normal" asciifont size))
       (fontspec (font-spec :family asciifont))
       (jp-fontspec (font-spec :family jpfont))
       (fsn (create-fontset-from-ascii-font font nil fontset-name)))
  (set-fontset-font fsn 'japanese-jisx0213.2004-1 jp-fontspec)
  (set-fontset-font fsn 'japanese-jisx0213-2 jp-fontspec)
  (set-fontset-font fsn 'katakana-jisx0201 jp-fontspec) ; 半角カナ
  (set-fontset-font fsn '(#x0080 . #x024F) fontspec) ; 分音符付きラテン
  (set-fontset-font fsn '(#x0370 . #x03FF) fontspec) ; ギリシャ文字
  )

;; デフォルトのフレームパラメータでフォントセットを指定
(add-to-list 'default-frame-alist '(font . "fontset-myfonts"))

;; フォントサイズの比を設定
(dolist (elt '(("^-apple-hiragino.*" . 1.2)
		 (".*osaka-bold.*" . 1.2)
		 (".*osaka-medium.*" . 1.2)
		 (".*courier-bold-.*-mac-roman" . 1.0)
		 (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
		 (".*monaco-bold-.*-mac-roman" . 0.9)))
    (add-to-list 'face-font-rescale-alist elt))

;; デフォルトフェイスにフォントセットを設定
;; # これは起動時に default-frame-alist に従ったフレームが
;; # 作成されない現象への対処
(set-face-font 'default "fontset-myfonts")



(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH")":")))
  (add-to-list 'exec-path path))

(require 'gtags)
(require 'anything-gtags)

;; キーバインド
(setq gtags-mode-hook
      '(lambda ()
         (define-key gtags-mode-map "\C-cs" 'gtags-find-symbol)
         (define-key gtags-mode-map "\C-cr" 'gtags-find-rtag)
         (define-key gtags-mode-map "\C-ct" 'gtags-find-tag)
         (define-key gtags-mode-map "\C-cf" 'gtags-parse-file)))
;; gtags-mode を使いたい mode の hook に追加する
(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1)))
