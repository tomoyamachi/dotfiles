;;;;;;;;;;;;;;;;;;;;;
;;   synphonie.el
;;
;;   Synphonieでのみの設定項目
;;
;;   仕事でのみ使用する設定もここに記述
;;
;;;;;;;;;;;;;;;;;;;;;;


; proxy for synphonie
;; (add-to-list 'tramp-default-proxies-alist
;;     '( ""  "amachi"  "/ssh:amachi@bkrs2:" ) )
(add-to-list 'tramp-default-proxies-alist
             '("bkrs2" nil "/ssh:amachi@bkrs2:"))


(defvar sy-ssh-directory nil "SY設定で現在起動しているSSH接続先を保存" )
(defvar sy-default-call nil "初期設定でcallするもの" )

(defun sy-command()
  (interactive)
  (if sy-ssh-directory
      (sy-call)
    (sy-default-call)))

(global-set-key (kbd "C-c C-t") 'sy-command)
(define-key  dired-mode-map (kbd "C-c C-t") 'sy-command)

; indent切り替え
(defun toggle-indent()
  (interactive)
  (let ( ( tabs-mode indent-tabs-mode ) )
    (if tabs-mode
		(progn (setq indent-tabs-mode nil)
			   (progn (save-excursion
						(goto-char (point-min)) (replace-string "	"  "    " )))
			   (message "インデントはスペースになりました。" )
			   (setq my-indent-settings nil ))
      ( progn (setq indent-tabs-mode t )
			  (progn (save-excursion
					   (goto-char (point-min)) (replace-string "    "  "	" )
					   (message "インデントはタブになりました。")
					   (setq my-indent-settings t )))))))


(defun sy-bkrs2()
  (interactive)
  (let ( (site-name "bkrs2" ) (my-name "amachi" ) )
    (message "Synphonie環境構築開始..." )
    ;; それぞれ、必要なページを開いておく
    (setq sy-ssh-directory (concat "/ssh:" my-name "@" site-name ":" ))
    (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name "/framework/php") )
    (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name ))
    (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name "/share/www/" site-name "/application/modules/main") )
    (dired-noselect "controllers")
;  (save-excursion (dired "models") (dired-maybe-insert-subdir "App") (dired-maybe-insert-subdir "App/Master") (dired-maybe-insert-subdir "App/User") (dired-maybe-insert-subdir "App/Data") (dired-maybe-insert-subdir "App/Image" ))
; もとのバッファに戻る
  (save-excursion (dired "views") (dired-maybe-insert-subdir "scripts" ) (dired-noselect "snippets"))
  (switch-to-buffer (get-buffer "controllers"))
  (message "php , avatar , main , models , views を開いています" )
  )
)
(fset 'sy-default-call 'sy-plgl)

(defun sy-call()
  "Call Controllers , Models , Views in SynphonieFrameWork : Author : Ippei Sato"
  (interactive)
  (let ((filename (read-string "ファイル名を入力: ")) (views-subdir nil)
	(model-dir "/home/amachi/bkrs2/lib/php/Synphonie/Bkrs2/" )
	(controller-dir "/home/amachi/bkrs2/share/bkrs2/application/modules/main/controllers/" )
	(view-dir "/home/amachi/bkrs2/share/bkrs2/application/modules/main/views/scripts/" )
	(target-dir)
	(aftar-search)
	(message-text)
	)
    ;; 略語展開
    (setq filename (replace-regexp-in-string "^m/" "App_Master_" filename ))
    (setq filename (replace-regexp-in-string "^d/" "App_Data_" filename ))
    (setq filename (replace-regexp-in-string "^a/" "App_" filename ))
    (setq filename (replace-regexp-in-string "C$" "Controller" filename t))
    (message "ファイル展開： '%s'" filename)
    (cond
     ;; Controllerの検索
     ((string-match "Controller$" filename)
      (setq filename (concat (upcase-initials (replace-regexp-in-string "Controller" "" filename)) "Controller.php"))
      (setq target-dir controller-dir ))
     ;; App の検索
     ((string-match "^App" filename)
      (setq filename (upcase-initials filename))
      (setq aftar-search (car (cdr (split-string filename "/" ))))
      (if (not (null aftar-search))
	  (setq aftar-search (concat "function " aftar-search "(" )))
      (setq filename (car (split-string filename "/" )))
      (setq target-dir model-dir )
      (setq filename (concat (replace-regexp-in-string "_" "/" filename) ".php")))
     ;; controllerの検索 ( 省略検索 )
     ((string-match "^/" filename)
      (setq aftar-search (car (nthcdr 2 (split-string filename "/" ))))
      (if (not (null aftar-search))
	  (setq aftar-search (concat  aftar-search "Action")))
      (setq filename (car (cdr (split-string filename "/" ))))
      (setq target-dir controller-dir )
      (setq filename (concat (replace-regexp-in-string "_" "/" (upcase-initials filename)) "Controller.php")))
     ;; Viewsの検索
     (t
      (setq target-dir view-dir)
      (setq filename (concat filename ".phtml" ))))
    (find-file (concat sy-ssh-directory target-dir filename ))
    (message "検索: %s" aftar-search )
    (if aftar-search
	(progn
	  (beginning-of-buffer)
	  (re-search-forward aftar-search)
	  (beginning-of-line)
    ))
    (setq message-text (concat "開いたファイル名 :" filename))
    (if aftar-search
	(progn (setq message-text (concat message-text " / 検索 :" aftar-search ))))
    (message message-text)
    (if (null aftar-search)
	(isearch-forward))
    ))



;;;--------------------
;;;  以下まだ使っていない
;;;--------------------
(defun sy-all()
  (interactive)
  (let ( (site-name (read-string "サイト名を入力: " ) ) (my-name (read-string "ユーザ名を入力: " ) ) )
    ;; それぞれ、必要なページを開いておく
    (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name "/framework/php") )
    ;; (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name "/bin/" site-name "/gen/avatar") )
    (dired (concat "/ssh:" my-name "@"  site-name  ":/home/" my-name "/" site-name "/share/www/" site-name "/application/modules/main") )
    (dired-noselect "controllers")
  (save-excursion (dired "models") (dired-maybe-insert-subdir "App") (dired-maybe-insert-subdir "App/Master") (dired-maybe-insert-subdir "App/User") (dired-maybe-insert-subdir "App/Data") (dired-maybe-insert-subdir "App/Image" ))
  (save-excursion (dired "views") (dired-maybe-insert-subdir "scripts" ) (dired-noselect "snippets"))
  (switch-to-buffer (get-buffer "controllers"))
  )
)

(defun create-on-ever()
  (interactive)
  (let ( (my-name (read-string "user name?: " ) ) (site-name (read-string "host name?: " ) ) (dir-name (read-string "directory name?: " ) ) )
    (dired (concat "/ssh:" my-name "@" site-name  ":~/" dir-name "/") )
    )
)

(defun create-on-syn()
  (interactive)
  (let ( (site-name (read-string "サイト名を入力: " ) ) (my-name (read-string "ユーザ名を入力: " ) ) )
    (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name "/framework/php") )
    (dired (concat "/ssh:" my-name "@" site-name  ":/home/" my-name "/" site-name "/share/" site-name "/application/modules/main") )
    (dired-noselect "controllers")
  (save-excursion (dired "models") (dired-maybe-insert-subdir "App") (dired-maybe-insert-subdir "App/Master") (dired-maybe-insert-subdir "App/User") )
  (save-excursion (dired "views") (dired-maybe-insert-subdir "scripts" ) (dired-noselect "snippets"))
  (switch-to-buffer (get-buffer "controllers"))
  )
)

;; search function
(defun search-php-function()
  (interactive)
  (let (
     (line-number (string-to-int (car (cdr (split-string (what-line))))))
     (next-number nil)
     )
    (save-excursion
      (next-line)
      (if (re-search-forward "\s*public function" nil t )
       (setq next-number (string-to-int (car (cdr (split-string (what-line))))))
     (setq next-number 0))
      )
    (if (> next-number 0 )
     (progn (goto-line next-number)
            (beginning-of-line)
            (message "hit" ))
      (beginning-of-buffer)))
  )


(defun nothing()
  (interactive)
  t)
(define-key global-map "\C-z" 'nothing)

