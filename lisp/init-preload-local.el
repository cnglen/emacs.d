(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("org"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ))

(package-initialize) ;; You might already have this line

;; (add-to-list 'package-archives
;; 	     '("popkit" . "https://elpa.popkit.org/packages/"))

;; (setq package-archives
;;       '(
;;         ("popkit" . "https://elpa.popkit.org/packages/")
;;         ))

;; (setq package-archives
;;       '(("gnu-cn" . "http://elpa.codefalling.com/gnu/")
;;         ("org-cn" . "http://elpa.codefalling.com/org/")
;;         ("melpa-cn" . "http://elpa.codefalling.com/melpa/")))
(package-initialize)

(provide 'init-preload-local)
