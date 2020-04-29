;;; init-local --- configuration for cnglen
;;; Commentary:
;;; Update Log
;;; 2016-05-18: Merge all local files to one init-local.el
;;; 2016-05-19: Add Hive Part, Add init-cnglen/chinese/R part;

;;; Code:

(message ">> init-local.el started ...")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ELPA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message ">>   ELPA started ...")
;;; Packages repository In CHINA
;; (add-to-list 'package-archives
;;              '("popkit" . "http://elpa.popkit.org/packages/"))
;;; or
;; (setq package-archives
;;       '(("gnu-cn" . "http://elpa.codefalling.com/gnu/")
;;         ("org-cn" . "http://elpa.codefalling.com/org/")
;;         ("melpa-cn" . "http://elpa.codefalling.com/melpa/")))

;;; install packages
(require-package 'yasnippet)
(require-package 'anaconda-mode)
(require-package 'org)
(require-package 'ox-reveal)
(require-package 'origami)
(require-package 'sqlup-mode)
(require-package 'ggtags)
(require-package 'org-plus-contrib)
;; (require-package 'hive)
(message ">>   ELPA done ...")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message ">>   python started ...")
;;; todo
;;; sphinx-doc
;;; sphinx-mode
;;;
(require-package 'sphinx-doc)
(require-package 'py-autopep8)
(require 'py-autopep8)

(setq py-autopep8-options '("--max-line-length=1920" "--ignore=E701"))
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(add-hook 'python-mode-hook (lambda ()
                              (require 'sphinx-doc)
                              (sphinx-doc-mode t)))
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")


;;; anaconda-mode
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(add-hook 'python-mode-hook 'yafolding-mode)
(require-package 'jupyter)
(require 'jupyter)
(require 'jupyter-org-client)
(jupyter-org-define-key (kbd "M-?") #'jupyter-inspect-at-point)

(setq anaconda-mode-localhost-address "localhost")

(message ">>   python done ...")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ORG-MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message ">>   org started ...")
(require-package 'org)
;; org export to pdf
(when (require 'ox-latex nil 'noerror)
  ;; You need to install pygments to use minted
  (when (executable-find "pygmentize")
    ;; Add minted to the defaults packages to include when exporting.
    (add-to-list 'org-latex-packages-alist '("" "minted"))
    ;; Tell the latex export to use the minted package for source code coloration.
    (setq org-latex-listings 'minted)
    ;; Let the exporter use the -shell-escape option to let latex execute external programs.
    ;; This obviously and can be dangerous to activate!
    (setq org-latex-minted-options
          '(("mathescape" "true")
            ("linenos" "true")
            ("numbersep" "5pt")
            ("frame" "lines")
            ("framesep" "2mm")))
    (setq org-latex-pdf-process
          '(
            "~/.emacs.d/bin/replace_ipython.sh %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))))

;; ;; ;; "sed -E -i 's/^(\\begin\\{minted\\}.*)\\{ipython\\}$/\1\\{python\\}/g' %f"



;;; Only _{} -> subscript, in html/pdf and emacs buffer.
(setq org-export-with-sub-superscripts '{}
      org-use-sub-superscripts '{})

;;; Let org-mode recongnize Chinise font
(setq org-emphasis-regexp-components '(" \t('\"{[:multibyte:]" "- \t.,:!?;'\")}\\[:multibyte:]" " \t\r\n,\"'" "." 1))
(after-load 'org
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components))

;;; No spaces bewteen lines when exporting to HTML
(defadvice org-html-paragraph (before org-html-paragraph-advice (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let* (
         (origin-contents (ad-get-arg 1))
         (fix-regexp "[[:multibyte:]]")
         (fixed-contents
          (replace-regexp-in-string
           (concat
            "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)")
           "\\1\\2" origin-contents)))
    (ad-set-arg 1 fixed-contents)))

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

;;; slide
;;; NOTE: using the single html for presentation; If you want to export pdf, change org-reveal-single-file to nil
(require-package 'ox-reveal)
(require 'ox-reveal)
(setq org-reveal-root "file:////opt/reveal.js"
      org-reveal-mathjax t              ; t or nil
      org-reveal-hlevel 1 ; The minimum level of headings that should be grouped into vertical slides.
      org-reveal-single-file nil        ; t 导出单一的巨大HTML; nil ?print-pdf
      org-reveal-width (* (frame-pixel-width) 1.2)    ; auto detect the width of monitor
      org-reveal-height (* (frame-pixel-height) 1.2)    ;auto detect the height of monitor
      org-reveal-margin "-1"
      org-reveal-min-scale "-1"
      org-reveal-max-scale "-1"
      org-reveal-extra-css (concat "file:///" (getenv "HOME") "/.emacs.d/lib/local.css"))



;; (defunsacha/org-html-checkbox (checkbox)
;;   "Format CHECKBOX into HTML."
;;   (case checkbox (on "<span class=\"check\">&#x2611;</span>") ; checkbox (checked)
;;         (off "<span class=\"checkbox\">&#x2610;</span>")
;;         (trans "<code>[-]</code>")
;;         (t "")))
;; (defadviceorg-html-checkbox (around sacha activate)
;;   (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0))))

;;; ipython in org-mode
(setq org-confirm-babel-evaluate nil) ; don't prompt me to confirm everytime I want to evaluate a block
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append) ; display/update images in the buffer after I evaluate
(require-package 'jupyter)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (jupyter . t)))
(setq org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                     (:session . "py")
                                                     (:kernel . "python3")
                                                     (:exports . "both")
                                                     ))
(add-to-list 'org-latex-minted-langs '(ipython "python"))


;;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(yas-reload-all)
(add-hook 'org-mode-hook 'yas-minor-mode)

;;; python doc string of google style
(defun python-args-to-google-docstring (text &optional make-fields)
  "Return a reST docstring format for the python arguments in yas-text."
  (let* ((indent (concat "\n" (make-string (current-column) 32)))
         (args (python-split-args text))
         (nr 0)
         (formatted-args
          (mapconcat
           (lambda (x)
             (concat "    " (nth 0 x)
                     (if make-fields (format " (${%d:arg%d}): ${%d:arg%d}" (+ nr 1) (+ nr 1) (incf nr 2) nr))
                     (if (nth 1 x) (concat " \(default " (nth 1 x) "\)"))))
           args
           indent)))
    (unless (string= formatted-args "")
      (concat
       (mapconcat 'identity
                  (list "" "Args:" formatted-args)
                  indent)
       "\n"))))


;;; clean tmp file when generating pdf
(setq org-latex-logfiles-extensions (quote ("lof" "lot" "tex" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "_minted")))

;;; org export to md
(require 'ox-md)

;;; Plantuml
(require-package 'plantuml-mode)
(require-package 'flycheck-plantuml)
(setq plantuml-jar-path "~/.emacs.d/lib/plantuml/plantuml.jar")
(setq org-plantuml-jar-path "~/.emacs.d/lib/plantuml/plantuml.jar")
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))


;;; taskjuggler
(require 'ox-taskjuggler)
(setq org-taskjuggler-default-reports '("include \"reports.tji\""))
(setq org-taskjuggler-default-reports '("
textreport report \"Plan\" {
  formats html
  header '== %title =='

  center -8<-
    [#Plan 甘特图] | [#Resource_Allocation 资源分配] | [#Contact_List 资源列表]
    ----
    === Plan ===
    <[report id=\"gantt\"]>
    ----
    === Resource Allocation ===
    <[report id=\"resource_graph\"]>
    ----
    === Contact List ===
    <[report id=\"contact_list\"]>
  ->8-
}

# A traditional Gantt chart with a project overview
taskreport gantt \"\" {
  headline \"甘特图\"
  columns name{title '名称'},
    start{title '开始日期'},
    end{title '结束日期'},
    effort{title \"工作量\"},
    resources{title '资源'
              listtype comma
              listitem \"<-query attribute='name'->\"
              },
    chart { scale day
           width 1000
          },
    duration{title \"持续时长\"
  }
  loadunit shortauto
  hideresource 1
}

# A graph showing resource allocation. It identifies whether each resource is under- or over-allocated for.
resourcereport resource_graph \"\" {
  headline \"资源分配图\"
  columns no, name{title '名称'}, effort{title '工作量'}, weekly
  loadunit shortauto
  hidetask ~(isleaf() & isleaf_())
  sorttasks plan.start.up
}
resourcereport contact_list \"\" {
  headline \"资源列表\"
  columns name{title '名称'},
  email{title '电子邮件'},
  chart{scale day width 800}
  hideresource ~isleaf()
  sortresources name.up
  hidetask @all
}

"))


;;; 导出到html的代码背景色，与emacs的背景色一致
(defun my-org-inline-css-hook (exporter)
  "Insert custom inline css."
  (when (eq exporter 'html)
    (let (
          (my-pre-bg (face-background 'default))
          (my-pre-fg (face-foreground 'default))
          )
      (setq org-html-head-include-default-style nil)
      (setq org-html-head
            (format "<style type=\"text/css\">\n pre.src { background-color: %s; color: %s;} span.underline{text-decoration: underline}   div.figure p { text-align: center;}  </style>\n" my-pre-bg my-pre-fg)))))

(add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)

;; (require 'ob-mermaid)
(message ">>   org started done")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Hive
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message ">> hive ...")
(require 'sql)
(require 'sql-indent)
(require 'sqlup-mode)
(setq auto-mode-alist
      (append '(
                ("\\.sql$" . sql-mode)
                ("\\.hql$" . sql-mode)
                )
              auto-mode-alist))
(defvar sql-mode-hive-font-lock-keywords
  (eval-when-compile
    (list
     ;; Hive Functions
     ;; From https://cwiki.apache.org/confluence/display/Hive/LanguageManual+UDF
     (sql-font-lock-keywords-builder 'font-lock-builtin-face nil
                                     "abs" "acos" "asin" "atan" "bin" "bround" "cbrt" "ceil" "conv" "cos"
                                     "degrees" "e" "exp" "factorial" "floor" "greatest" "hex" "least"
                                     "ln" "log2" "log10" "log" "negative" "pi" "pmod" "positive" "pow"
                                     "radians" "rand" "round" "shiftleft" "shiftright" "shiftrightunsigned"
                                     "sign" "sin" "sqrt" "tan" "unhex" "size" "map_keys" "map_values"
                                     "array_contains" "sort_array" "binary" "cast" "from_unixtime"
                                     "unix_timestamp" "to_date" "year" "quarter" "month" "day" "hour"
                                     "minute" "second" "weekofyear" "datediff" "date_add" "date_sub"
                                     "from_utc_timestamp" "to_utc_timestamp" "current_date" "current_timestamp"
                                     "add_months" "last_day" "next_day" "trunc" "months_between" "date_format"
                                     "if" "isnull" "isnotnull" "nvl" "coalesce" "ascii" "base64" "concat"
                                     "context_ngrams" "concat_ws" "decode" "encode" "find_in_set"
                                     "format_number" "get_json_object" "in_file" "instr" "length" "locate"
                                     "lower" "lpad" "ltrim" "ngrams" "parse_url" "printf" "regexp_extract"
                                     "regexp_replace" "repeat" "reverse" "rpad" "rtrim" "sentences" "space"
                                     "split" "str_to_map" "substr" "substring_index" "translate" "trim"
                                     "unbase64" "upper" "initcap" "levenshtein" "soundex" "java_method"
                                     "reflect" "hash" "current_user" "current_database" "md5" "sha1" "sha"
                                     "crc32" "sha2" "aes_encrypt" "aes_decrypt" "xpath" "count" "sum"
                                     "avg" "min" "max" "variance" "var_samp" "stddev_pop" "stddev_samp"
                                     "covar_pop" "covar_samp" "corr" "percentile" "percentile_approx"
                                     "histogram_numeric" "collect_set" "collect_list" "ntile" "explode"
                                     "inline" "explode" "json_tuple" "parse_url_tuple" "posexplode" "stack"
                                     )

     ;; Hive Keywords
     ;; From https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL
     (sql-font-lock-keywords-builder 'font-lock-keyword-face nil
                                     "add" "admin" "after" "all" "alter" "analyze" "and" "archive" "array" "as" "asc" "authorization" "before" "between"
                                     "bigint" "binary" "boolean" "both" "bucket" "buckets" "by" "cascade" "case" "cast" "change" "char" "cluster"
                                     "clustered" "clusterstatus" "collection" "column" "columns" "comment" "compact" "compactions" "compute"
                                     "concatenate" "conf" "continue" "create" "cross" "cube" "current" "current_date" "current_timestamp" "cursor"
                                     "data" "database" "databases" "date" "datetime" "day" "dbproperties" "decimal" "deferred" "defined" "delete"
                                     "delimited" "dependency" "desc" "describe" "directories" "directory" "disable" "distinct" "distribute"
                                     "double" "drop" "elem_type" "else" "enable" "end" "escaped" "exchange" "exclusive" "exists" "explain" "export"
                                     "extended" "external" "false" "fetch" "fields" "file" "fileformat" "first" "float" "following" "for" "format"
                                     "formatted" "from" "full" "function" "functions" "grant" "group" "grouping" "having" "hold_ddltime" "hour"
                                     "idxproperties" "if" "ignore" "import" "in" "index" "indexes" "inner" "inpath" "inputdriver" "inputformat"
                                     "insert" "int" "intersect" "interval" "into" "is" "items" "jar" "join" "keys" "key_type" "lateral" "left" "less"
                                     "like" "limit" "lines" "load" "local" "location" "lock" "locks" "logical" "long" "macro" "map" "mapjoin"
                                     "materialized" "minus" "minute" "month" "more" "msck" "none" "noscan" "not" "no_drop" "null" "of" "offline" "on"
                                     "option" "or" "order" "out" "outer" "outputdriver" "outputformat" "over" "overwrite" "owner" "partialscan"
                                     "partition" "partitioned" "partitions" "percent" "plus" "preceding" "preserve" "pretty" "principals"
                                     "procedure" "protection" "purge" "range" "read" "readonly" "reads" "rebuild" "recordreader" "recordwriter"
                                     "reduce" "regexp" "reload" "rename" "repair" "replace" "restrict" "revoke" "rewrite" "right" "rlike" "role" "roles"
                                     "rollup" "row" "rows" "schema" "schemas" "second" "select" "semi" "serde" "serdeproperties" "server" "set" "sets"
                                     "shared" "show" "show_database" "skewed" "smallint" "sort" "sorted" "ssl" "statistics" "stored" "streamtable"
                                     "string" "struct" "table" "tables" "tablesample" "tblproperties" "temporary" "terminated" "then" "timestamp"
                                     "tinyint" "to" "touch" "transactions" "transform" "trigger" "true" "truncate" "unarchive" "unbounded" "undo"
                                     "union" "uniontype" "uniquejoin" "unlock" "unset" "unsigned" "update" "uri" "use" "user" "using" "utc"
                                     "utctimestamp" "values" "value_type" "varchar" "view" "when" "where" "while" "window" "with" "year"
                                     )

     ;; Hive Data Types
     ;; From https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types
     (sql-font-lock-keywords-builder 'font-lock-type-face nil
                                     "tinyint" "smallint" "int" "bigint"
                                     "float" "double" "decimal"
                                     "timestamp" "date"
                                     "string" "varchar" "char"
                                     "boolean" "binary"
                                     "array" "struct" "map" "uniontype"
                                     "textfile" "sequencefile" "rcfile" "inputformat" ;; add manualy
                                     )))

  "Hive SQL keywords used by font-lock.

This variable is used by `sql-mode' and `sql-interactive-mode'.  The
regular expressions are created during compilation by calling the
function `regexp-opt'.  Therefore, take a look at the source before
you define your own `sql-mode-hive-font-lock-keywords'.")

(eval-after-load "sql"
  '(progn
     (load-library "sql-indent")
     (load-library "sqlup-mode")

     (sql-add-product
      'hive "Hive"
      '(
        :free-software t
        :font-lock 'sql-mode-hive-font-lock-keywords
        :sqli-program 'sql-hive-program
        :sqli-options 'sql-hive-options
        :sqli-login 'sql-hive-login-params
        :sqli-comint-func 'sql-comint-hive
        :prompt-regexp "^hive> "
        :prompt-length 5
        :prompt-cont-regexp "^    > "
        )
      )

     ))

;;; Default using Hive product in sql-mode
(sql-set-product 'hive)

;; Capitalize keywords in SQL mode
(add-hook 'sql-mode-hook 'sqlup-mode)
;; Set a global keyword to use sqlup on a region
(global-set-key (kbd "C-c u") 'sqlup-capitalize-keywords-in-region)
;; (add-hook 'sql-interactive-mode-hook 'sqlup-mode)


(defcustom sql-indent-case-column-regexp
  (concat "\\(^\\s-*" (regexp-opt '(
                                    "case"
                                    ) t) "\\(\\b\\|\\s-\\)\\)\\|\\(^```$\\)")
  "Regexp matching keywords relevant for indentation."
  :type 'regexp
  :group 'SQL)

(defcustom sql-indent-when-else-column-regexp
  (concat "\\(^\\s-*" (regexp-opt '(
                                    "when" "else" "then"
                                    ) t) "\\(\\b\\|\\s-\\)\\)\\|\\(^```$\\)")
  "Regexp matching keywords relevant for indentation."
  :type 'regexp
  :group 'SQL)

(defcustom sql-indent-end-column-regexp
  (concat "\\(^\\s-*" (regexp-opt '(
                                    "end"
                                    ) t) "\\(\\b\\|\\s-\\)\\)\\|\\(^```$\\)")
  "Regexp matching keywords relevant for indentation."
  :type 'regexp
  :group 'SQL)

(setq sql-indent-first-column-regexp
      (concat "\\(^\\s-*" (regexp-opt '(
                                        "select" "update" "insert" "delete"
                                        "union" "intersect"
                                        "from" "where" "into" "group" "having" "order"
                                        "set"
                                        "create" "drop" "truncate"
                                        "use" "describe" "show" "limit" "sort" "partitioned" "comment" ; added by gang
                                        "row format"
                                        "stored as" "load data"
                                        "--"
                                        ) t) "\\(\\s-\\)\\)\\|\\(--*\\)\\|\\(;\\)\\|\\(^```$\\)"))

(defun sql-indent-level-delta (&optional prev-start prev-indent)
  "Calculate the change in level from the previous non-blank line.
Given the optional parameter `PREV-START' and `PREV-INDENT', assume that to be
the previous non-blank line.
Return a list containing the level change and the previous indentation."

  (save-excursion
    ;; Go back to the previous non-blank line
    (let* ((p-line (cond ((and prev-start prev-indent)
                          (list prev-start prev-indent))
                         ((sql-indent-get-last-line-start))))
           (curr-start (progn (beginning-of-line)
                              (point)))
           (paren (nth 0 (parse-partial-sexp (nth 0 p-line) curr-start))))

      ;; Add opening or closing parens.
      ;; If the current line starts with a keyword statement (e.g. SELECT, FROM, ...) back up one level
      ;; If the previous line starts with a keyword statement then add one level

      (list
       (+ paren
          (if (progn (goto-char (nth 0 p-line))
                     (looking-at sql-indent-first-column-regexp))
              1
            0)
          (if (progn (goto-char curr-start)
                     (looking-at sql-indent-first-column-regexp))
              -1
            0)

          ;; when else AFTER case, +1, by cnglen
          (if
              (and
               (progn (goto-char (nth 0 p-line))
                      (looking-at sql-indent-case-column-regexp))
               (progn (goto-char curr-start)
                      (looking-at sql-indent-when-else-column-regexp))
               )
              1
            0
            )

          ;; "end" AFTER *, -1, by cnglen
          (if (progn (goto-char curr-start)
                     (looking-at sql-indent-end-column-regexp))
              -1
            0)

          )
       (nth 1 p-line))
      )
    )
  )

(message ">> hive done")

;; (require-package 'sql-indent)
;; (require 'sql-indent)

;; ;; Update indentation rules, select, insert, delete and update keywords
;; ;; are aligned with the clause start

;; (defvar my-sql-indentation-offsets-alist
;;   `((select-clause 0)
;;     (insert-clause 0)
;;     (delete-clause 0)
;;     (update-clause 0)
;;     ,@sqlind-default-indentation-offsets-alist))


;; (add-hook 'sqlind-minor-mode-hook
;;           (lambda ()
;;             (setq sqlind-indentation-offsets-alist
;;                   my-sql-indentation-offsets-alist)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'before-save-hook 'whitespace-cleanup nil t)

;;; Backup files
(setq make-backup-files t
      version-control t
      kept-old-versions 2
      kept-new-versions 5
      delete-old-versions t
      backup-directory-alist '(("" . "~/.emacs.d/bak")))

;;; Hide Menu/tool/scroll bar
(menu-bar-mode 1)
(tool-bar-mode 0)
                                        ;(scroll-bar-mode 0)

;;; Display time
(setq column-number-mode t
      display-time-day-and-date t
      display-time-24hr-format t
      display-time-format "%Y-%m-%d %H:%M %A" )
(display-time)

;;; 防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，可以很好的看到上下文。
(setq scroll-margin 3
      scroll-conservatively 10000)

;;; Others
(mouse-avoidance-mode 'animate)    ;; 鼠标给光标让路
(auto-image-file-mode)             ;; 让 Emacs 可以直接打开和显示图片
(global-font-lock-mode t)          ;; 进行语法加亮。
(global-auto-revert-mode t)        ;; 当文件被别的程序修改时,load新的
(global-hl-line-mode t)            ;; 高亮光标所在行设置
(setq x-select-enable-clipboard t) ;; 支持emacs和外部程序的粘贴
(server-start) ;; 右键打开时，用已打开的Emacs编辑，而不是另外启动一个Emacs
(show-paren-mode t) ;; 括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号
(setq show-paren-style 'parentheses)    ;
(fset 'yes-or-no-p 'y-or-n-p) ;; Treat 'y' or <CR> as yes, 'n' as no.
(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m] 'act)
(global-set-key (kbd "M-g") 'goto-line) ;; goto-line
(setq fill-column  90)


;;; Insert date
(defun my-insert-date ()
  "Insert current time, such as 2014-10-09-16 14:23:34"
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S" (current-time))))
(global-set-key (kbd "C-c i d") 'my-insert-date)

;;; Count chinese and english words
(defun my-count-ce-word (beg end)
  "Count Chinese and English words in marked region."
  (interactive "r")
  (let ((cn-word 0)
        (en-word 0)
        (total-word 0)
        (total-byte 0))
    (setq cn-word (count-matches "\\cc" beg end)
          en-word (count-matches "\\w+\\W" beg end)
          total-word (+ cn-word en-word)
          total-byte (+ cn-word (abs (- beg end))))
    (message (format "Total: %d (cn: %d, en: %d) words, %d bytes."
                     total-word cn-word en-word total-byte))))

;;; Call sdcv to look up a word
;;;  调用 stardict 的命令行程序 sdcv 来查辞典
;;;  如果选中了 region 就查询 region 的内容，否则查询当前光标所在的单词
;;;  查询结果在一个叫做 *sdcv* 的 buffer 里面显示出来，在这个  buffer  里面
;;;  按 q 可以把这个 buffer 放到 buffer 列表末尾，按  d  可以查询单词
(defun  kid-sdcv-to-buffer  ()
  (interactive)
  (let  ((word  (if  mark-active
                    (buffer-substring-no-properties  (region-beginning)  (region-end))
                  (current-word  nil  t))))
    (setq  word  (read-string  (format  "Search  the  dictionary  for  (default  %s):  "  word)
                               nil  nil  word))
    (set-buffer  (get-buffer-create  "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    (let  ((process  (start-process-shell-command  "sdcv"  "*sdcv*"  "sdcv"  "-n"  word)))
      (set-process-sentinel
       process
       (lambda  (process  signal)
         (when  (memq  (process-status  process)  '(exit  signal))
           (unless  (string=  (buffer-name)  "*sdcv*")
             (setq  kid-sdcv-window-configuration  (current-window-configuration))
             (switch-to-buffer-other-window  "*sdcv*")
             (local-set-key  (kbd  "d")  'kid-sdcv-to-buffer)
             (local-set-key  (kbd  "q")  (lambda  ()
                                           (interactive)
                                           (bury-buffer)
                                           (unless  (null  (cdr  (window-list))) ;  only  one  window
                                             (delete-window)))))
           (goto-char  (point-min))))))))
(put 'upcase-region 'disabled nil)
(global-set-key  (kbd  "C-c  d")  'kid-sdcv-to-buffer)



;;; 按%键跳到括弧另一半
(defun my-match-paren (arg)
  "Go to the matching paren if on a paren; otherwise inser %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'my-match-paren)


(defun dos2unix () (interactive) ;;<------------------------------ dos2unix && unix2dos
       (goto-char (point-min))
       (while (search-forward "\r" nil t) (replace-match "")))
(defun unix2dos () (interactive)
       (goto-char (point-min))
       (while (search-forward "\n" nil t) (replace-match "\r\n")))


;;; Font part
(set-frame-font "Inconsolata 15") ;; English Font
(set-fontset-font "fontset-default" 'unicode "WenQuanYi Zen Hei Mono 15") ; Another Chinese Font
;;; non-free
;; (set-default-font "Consolas 14") ;; English Font
;; (set-fontset-font "fontset-default" 'unicode "Microsoft YaHei 15") ; Chinese Font

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 153
                        :foundry "outline"
                        :family "Inconsolata")))))

;;; Auto detect the coding of file, such as gb2312
(require 'unicad)

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Java
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;; Usage
;; ;; ;;;
;; ;; ;;; 1) M-x start-eclimd or /opt/eclipse/jee-neon/eclipse/eclimd
;; ;; ;;; 2) M-x eclim-project-create or /opt/eclipse/jee-neon/eclipse/eclim -command project_create -f ~/workspace/thinking-in-java -n java -p eclim_project
;; ;; ;;;
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e s")   'eclim-java-method-signature-at-point)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e f d") 'eclim-java-find-declaration)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e f r") 'eclim-java-find-references)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e f t") 'eclim-java-find-type)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e f f") 'eclim-java-find-generic)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e r")   'eclim-java-refactor-rename-symbol-at-point)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e i")   'eclim-java-import-organize)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e h")   'eclim-java-hierarchy)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e z")   'eclim-java-implement)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e d")   'eclim-java-doc-comment)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e f s") 'eclim-java-format)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e g")   'eclim-java-generate-getter-and-setter)
;; ;; ;; (define-key eclim-mode-map (kbd "C-c C-e t")   'eclim-run-junit)
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require-package 'eclim)
;; (require-package 'auto-complete)
;; (require-package 'ac-emacs-eclim)
;; (require-package 'company-emacs-eclim)
;; (require 'eclim)
;; (require 'eclimd)


;; (setq eclimd-autostart t)
;; (defun my-java-mode-hook ()
;;   (eclim-mode t))
;; (add-hook 'java-mode-hook 'my-java-mode-hook)

;; ;;; Eclipse related
;; ;;; - Get eclipse from http://mirrors.ustc.edu.cn/eclipse/eclipse/downloads/
;; ;;; - Install into /opt/eclipse/version
;; ;;; - Install emacs-eclim, see https://github.com/emacs-eclim/emacs-eclim
;; ;;; - Eclpse -> Windows -> Preference -> Java -> buldpath -> Classpath variabele: new and add M2_REPO
;; ;;; - install eclim: see http://eclim.org/install.html#installer-automated
;; ;;; - mvn eclipse:eclipse -DdownloadSources -DdownloadJavadocs
;; (custom-set-variables
;;  '(eclim-eclipse-dirs '("/opt/eclipse/oxygen/eclipse"))
;;  '(eclim-executable "/opt/eclipse/oxygen/eclim"))
;; (setq eclimd-executable  "/opt/eclipse/oxygen/eclimd")
;; (setq eclimd-default-workspace "~/.eclipse_workspace")
;; (setq eclimd-wait-for-process nil)
;; (setq eclim-accepted-file-regexps  '("\\.java$")) ; use eclim only for java

;; (setq help-at-pt-display-when-idle t)
;; (setq help-at-pt-timer-delay 0.1)
;; (help-at-pt-set-timer)

;; ;;; too slow, depends on the PC configuration
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (require 'ac-emacs-eclim)
;; (ac-emacs-eclim-config)

;; (require 'company)
;; (require 'company-emacs-eclim)
;; (company-emacs-eclim-setup)
;; (global-company-mode t)
;; (setq company-global-modes '(not graphviz-dot-mode))

;; (require-package 'use-package)
;; (use-package eclim-mode
;;   :bind (("M-?" . eclim-java-show-documentation-for-current-element))
;;   )
;; ;;; FIXME
;; ;;; M-. -> eclim-java-find-type




;; ;;; How to install google-java-format
;; ;;; - git clone https://github.com/google/google-java-format.git;
;; ;;; - mvn package; copy google-java-format-*-SNAPSHOT-all-deps.jar ~/.emacs.d/lib/google-java-format
;; (require 'google-java-format)
;; (setq google-java-format-executable "~/.emacs.d/bin/google-java-format")
;; ;; ;;(define-key java-mode-map (kbd "C-M-\\") 'google-java-format-region)
;; ;; (defun google-java-format-enable-on-save ()
;; ;;   "Pre-save hook to be used before running autopep8."
;; ;;   (interactive)
;; ;;   (add-hook 'before-save-hook 'google-java-format-buffer nil t))
;; ;; (add-hook 'java-mode-hook 'google-java-format-enable-on-save)

;; ;; ;;; FIXME: java indent 2 to compatile with google-java-format
;; ;; (add-hook 'java-mode-hook (lambda () (setq c-basic-offset 2)))


;; ;; ;;; todo
;; ;; (require-package 'hydra)
;; ;; (defhydra hydra-zoom (eclim-mode-map "C-c C-e")
;; ;;   "zoom"
;; ;;   ("?" eclim-java-show-documentation-for-current-element "doc")
;; ;;   ("r" eclim-java-find-references "references"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Scala
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ensime
(setq ensime-startup-snapshot-notification nil)
(require-package 'scala-mode)
;; (require-package 'ensime)
(require-package 'use-package)
;; (use-package ensime
;;   :ensure t
;;   :pin melpa-stable)

;; (use-package flycheck-cask
;;   :commands flycheck-cask-setup
;;   :config (add-hook 'emacs-lisp-mode-hook (flycheck-cask-setup)))
;; (require 'flycheck-scala-sbt)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; common
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; python-fold
;;; 方案I: outline-magic 对indent不敏感，可能会fold多余的代码块
;; (defun my-pythonFold-hook ()
;;   ;; 正则去匹配Heading: 空行|*def|*class|
;;   (setq outline-regexp "[^ \t\n]\\|[ \t]*\\(def[ \t]+\\|class[ \t]+\\|@\\)") ;; beginning of heading
;;   (setq outline-heading-end-regexp "):\\|->.+:\\|:$")                        ;ending of heading
;;   (outline-minor-mode t)
;;   (define-key outline-minor-mode-map [M-S-down] 'outline-move-subtree-down)
;;   (define-key outline-minor-mode-map [M-S-up] 'outline-move-subtree-up)
;;   (define-key python-mode-map [M-left] 'outline-cycle)
;;   (define-key python-mode-map [M-right] 'outline-show-subtree)
;;   )
;; (add-hook 'python-mode-hook 'my-pythonFold-hook)


;; (require-package 'outline-magic)
;; (require 'outline-magic)

;; (eval-after-load 'outline
;;   '(progn
;;      (require 'outline-magic)
;;      (define-key outline-minor-mode-map (kbd "M-<left>") 'outline-cycle)))

;;; 方案II: hs-minor-mode
(add-hook 'python-mode-hook 'hs-minor-mode)

(load-library "hideshow")
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))


(defun display-code-line-counts (ov)
  (when (eq 'code (overlay-get ov 'hs))
    (overlay-put ov 'help-echo
                 (buffer-substring (overlay-start ov)
                                   (overlay-end ov)))))

(setq hs-set-up-overlay 'display-code-line-counts)

;; Hide the comments too when you do a 'hs-hide-all'
(setq hs-hide-comments nil)
;; Set whether isearch opens folded comments, code, or both
;; where x is code, comments, t (both), or nil (neither)
(setq hs-isearch-open 'x)
;; Add more here


(defun hs-hide-leafs-recursive (minp maxp)
  "Hide blocks below point that do not contain further blocks in
    region (MINP MAXP)."
  (when (hs-find-block-beginning)
    (setq minp (1+ (point)))
    (funcall hs-forward-sexp-func 1)
    (setq maxp (1- (point))))
  (unless hs-allow-nesting
    (hs-discard-overlays minp maxp))
  (goto-char minp)
  (let ((leaf t))
    (while (progn
             (forward-comment (buffer-size))
             (and (< (point) maxp)
                  (re-search-forward hs-block-start-regexp maxp t)))
      (setq pos (match-beginning hs-block-start-mdata-select))
      (if (hs-hide-leafs-recursive minp maxp)
          (save-excursion
            (goto-char pos)
            (hs-hide-block-at-point t)))
      (setq leaf nil))
    (goto-char maxp)
    leaf))
(defun hs-hide-leafs ()
  "Hide all blocks in the buffer that do not contain subordinate
    blocks.  The hook `hs-hide-hook' is run; see `run-hooks'."
  (interactive)
  (hs-life-goes-on
   (save-excursion
     (message "Hiding blocks ...")
     (save-excursion
       (goto-char (point-min))
       (hs-hide-leafs-recursive (point-min) (point-max)))
     (message "Hiding blocks ... done"))
   (run-hooks 'hs-hide-hook)))

(require 'python)
(define-key python-mode-map (kbd "M-<left>") 'toggle-hiding) ;; optional key bindings, easier than hs defaults
(define-key python-mode-map (kbd "M-<right>") 'toggle-selective-display) ;; optional key bindings, easier than hs defaults

;;; js fold
(add-hook 'js-mode-hook 'hs-minor-mode)
;; (define-key js-mode-map (kbd "M-<left>") 'toggle-hiding) ;; optional key bindings, easier than hs defaults
;; (define-key js-mode-map (kbd "M-<right>") 'toggle-selective-display) ;; optional key bindings, easier than hs defaults


(require-package 'yafolding)
(require 'yafolding)
;; (define-key yafolding-mode-map (kbd "<C-S-return>") nil)
;; (define-key yafolding-mode-map (kbd "<C-M-return>") nil)
;; (define-key yafolding-mode-map (kbd "<C-return>") nil)
;; (define-key yafolding-mode-map (kbd "M-<right>") 'yafolding-toggle-all)
;; (define-key yafolding-mode-map (kbd "M-<left>") 'yafolding-toggle-element)


;;; global
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

;;; apt-get install libclang-dev
;;; https://github.com/jeaye/stdman
(require-package 'irony)
(require-package 'irony-eldoc)
(require-package 'company-irony)
(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook 'irony-eldoc)
(define-key irony-mode-map (kbd "M-/") 'company-irony)
(global-set-key  [f1] (lambda () (interactive) (manual-entry (current-word))))


;; Shift the selected region right if distance is postive, left if negative
(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key [C-right] 'shift-right)
(global-set-key [C-left] 'shift-left)

;;; HTML/JS/CSS
(require-package 'skewer-mode)
(require-package 'simple-httpd)
(require-package 'js2-mode)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Xml
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'hideshow)
(require 'sgml-mode)
(require 'nxml-mode)
(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))
(add-hook 'nxml-mode-hook 'hs-minor-mode)
;; optional key bindings, easier than hs defaults
(define-key nxml-mode-map (kbd "M-<left>") 'hs-toggle-hiding)

;;; company dict
(require-package 'company-dict)
(require 'company-dict)
;; Where to look for dictionary files. Default is ~/.emacs.d/dict
(setq company-dict-dir (concat user-emacs-directory "dict/"))
;; Optional: if you want it available everywhere
(add-to-list 'company-backends 'company-dict)
;; Optional: evil-mode users may prefer binding this to C-x C-k for vim
;; omni-completion-like dictionary completion
;; (define-key evil-insert-state-map (kbd "C-x C-k") 'company-dict)

;;; maven
(add-to-list 'load-path "~/.emacs.d/site-lisp/maven-pom-mode")
(load "maven-pom-mode")

;;; dockerfile-mode
(add-to-list 'load-path "~/.emacs.d/site-lisp/dockerfile-mode/")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(add-to-list 'load-path "~/.emacs.d/site-lisp/cypher-mode")
(require 'cypher-mode)
(require-package 'yasnippet-snippets)
(message ">> init-local.el done")


(require-package 'org-ref)
;; (setq reftex-default-bibliography '("~/Workspace/repos/rock_data/doc/paper/arxiv_reference.bib"))

;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/Dropbox/bibliography/notes.org"
      org-ref-default-bibliography '("~/Workspace/repos/rock_data/doc/paper/arxiv_reference.bib")
      org-ref-pdf-directory "~/Documents/doc/paper/arxiv/")

;;; color: 高亮变量，支持Python/Scala/JavaScript/Ruby/Python/Emacs Lisp/ Clojure/ C/ C++/ Rust/ Java/ and Go
(package-install 'color-identifiers-mode)
(add-hook 'after-init-hook 'global-color-identifiers-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; doc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; pdf
(require-package 'pdf-tools)

;;; google 翻译
;; (message "google translate ...")
;; (require-package 'google-translate)
;; (require 'google-translate)
;; (require 'google-translate-smooth-ui)

;; (eval-after-load 'google-translate-core
;;   '(setq google-translate-base-url "https://translate.google.cn"
;;          google-translate-listen-url "https://translate.google.cn/translate_tts"
;;          google-translate-default-target-language "zh-CN"
;;          google-translate-default-source-language ""
;;          ))


;; (eval-after-load 'google-translate-core
;;   '(setq
;;     google-translate-default-target-language "zh-CN"
;;     google-translate-default-source-language ""
;;     ))


;; (setq google-translate-translation-directions-alist
;;       '(("en" . "zh-CN")  ("zh-CN" . "en") ))
;; (setq google-translate-backend-method 'curl)
;; (eval-after-load 'google-translate-tk
;;   '(setq google-translate--tkk-url "https://translate.google.cn/"))
;; (global-set-key "\C-ct" 'google-translate-smooth-translate)


;; (message "google translate done")

(setq debug-on-error 1)


(defun smart-translate ()
  "using googletrans in pypi: pip install googletrans"
  (interactive)
  (if mark-active
      (setq text (strip-string (buffer-substring-no-properties (region-beginning) (region-end))))
    (setq text (thing-at-point 'word 'no-properties)))
  (setq ans (shell-command-to-string (format "translate -s en -d zh-CN '%s'" text))
        buffer-name "*Smart Translate*")
  (with-output-to-temp-buffer buffer-name
    (set-buffer buffer-name)
    (with-current-buffer buffer-name (insert ans)))
  )
(global-set-key "\C-ct" 'smart-translate)


;;; leetcode

(require 'subr-x)
;; (require 'leetcode)

;;; 自顶向下编程: 先框架，再细节
(require-package 'elpygen)
(require 'elpygen)
(define-key python-mode-map (kbd "C-c i f") 'elpygen-implement)



;;; dot
(require-package 'graphviz-dot-mode)
(require 'graphviz-dot-mode)
(add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
(use-package graphviz-dot-mode
  :config
  (setq graphviz-dot-indent-width 4)
  )
(use-package company-graphviz-dot)
(add-hook 'graphviz-dot-mode-hook #'company-mode)

;;; enable counsel mode
(counsel-mode 1)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
;; (global-set-key (kbd "C-s") 'swiper-isearch)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "M-y") 'counsel-yank-pop)
;; (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
;; (global-set-key (kbd "C-c v") 'ivy-push-view)
;; (global-set-key (kbd "C-c V") 'ivy-pop-view)

;; (global-set-key (kbd "C-c c") 'counsel-compile)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c L") 'counsel-git-log)
;; (global-set-key (kbd "C-c k") 'counsel-rg)
;; (global-set-key (kbd "C-c m") 'counsel-linux-app)
;; (global-set-key (kbd "C-c n") 'counsel-fzf)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-c J") 'counsel-file-jump)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;; (global-set-key (kbd "C-c w") 'counsel-wmctrl)

;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "C-c b") 'counsel-bookmark)
;; (global-set-key (kbd "C-c d") 'counsel-descbinds)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c o") 'counsel-outline)
;; ;; (global-set-key (kbd "C-c t") 'counsel-load-theme)
;; (global-set-key (kbd "C-c F") 'counsel-org-file)





(provide 'init-local)
