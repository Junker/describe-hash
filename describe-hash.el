;;; describe-hash.el --- Help function for examining a hash map

;; Version: 0.1.0
;; URL: https://github.com/Junker/describe-hash
;; Original: https://www.emacswiki.org/emacs/HashMap


;;; Commentary:
;; This package provides help function for examining hash map values,
;; similar to `describe-variable'

;;; Code:

(defun describe-hash (variable &optional buffer)
  "Display the full documentation of VARIABLE (a hash).
Returns the documentation as a string, also.
If VARIABLE has a buffer-local value in BUFFER (default to the current buffer),
it is displayed along with the global value."
  (interactive
   (let ((v (variable-at-point))
         (enable-recursive-minibuffers t)
         val)
     (setq val (completing-read
                (if (and (symbolp v)
                         (hash-table-p (symbol-value v)))
                    (format
                     "Describe hash-map (default %s): " v)
                  "Describe hash-map: ")
                obarray
                (lambda (atom) (and (boundp atom)
                                    (hash-table-p (symbol-value atom))))
                t nil nil
                (if (hash-table-p v) (symbol-name v))))
     (list (if (equal val "")
               v (intern val)))))
  (with-output-to-temp-buffer (help-buffer)
    (maphash (lambda (key value)
               (pp key)
               (princ " => ")
               (pp value)
               (terpri))
             (symbol-value variable))))

(provide 'describe-hash)

;;; describe-hash.el ends here
