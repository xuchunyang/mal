;; -*- lexical-binding: t; -*-

(defun mal-read ()
  (ignore-errors (read-string "user> ")))

(let (input)
  (while (setq input (mal-read))
    (princ (format "%s\n" input))))
