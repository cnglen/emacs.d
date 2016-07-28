;;; hive.el --- Hive SQL mode extension

;; Copyright (C) 2013 Roman Scherer

;; Author: Roman Scherer <roman@burningswell.com>
;; Version: 0.1.1
;; Package-Requires: ((sql "3.0"))
;; Keywords: sql hive

;;; Commentary:

;; This package adds Hive to the sql-mode product list.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(require 'sql)

(defcustom sql-hive-program "hive"
  "Command to start the Hive client."
  :type 'file
  :group 'SQL)

(defcustom sql-hive-options '()
  "List of additional options for `sql-hive-program'."
  :type '(repeat string)
  :group 'SQL)

(defcustom sql-hive-login-params '()
  "List of login parameters needed to connect to Hive."
  :type 'sql-login-params
  :group 'SQL)

(defun sql-comint-hive (product options)
  "Create comint buffer and connect to Hive."
  (let ((params options))
    (sql-comint product params)))

;;;###autoload
(defun sql-hive (&optional buffer)
  "Run hive as an inferior process."
  (interactive "P")
  (sql-product-interactive 'hive buffer))


;;; font-lock
(defvar sql-mode-hive-font-lock-keywords
  (list
   ;; Hive Functions
   (sql-font-lock-keywords-builder 'font-lock-builtin-face nil
                                   "avg" ; to update
                                   )
   ;; Hive Keywords
   (sql-font-lock-keywords-builder 'font-lock-keyword-face nil
                                   "add"  "admin" "after" "all" "alter" "analyze" "and" "archive"  "as" "asc" "authorization"
                                   "before" "between"  "both" "bucket" "buckets" "by"
                                   "cascade" "case" "cast" "change"  "cluster" "clustered" "clusterstatus"
                                   "collection" "column" "columns" "comment" "compact" "compactions"
                                   "compute" "concatenate" "conf" "continue" "create" "cross"
                                   "cube" "current" "current_date" "current_timestamp" "cursor" "data"
                                   "database" "databases" "datetime" "day" "dbproperties"  "deferred"
                                   "defined" "delete" "delimited" "dependency" "desc" "describe"
                                   "directories" "directory" "disable" "distinct" "distribute"  "drop"
                                   "elem_type" "else" "enable" "end" "escaped" "exchange" "exclusive"
                                   "exists" "explain" "export" "extended" "external"
                                   "false" "fetch" "fields" "file" "fileformat" "first"  "following"
                                   "for" "format" "formatted" "from" "full" "function" "functions" "grant" "group" "grouping"
                                   "having" "hold_ddltime" "hour"
                                   "idxproperties" "if" "ignore" "import" "in" "index" "indexes"
                                   "inner" "inpath" "inputdriver" "inputformat" "insert" "intersect" "interval" "into" "is" "items"
                                   "jar" "join" "keys" "key_type"
                                   "lateral" "left" "less" "like" "limit" "lines" "load" "local" "location" "lock" "locks" "logical" "long"
                                   "macro" "mapjoin" "materialized" "minus" "minute" "month" "more" "msck"
                                   "none" "noscan" "not" "no_drop" "null"
                                   "of" "offline" "on" "option" "or" "order" "out" "outer" "outputdriver" "outputformat" "over" "overwrite" "owner"
                                   "partialscan" "partition" "partitioned" "partitions"
                                   "percent" "plus" "preceding" "preserve" "pretty" "principals" "procedure" "protection" "purge"
                                   "range" "read" "readonly" "reads" "rebuild" "recordreader"
                                   "recordwriter" "reduce" "regexp" "reload" "rename" "repair"
                                   "replace" "restrict" "revoke" "rewrite" "right" "rlike" "role" "roles" "rollup" "row" "rows"
                                   "schema" "schemas" "second" "select" "semi" "serde"
                                   "serdeproperties" "server" "set" "sets" "shared" "show" "show_database"
                                   "skewed"  "sort" "sorted" "ssl" "statistics" "stored" "streamtable"
                                   "table" "tables" "tablesample" "tblproperties" "temporary" "terminated"
                                   "then" "to" "touch" "transactions" "transform" "trigger" "true" "truncate"
                                   "unarchive" "unbounded" "undo" "union"  "uniquejoin" "unlock"
                                   "unset" "unsigned" "update" "uri" "use" "user" "using" "utc" "utctimestamp"
                                   "values" "value_type" "view"
                                   "when" "where" "while" "window" "with"
                                   "year"
                                   )
   ;; Hive Data Types
   (sql-font-lock-keywords-builder 'font-lock-type-face nil
                                   "tinyint" "smallint" "int" "bigint"
                                   "float" "double" "decimal"
                                   "string" "varchar" "char"
                                   "boolean"
                                   "binary"
                                   "timestamp" "date"
                                   "array" "struct" "map"
                                   "uniontype" "textfile" "sequencefile" "rcfile" "inputformat" ;; to update
                                   )
   )
  "Hive SQL keywords used by font-lock.

   This variable is used by `sql-mode' and `sql-interactive-mode'.  The
   regular expressions are created during compilation by calling the
   function `regexp-opt'.  Therefore, take a look at the source before
   you define your own `sql-mode-hive-font-lock-keywords'.")

(eval-after-load "sql"
  '(sql-add-product
    'hive "Hive"
    :sqli-program 'sql-hive-program
    :sqli-options 'sql-hive-options
    :sqli-login 'sql-hive-login-params
    :sqli-comint-func 'sql-comint-hive
    :prompt-regexp "^hive> "
    :prompt-length 5
    :font-lock 'sql-mode-hive-font-lock-keywords
    :prompt-cont-regexp "^    > "))

(provide 'hive)

;;; hive.el ends here
