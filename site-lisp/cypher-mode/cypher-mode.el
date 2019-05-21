;;; cypher-mode.el --- major mode for editing cypher scripts

;; Copyright 2013 François-Xavier Bois

;; Version: 0.0.6
;; Package-Version: 20151110.1142
;; Author: François-Xavier Bois <fxbois AT Google Mail Service>
;; Maintainer: François-Xavier Bois
;; Created: Sept 2013
;; Keywords: cypher graph
;; URL: http://github.com/fxbois/cypher-mode
;; Repository: http://github.com/fxbois/cypher-mode

;; =========================================================================
;; This work is sponsored by Kernix : Digital Agency (Web & Mobile) in Paris
;; =========================================================================

;; This file is not part of Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Code:

(defgroup cypher nil
  "Major mode for editing cypher scripts."
  :version "0.0.6"
  :group 'languages)

(defgroup cypher-faces nil
  "Faces for syntax highlighting."
  :group 'cypher-mode
  :group 'faces)

(defcustom cypher-indent-offset 2
  "Indentation level."
  :type 'integer
  :group 'cypher-mode)

(defface cypher-clause-face
  '((t :inherit font-lock-builtin-face))
  "Face for language clauses."
  :group 'cypher-faces)

(defface cypher-keyword-face
  '((t :inherit font-lock-keyword-face))
  "Face for language keywords."
  :group 'cypher-faces)

(defface cypher-function-face
  '((t :inherit font-lock-function-name-face))
  "Face for language function."
  :group 'cypher-faces)

(defface cypher-node-type-face
  '((t :inherit font-lock-constant-face))
  "Face for language keywords."
  :group 'cypher-faces)

(defface cypher-relation-type-face
    '((t :inherit font-lock-type-face))
  "Face for language keywords."
  :group 'cypher-faces)

(defface cypher-relation-arrow-face
  '((t :foreground "DeepPink" :background "grey16" :bold t))
  "Face for relation arrow."
  :group 'cypher-faces)

(defface cypher-variable-face
  '((t :inherit font-lock-variable-name-face))
  "Face for variable."
  :group 'cypher-faces)

(defface cypher-property-face
  '((t :foreground "olive drab" :bold nil))
  "Face for variables."
  :group 'cypher-faces)

(defvar cypher-clauses
  (regexp-opt
   '(
     ;; opencyphter v9
     "call" "yield" "create" "delete" "detach delete" "limit" "match" "mandatory match"
     "merge" "optional match" "order by" "ending" "remove" "return" "as" "set" "set" "skip" "union"
     "union all" "unwind" "with" "where"

     ;; neo4j only
     "start" "where" "using index" "using index seek" "using scan" "using join" "foreach"
     "on create" "on match" "load csv" "using periodic commit"
     "create constraint on" "drop constraint on" "create index on" "drop index on"

     ))
  "Cypher clauses: See <Cypher Query Language Reference, Version 9>, P200 and https://neo4j.com/docs/cypher-manual/current/clauses/.")


(defvar cypher-functions
  (regexp-opt
   '("abs" "acos" "asin" "atan" "atan2" "avg" "ceil" "coalesce" "collect" "cos"
     "cot" "count" "degrees" "e" "endnode" "exists" "exp" "floor" "id" "keys"
     "labels" "last" "left" "length" "log" "log10" "ltrim" "max" "min" "nodes"
     "percentilecont" "percentiledisc" "pi" "properties" "radians" "rand" "range"
     "relationships" "replace" "reverse" "right" "round" "rtrim" "sign" "sin" "size"
     "split" "sqrt" "startnode" "stdev" "stdevp" "substring" "sum" "tail" "tan" "timestamp"
     "toboolean" "tofloat" "tointeger" "tolower" "tostring" "toupper" "trim" "type"))
  "Cypher functions, See <Cypher Query Language Reference, Version 9>, P202.")


(defvar cypher-keywords
  (regexp-opt
   '("all" "allshortestpaths" "and" "any" "as" "asc" "ascending" "assert" "by"
     "case" "constraint on" "count" "create constraint on" "create index on"
     "create unique" "create" "delete" "desc" "descending" "distinct"
     "drop constraint on" "drop index on" "drop" "else" "end" "extract" "false"
     "fieldterminator" "filter" "foreach" "from" "has" "in" "is not null"
     "is null" "is unique" "is" "limit" "load csv" "match" "merge" "node" "none"
     "not" "null" "on create" "on match" "on" "optional match" "or" "order by"
     "reduce" "rel" "relationship" "remove" "return distinct" "return" "scan"
     "set" "shortestpath" "single" "skip" "start" "then" "true" "union all"
     "union" "unique" "unwind" "using index" "using periodic commit" "using scan"
     "when" "where" "with distinct" "with headers" "with" "xor"))
  "Cypher keywords.")



;;; update by cnglen
(defvar cypher-font-lock-keywords
  (list
   '(")?\\(<?->?\\)\\[" 1 'cypher-relation-arrow-face) ; 边
   '("\\]\\(<?->?\\)(?" 1 'cypher-relation-arrow-face) ; 边
   '("--\\|->\\|<-" 0 'cypher-relation-arrow-face) ; 边
   (cons (concat "\\<\\(" cypher-clauses "\\)\\>") '(1 'cypher-clause-face)) ; clause
   (cons (concat "\\<\\(" cypher-keywords "\\)\\>") '(1 'cypher-keyword-face)) ;keyword
   (cons (concat "\\<\\(" cypher-functions "\\)\\((\\).*?\\()\\)") '( (1 'cypher-keyword-face) )) ; 内置函数
   '( "-\\[[[:alnum:] _]*\\(:[[:alnum:] _]+\\)" 1 'cypher-relation-type-face) ; RELATION TYPE
   '( "([[:alnum:] _]*\\(:[[:alnum:] _]+\\)" 1 'cypher-node-type-face) ; NODE LABEL, 目前只支持一个Label
   '( "\\(\\[\\|(\\)[ ]*\\([[:alnum:] _]+[ ]*\\)" 2 'cypher-variable-face )       ; NODE or RELATION variable
   '( "\\([[:alpha:]][[:alnum:]_ ]*\\):" . 'cypher-property-face) ; 属性
   ))


(defvar cypher-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; _   : word
    (modify-syntax-entry ?_ "w" table)
    ;; //  : comment
    (modify-syntax-entry ?\/ ". 12b" table)
    (modify-syntax-entry ?\n "> b" table)
    ;; ' " : strings
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\' "\"" table)
    (modify-syntax-entry ?\` "\"" table)
    table)
  "Syntax table.")

(defvar cypher-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c r") 'cypher-reload)
    ))

(eval-and-compile
  (defalias 'cypher-prog-mode
    (if (fboundp 'prog-mode) 'prog-mode 'fundamental-mode))
  (if (fboundp 'with-silent-modifications)
      (defalias 'cypher-with-silent-modifications 'with-silent-modifications)
    (defmacro cypher-with-silent-modifications (&rest body)
      "For compatibility with Emacs pre 23.3"
      `(let ((old-modified-p (buffer-modified-p))
             (inhibit-modification-hooks t)
             (buffer-undo-list t))
         (unwind-protect
             ,@body
           (set-buffer-modified-p old-modified-p)))))
  )

(defvar cypher-font-lock-defaults
  '(cypher-font-lock-keywords nil t))

;;;###autoload
(define-derived-mode cypher-mode cypher-prog-mode "Cypher"
  "Major mode for editing web templates."
  (make-local-variable 'comment-end)
  (make-local-variable 'comment-start)
  (make-local-variable 'font-lock-defaults)
  ;;  (make-local-variable 'font-lock-keywords-case-fold-search)
  (make-local-variable 'indent-line-function)
  (setq comment-end ""
        comment-start "//"
        font-lock-defaults cypher-font-lock-defaults
        indent-line-function 'cypher-indent-line)
  )

(defun cypher-reload ()
  "Reload cypher."
  (interactive)
  (cypher-with-silent-modifications
   (unload-feature 'cypher-mode)
   (cypher-mode)
   (if (fboundp 'cypher-mode-hook)
       (cypher-mode-hook))))

(defun cypher-indent-line ()
  "Indent current line."
  (let ( ctx
         (inhibit-modification-hooks t)
         (offset)
         pos
         (regexp "^\s*\\(CREATE\\|ORDER\\|MATCH\\|LIMIT\\|SET\\|SKIP\\|START\\|RETURN\\|WITH\\|WHERE\\|DELETE\\|FOREACH\\|USING\\|LOAD\\|MERGE\\|//\\)")
         )

    (save-excursion
      (back-to-indentation)
      (setq pos (point))
      (setq ctx (cypher-block-context pos))
      (cond
       ((string-match-p regexp (thing-at-point 'line))
        (setq offset 0)
        )
       ((plist-get ctx :arg-inline)
        (setq offset (plist-get ctx :column))
        )
       ((re-search-backward regexp nil t)
        (goto-char (match-end 1))
        (skip-chars-forward "[:space:]")
        (setq offset (current-column))
        )
       (t
        (setq offset cypher-indent-offset))
       ))

    (when offset
      (let ((diff (- (current-column) (current-indentation))))
        (setq offset (max 0 offset))
        (indent-line-to offset)
        (if (> diff 0) (forward-char diff))
        )
      )

    )
  )

(defun cypher-block-context (&optional pos)
  "Count opened opened block at point."
  (interactive)
  (unless pos (setq pos (point)))
  (save-excursion
    (goto-char pos)
    (let ((continue t)
          (match "")
          (case-found nil)
          (case-count 0)
          (queues (make-hash-table :test 'equal))
          (opened-blocks 0)
          (col-num 0)
          (regexp "[\]\[}{)(]")
          (num-opened 0)
          close-char n queue arg-inline arg-inline-checked char lines)

      (while (and continue (re-search-backward regexp nil t))
        (setq match (match-string-no-properties 0)
              char (char-after))

        (cond

         ((member char '(?\{ ?\( ?\[))
          (cond
           ((eq char ?\() (setq close-char ?\)))
           ((eq char ?\{) (setq close-char ?\}))
           ((eq char ?\[) (setq close-char ?\])))

          (setq queue (gethash char queues nil))
          (setq queue (push (cons (point) (cypher-line-number)) queue))
          (puthash char queue queues)
          ;;(message "%c queue=%S" char queue)

          (setq queue (gethash close-char queues nil))
          (setq n (length queue))
          (cond
           ((> n 0)
            (setq queue (cdr queue))
            (puthash close-char queue queues)
            ;;(message "%c queue=%S" close-char queue)
            (setq queue (gethash char queues nil))
            (setq queue (cdr queue))
            (puthash char queue queues)
            ;;(message "%c queue=%S" char queue)
            )
           ((= n 0)
            (setq num-opened (1+ num-opened))
            ;;(message "num-opened=%S %S" num-opened (point))
            )
           )

          (when (and (= num-opened 1) (null arg-inline-checked))
            (setq arg-inline-checked t)
            ;;              (when (not (member (char-after (1+ (point))) '(?\n ?\r ?\{)))
            (when (not (looking-at-p ".[ ]*$"))
              (setq arg-inline t
                    continue nil
                    col-num (1+ (current-column))))
            ;;              (message "pt=%S" (point))
            )

          );case

         ((member char '(?\} ?\) ?\]))
          (setq queue (gethash char queues nil))
          (setq queue (push (point) queue))
          (puthash char queue queues)
          ;;            (message "%c queue=%S" char queue)
          )

         );cond

      );while

      (unless arg-inline
        (maphash
         (lambda (char queue)
           (when (member char '(?\{ ?\( ?\[))
             ;;(message "%c => %S" char queue)
             (dolist (pair queue)
               (setq n (cdr pair))
               (unless (member n lines)
                 (push n lines))
               )
             );when
           )
         queues)
        (setq opened-blocks (length lines))
        (when (and case-found (> case-count 0))
          (goto-char pos)
          (back-to-indentation)
          (when (not (looking-at-p "}"))
            (setq opened-blocks (1+ opened-blocks))
            )
          )
        );unless

      ;;      (message "opened-blocks(%S) col-num(%S) arg-inline(%S)" opened-blocks col-num arg-inline)

      (let ((ctx (list :block-level opened-blocks
                       :arg-inline arg-inline
                       :column col-num)))

        (message "ctx=%S" ctx)

        ctx)

      )))

(defun cypher-line-number (&optional pos)
  "Return line number at point."
  (unless pos (setq pos (point)))
  (let (ret)
    (setq ret (+ (count-lines 1 pos)
                 (if (= (cypher-column-at-pos pos) 0) 1 0)))
    ret))

(defun cypher-column-at-pos (&optional pos)
  "Column at point"
  (unless pos (setq pos (point)))
  (save-excursion
    (goto-char pos)
    (current-column)
    ))

;;;###autoload
(progn
  (add-to-list 'auto-mode-alist '("\\.cypher\\'" . cypher-mode))
  (add-to-list 'auto-mode-alist '("\\.cyp\\'" . cypher-mode)))

(provide 'cypher-mode)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; cypher-mode.el ends here
