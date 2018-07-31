(in-package :lem-base)

(export '(encoding
          encoding-read
          encoding-write
          register-encoding
          unregister-encoding))

(defclass encoding () 
  ((end-of-line
    :initarg :end-of-line
    :accessor encoding-end-of-line)))

(defvar *encoding-collections* (make-hash-table :test 'equal))

(defun register-encoding (symbol)
  (assert (symbolp symbol))
  (let ((o (make-instance symbol)))
    (assert (typep o 'encoding))
    (setf (gethash (string symbol) *encoding-collections*) symbol))
  symbol)

(defun unregister-encoding (symbol)
  (remhash (string symbol) *encoding-collections*))

(defun encoding (symbol end-of-line)
  (let ((symbol (gethash (string symbol) *encoding-collections* symbol)))
    (assert (symbolp symbol))
    (if (keywordp symbol)
        symbol
        (make-instance symbol :end-of-line end-of-line))))

(defgeneric encoding-read (external-format input output-char))
(defgeneric encoding-write (external-format out))
