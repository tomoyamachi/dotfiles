;;;;;;;;;;;;;;;;;;;Linux setting ;;;;;;;;;;;;;;;;;;;;
;;; xdebug用のポートを9001に変更
(autoload 'geben "geben" "DBGp protocol front-end" t)

(custom-set-variables
 '(geben-dbgp-default-port 9001))

(custom-set-variables
 '(geben-dbgp-default-proxy '("127.0.0.1" 9002 "default" nil t)))

;; (custom-set-variables
;; '(dbgp-default-port 9001))
