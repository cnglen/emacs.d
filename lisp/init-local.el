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
(require-package 'ob-ipython)
(require-package 'elpy)
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
(setq py-autopep8-options '("--max-line-length=120"))
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(add-hook 'python-mode-hook (lambda ()
                              (require 'sphinx-doc)
                              (sphinx-doc-mode t)))
;; (elpy-enable)
;; ;; (setq python-shell-interpreter "ipython"
;; ;;       python-shell-interpreter-args "--simple-prompt -i")
;; (setq python-shell-interpreter "python") ; to use ob-ipython
;; ;; (elpy-use-ipython)                        ; disabled to use ob-ipython
;; ;; (setq python-shell-interpreter "ipython") ; disabled to use ob-ipython
;; (setq python-shell-interpreter "ipython3") ; alternative
;; (setq python-shell-interpreter-args "--pylab --nosep --pprint") ; alternative
;; (add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "-i --pylab --nosep --pprint") ; alternative
(setq python-shell-interpreter-args "-i --pprint") ; alternative
(setq python-shell-virtualenv-root "/opt/anaconda3/")

;;; for ipython5
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")
(message ">>   python done ...")




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ORG-MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message ">>   org started ...")
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


;;; slide
(require-package 'ox-reveal)
(require 'ox-reveal)
(setq org-reveal-root "file:////opt/reveal.js"
      org-reveal-mathjax t
      org-reveal-hlevel 1 ; The minimum level of headings that should be grouped into vertical slides.
      org-reveal-single-file nil
      org-reveal-width 1600
      org-reveal-height 793
      org-reveal-margin "-1"
      org-reveal-min-scale "0.8"
      org-reveal-max-scale "2.0"
      )

;; (defunsacha/org-html-checkbox (checkbox)
;;   "Format CHECKBOX into HTML."
;;   (case checkbox (on "<span class=\"check\">&#x2611;</span>") ; checkbox (checked)
;;         (off "<span class=\"checkbox\">&#x2610;</span>")
;;         (trans "<code>[-]</code>")
;;         (t "")))
;; (defadviceorg-html-checkbox (around sacha activate)
;;   (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0))))

;;; ipython in org-mode
(require 'ob-ipython)
(setq org-confirm-babel-evaluate nil) ; don't prompt me to confirm everytime I want to evaluate a block
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append) ; display/update images in the buffer after I evaluate

;;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(yas-reload-all)
(add-hook 'org-mode-hook 'yas-minor-mode)


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

;;; dot
(require-package 'graphviz-dot-mode)
(add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))

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

;; (require 'ob-mermaid)
(message ">>   org started done")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Hive
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
      :free-software t
      :font-lock 'sql-mode-hive-font-lock-keywords
      :sqli-program 'sql-hive-program
      :sqli-options 'sql-hive-options
      :sqli-login 'sql-hive-login-params
      :sqli-comint-func 'sql-comint-hive
      :prompt-regexp "^hive> "
      :prompt-length 5
      :prompt-cont-regexp "^    > "
      )))

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
                                        "--" ) t) "\\(\\b\\|\\s-\\)\\)\\|\\(^```$\\)"))

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
(scroll-bar-mode 0)

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
(set-default-font "Inconsolata 15") ;; English Font
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; R
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require-package 'ess)
;; (require-package 'ess-R-data-view)
;; (require-package 'ess-R-object-popup)
;; (require-package 'polymode)
;; (require-package 'hideshow-org)
;; (require-package 'ess-smart-underscore)

;; (require 'ess-site)
;; (require 'poly-R)
;; (require 'poly-markdown)
;; (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
;; (defun ess-rmarkdown ()
;;   "Compile R markdown (.Rmd).  Should work for any output type."
;;   ;; Compile rmarkdown to HTML or PDF with M-n s
;;   ;; Use YAML in Rmd doc to specify the usual options which can be seen at http://rmarkdown.rstudio.com/
;;   ;; Thanks http://roughtheory.com/posts/ess-rmarkdown.html
;;   (interactive)
;;   (condition-case nil                   ; Check if attached R-session
;;       (ess-get-process)
;;     (error
;;      (ess-switch-process)))
;;   (let* ((rmd-buf (current-buffer)))
;;     (save-excursion
;;       (let* ((sprocess (ess-get-process ess-current-process-name))
;;              (sbuffer (process-buffer sprocess))
;;              (buf-coding (symbol-name buffer-file-coding-system))
;;              (R-cmd
;;               (format "library(rmarkdown); rmarkdown::render(\"%s\")"
;;                       buffer-file-name)))
;;         (message "Running rmarkdown on %s" buffer-file-name)
;;         (ess-execute R-cmd 'buffer nil nil)
;;         (switch-to-buffer rmd-buf)
;;         (ess-show-buffer (buffer-name sbuffer) nil)))))
;; (define-key polymode-mode-map "\M-ns" 'ess-rmarkdown)

;; ;;; <- and _
;; (ess-toggle-S-assign nil)
;; (ess-toggle-S-assign nil)
;; (ess-toggle-underscore nil)

;; ;;; Write table in Rmd using org
;; (require 'org-table)
;; (defun cleanup-org-tables ()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward "-+-" nil t) (replace-match "-|-"))
;;     ))
;; (add-hook 'markdown-mode-hook 'orgtbl-mode)
;; (add-hook 'markdown-mode-hook
;;           (lambda()
;;             (add-hook 'after-save-hook 'cleanup-org-tables  nil 'make-it-local)))


;; ;;; Code folding for ESS
;; ;;; 1) Using hs-minor-mode, based on {}, (), [] using org shortcut keys
;; (require 'hideshow-org)
;; (add-hook 'ess-mode-hook 'hs-minor-mode)
;; (add-hook 'ess-mode-hook 'hs-org/minor-mode)
;; ;;; 2) Using org-mode based on {### * H1, ### ** H2, ### *** H3}
;; (add-hook 'ess-mode-hook 'turn-on-orgstruct)
;; (setq orgstruct-heading-prefix-regexp "^### ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ctrip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun connect-remote ()
;;   (interactive)
;;   (dired "/user@ip_or_server#port:/home/username"))

;;; TBD
;; (setq cscope-do-not-update-database t)
;;; pandoc-mode


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Java
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Usage
;;;
;;; 1) M-x start-eclimd or /opt/eclipse/jee-neon/eclipse/eclimd
;;; 2) M-x eclim-project- create or /opt/eclipse/jee-neon/eclipse/eclim -command project_create -f ~/workspace/thinking-in-java -n java -p eclim_project
;;;
;; (define-key eclim-mode-map (kbd "C-c C-e s")   'eclim-java-method-signature-at-point)
;; (define-key eclim-mode-map (kbd "C-c C-e f d") 'eclim-java-find-declaration)
;; (define-key eclim-mode-map (kbd "C-c C-e f r") 'eclim-java-find-references)
;; (define-key eclim-mode-map (kbd "C-c C-e f t") 'eclim-java-find-type)
;; (define-key eclim-mode-map (kbd "C-c C-e f f") 'eclim-java-find-generic)
;; (define-key eclim-mode-map (kbd "C-c C-e r")   'eclim-java-refactor-rename-symbol-at-point)
;; (define-key eclim-mode-map (kbd "C-c C-e i")   'eclim-java-import-organize)
;; (define-key eclim-mode-map (kbd "C-c C-e h")   'eclim-java-hierarchy)
;; (define-key eclim-mode-map (kbd "C-c C-e z")   'eclim-java-implement)
;; (define-key eclim-mode-map (kbd "C-c C-e d")   'eclim-java-doc-comment)
;; (define-key eclim-mode-map (kbd "C-c C-e f s") 'eclim-java-format)
;; (define-key eclim-mode-map (kbd "C-c C-e g")   'eclim-java-generate-getter-and-setter)
;; (define-key eclim-mode-map (kbd "C-c C-e t")   'eclim-run-junit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require-package 'eclim)
(require-package 'auto-complete)
(require-package 'ac-emacs-eclim)
(require-package 'company-emacs-eclim)
(require 'eclim)
(require 'eclimd)
(add-hook 'java-mode-hook 'eclim-mode)
(custom-set-variables
 '(eclim-eclipse-dirs '("/opt/eclipse/jee-neon/eclipse"))
 '(eclim-executable "/opt/eclipse/jee-neon/eclipse/eclim"))
(setq eclimd-executable  "/opt/eclipse/jee-neon/eclipse/eclimd")
(setq eclimd-default-workspace "~/.eclipse_workspace")
(setq eclimd-wait-for-process nil)
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)
(require 'auto-complete-config)
(ac-config-default)
(require 'ac-emacs-eclim)
(ac-emacs-eclim-config)
(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

(require-package 'use-package)
(use-package eclim-mode
  :bind (("M-?" . eclim-java-show-documentation-for-current-element)
         ))



;;; todo
(require-package 'hydra)
(defhydra hydra-zoom (eclim-mode-map "C-c C-e")
  "zoom"
  ("?" eclim-java-show-documentation-for-current-element "doc")
  ("r" eclim-java-find-references "references"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Scala
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ensime
(setq ensime-startup-snapshot-notification nil)
(require-package 'scala-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; common
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'origami)
(define-key origami-mode-map (kbd "M-<left>") 'origami-recursively-toggle-node)
(define-key origami-mode-map (kbd "M-<right>") 'origami-show-only-node)



;; ;;; C/C++
;; (require 'xcscope)
;; (cscope-setup)

;;; global
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))



;;; todo

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
(define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)


;;; ipython notebook
(require-package 'ein)
(require 'ein)
;; (require-package 'smartrep)
;; (setq ein:use-auto-complete t)
;; ;; Or, to enable "superpack" (a little bit hacky improvements):
;; ;; (setq ein:use-auto-complete-superpack t)
;; (setq ein:use-smartrep t)

(message ">> init-local.el done")

(provide 'init-local)
