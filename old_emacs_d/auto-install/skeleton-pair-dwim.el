;;; skeleton-pair-dwim.el --- Auto pairs insert do what I mean.

;; Copyright (C) 2011  Yuuki Arisawa
;; Author: Yuuki Arisawa <yuuki.ari@gmail.com>
;; Keywords: convenience
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; It can be useful to insert parentheses, braces, quotes and the like in matching pairs – e.g., pressing “(” inserts ‘()’, with the cursor in between

;; (auto-install-from-url "https://github.com/uk-ar/skeleton-pair-dwim/raw/master/skeleton-pair-dwim.el")

;;; Bug:
;; cannot move over `'


;;(setq skeleton-pair-alist '((?| _ ?|) ) )

;;; Code:

;; requires
(require 'skeleton)

(progn
  ;;setting for skeleton.el
  (setq skeleton-pair-on-word nil)
  (setq skeleton-pair t)

  ;; not to deactivate mark
  (defadvice skeleton-insert
    (around skeleton-insert-dwim-advice)
    (if (and transient-mark-mode (not mark-active))
	ad-do-it
      (progn
	(save-excursion ad-do-it)
	(setq deactivate-mark nil)
	(if (< (mark) (point))
	    (forward-char 1);;for undo
	  (set-mark (1+(mark)))))))
  )

(progn
  ;;condition
  (defun skeleton-pair-dwim-closep (char)
    (let ((skeleton
	   (or (rassoc `(_ ,char) skeleton-pair-alist)
	       (rassoc `(_ ,char) skeleton-pair-default-alist))))
      (if (and skeleton (eq (car skeleton) (nth 2 skeleton)))
	  nil
	skeleton)))
  (defun skeleton-pair-dwim-openp (char)
    (and
     (not
      ;; support for (?( _ ?)) (?\)) type alist(skeleton-pair-default-alist)
      (skeleton-pair-dwim-closep char))
     (let ((skeleton
	    (or (assq char skeleton-pair-alist)
		(assq char skeleton-pair-default-alist))))
       (if (and skeleton (eq (car skeleton) (nth 2 skeleton)))
	   nil
	 skeleton))))
  )

;;(defvar skeleton-pair-dwim-earmuff-only nil)
;;(setq skeleton-pair-dwim-earmuff-only t)
;;(setq skeleton-pair-dwim-earmuff-only nil)
;;interactive function
;;ok "" "aaa" over "aa aaa"
;;(global-set-key (kbd "+") 'skeleton-pair-insert-dwim-earmuff)
;;(global-set-key (kbd "+") 'self-insert-command)
;;bug simple-hatena-mode)))
(progn
  ;;command
  (defun skeleton-pair-insert-dwim-earmuff (arg)
    (interactive "*p")
    (skeleton-pair-insert-dwim arg t))
  )


;;define-key
;;insert pair t, self insert nil
;;default self insert

;;   "*括弧を挿入するときの関数一覧。
;; 各要素は以下:
;; \(CONDITION . FUNCTION)
;; CONDITION を評価した結果、最初に真となる要素の FUNCTION が実行される。
;; 真となる要素が存在しない場合 `self-insert-command' が実行される。")
;;
;; (global-set-key (kbd "(") '(lambda (arg)
;; 			       (interactive "p")
;; 			       (message "%s" arg)))
;;(global-set-key (kbd "(") 'hoge)
;;(global-set-key (kbd ")") 'hoge)
(progn
  ;; filter functions for skeleton-pair-filter-function
  (defun skeleton-pair-dwim-inside-stringp ()
    (nth 3 (parse-partial-sexp (point-min) (point))))

  (defun skeleton-pair-dwim-after-wordp ()
    (if (not (skeleton-pair-dwim-openp last-command-event))
	(= (char-syntax (preceding-char)) ?w)))

  ;;looking-back for )"
  (defun skeleton-pair-dwim-after-same-as-charp ()
    (if (not (skeleton-pair-dwim-openp last-command-event))
	(= last-command-event (preceding-char))))
  )
(defvar acp-insertion-functions)

(require 'cl)
(labels ((dmessage (string &rest arg)
		   (apply 'message string arg)))
  (defun skeleton-pair-insert-dwim (arg)
    (interactive "*p")
    (let* ((char last-command-event)
	   (closep (skeleton-pair-dwim-closep char))
	   (openp (skeleton-pair-dwim-openp char))
	   (markp ;;(and skeleton-autowrap
	    (or (eq last-command 'mouse-drag-region)
		(and transient-mark-mode mark-active)))
	   (skeleton-end-hook);;no to add new line
	   ;;(can-earmuff (and earmuff-only mark))
	   (skeleton (or closep openp `(,char _ ,char)))
	   ;;(skeleton-end-hook)
	   )
      (catch 'break
	(mapc (lambda (x)
		(when (eval (car x))
		  ;;(funcall (cdr x) n)
		  ;;(funcall (cdr x) arg)
		  (eval (cdr x))
		  ;;(command-execute (cdr x))
		  (throw 'break t)))
	      (append acp-insertion-functions
		      '((t . self-insert-command)))))
      )))

(progn
  ;; key binding utility
  (defun skeleton-pair-dwim-default-pair-to-keys()
    (mapcar 'char-to-string
	    (append (mapcar 'car
			    skeleton-pair-alist)
		    (mapcar 'car
			    skeleton-pair-default-alist))))

  (defun skeleton-pair-dwim-parse-key (keys)
    (if (not (listp keys))
	(setq keys (list keys)))
    ;;(setq keys
    (append keys
	    (delq nil
		  (mapcar
		   (lambda (key)
		     (let ((openp (skeleton-pair-dwim-openp
				   (string-to-char key))))
		       (if openp
			   (char-to-string(nth 2 openp))))
		     )keys)))
    )

  (defun skeleton-pair-dwim-local-set-key(keys &optional command)
    (if (not (listp keys))
	(setq keys (list keys)))
    (mapc
     (lambda (key)
       (local-set-key key
		      (or command 'skeleton-pair-insert-dwim)))
     (skeleton-pair-dwim-parse-key keys)))


  (defun skeleton-pair-dwim-define-key(maps keys &optional command)
    (if (not (listp keys))
	(setq keys (list keys)))
    (if (keymapp maps)
	(setq maps (list maps)))
    (mapc
     (lambda (map)
       (mapc
	(lambda (key)
	  (or (vectorp key) (stringp key)
	      (signal 'wrong-type-argument (list 'arrayp key)))
	  (define-key (if(keymapp map) map (eval map))
	    key 'skeleton-pair-insert-dwim);;kbd?
	  )(skeleton-pair-dwim-parse-key keys))
       )maps))
  )
(defun skeleton-pair-dwim-global-set-key(keys &optional command)
  (if (not (listp keys))
      (setq keys (list keys)))
  (mapc
   (lambda (key)
     (global-set-key key
		     (or command 'skeleton-pair-insert-dwim)))
   (skeleton-pair-dwim-parse-key keys)))

;;(global-set-key (kbd "\'") nil)
;; (string-to-char "'")
;; (global-set-key (char-to-string 39) nil)
;; (global-set-key (char-to-string 40) ')
;; (string-to-char "(")
;; (string-to-char ")")

;;(skeleton-pair-dwim-parse-key '("'" "\""))
;;(skeleton-pair-dwim-global-set-key "'")
;;user-setting
;;
;;global-map '("{" "(" "\"" "'"))
 ;;global-map '("{" "}" "(" ")" ))
 ;;'(global-map emacs-lisp-mode-map) ")")
 ;;emacs-lisp-mode-map "\"")
;; emacs-lisp-mode-map '("{" "(" "\"" "'"))

;;(define-key global-map "(" 'skeleton-pair-insert-dwim)

;; region
(defvar skeleton-pair-dwim-default-keys '("{" "(" "\"" "'" "["))
(defun skeleton-pair-dwim-load-default ()
  (setq acp-insertion-functions
	;;(defvar acp-insertion-functions
	'(;; (mark-active . (lambda(arg)
	  ;; (self-insert-command arg)
	  ;; (message "mark")))
	  (markp
	   . (progn (skeleton-insert
		     (cons nil skeleton) (if markp -1))
		    (cond ((and openp (< (mark) (point)))
			   (exchange-point-and-mark))
			  ((and closep (< (point) (mark)))
			   (exchange-point-and-mark)))
		    (message "n1")))
	  ((or
	    ;;after escape
	    (memq (char-syntax (preceding-char)) '(?\\ ?/))
	    ;;quote before word or bounds-of-thing-at-point
	    ;;(and (not closep) (looking-at "\\w"))
	    (and (not closep)
		 (memq (char-syntax (following-char)) '(?w))
		 (memq (char-syntax last-command-event) '(?'))
		 )
	    ;;inside comment
	    ;;"aaa"'
	    ;;(goto-char (previous-property-change (point)))
	    ;;(goto-char (next-single-property-change (point) 'face))
	    (and (memq (get-text-property (point) 'face)
		       '(font-lock-comment-face font-lock-doc-face
						font-lock-string-face))
		 ;;(not (memq (char-syntax (following-char)) '(?\" ?\')))
		 (not (eq (previous-single-property-change (1+ (point)) 'face)
			  (point)))
		 )
	    ;;after word for hoge(
	    ;;and ((not openp)
	    (= (char-syntax (preceding-char)) ?w)
	    ;;)
	    )
	   . (progn (self-insert-command arg)
		    (message "n6fil")))
	  ((and (not closep)
		(or
		 ;;(eq (car (bounds-of-thing-at-point 'symbol)) (point))
		 (and (thing-at-point 'symbol) (beginning-of-thing 'symbol))
		 (memq (char-syntax (following-char)) '(?\( ?\"))
		 ))
	   ;;aaa
	   ;;bug for "(" " "
	   . (progn
	       (self-insert-command 1)
	       (undo-boundary)
	       (set-mark
		(save-excursion
		  (let* ((message-log-max nil))
		    ;; Don't log messages in message buffer
		    ;;copy from blink-matching-open
		    (condition-case ()
			(forward-sexp 1)
		      ;;(scan-sexps oldpos -1)
		      (error nil))
		    (insert (nth 2 skeleton))
		    (point))))
	       (setq deactivate-mark nil)
	       ;;(backward-char)
	       ;;(forward-char)
	       ))
	  ((and (not openp)
		(eq (following-char) char)
		(eq this-command real-last-command));;41) & 34"
	   . (progn (forward-char 1);;move over close
		    (message "n4")))
	  ((not closep);;34" & 40(
	   . (progn (skeleton-insert
		     (cons nil skeleton) (if markp -1))
		    ;;(skeleton-pair-insert-maybe nil)
		    (message "n2");; open and region
		    ))
	  (t . (progn (self-insert-command arg)
		      (message "n5")))
	  )
	)

  (ad-activate-regexp 'skeleton-insert-dwim-advice)

  (setq skeleton-pair-filter-function
	'(lambda()
	   (or (skeleton-pair-dwim-inside-stringp)
	       (skeleton-pair-dwim-after-wordp)
	       (skeleton-pair-dwim-after-same-as-charp)
	       )))

  (skeleton-pair-dwim-global-set-key
   (skeleton-pair-dwim-default-pair-to-keys)
   'skeleton-pair-insert-dwim-earmuff)

  (setq skeleton-pair-alist '((?' _ ?') ) )
  ;; (skeleton-pair-dwim-global-set-key
  ;;  (skeleton-pair-dwim-default-pair-to-keys)
  ;;  'self-insert-command)

  (skeleton-pair-dwim-global-set-key skeleton-pair-dwim-default-keys)
  ;;(skeleton-pair-dwim-global-set-key '("{" "(" "\"" "'" "`" "[") 'self-insert-command)
  ;;(skeleton-pair-dwim-local-set-key '("{" "(" "\"" "'" "`" "["))
  ;;(skeleton-pair-dwim-global-set-key '("{" "(" "\"" "'" "`") 'self-insert-command)
  ;;(skeleton-pair-dwim-global-set-key '("{" "(" "\"" "'" "`") nil)
  )

(provide 'skeleton-pair-dwim)
;;; skeleton-pair-dwim.el ends here
