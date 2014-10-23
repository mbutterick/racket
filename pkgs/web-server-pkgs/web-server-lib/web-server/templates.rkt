#lang racket/base
(require xml
         scribble/text
         (for-syntax racket/base
                     racket/list
                     syntax/parse)
         racket/port)

(define-syntax (include-template stx)
  (syntax-parse stx
    [(_ (~optional (~seq #:command-char command-char:expr)) p:expr)
     (quasisyntax/loc stx
       (let ([result (include/text #,@(if (attribute command-char)
                                             (list #'#:command-char #'command-char)
                                             empty)
                                      p)])
         (if (bytes? result) 
             result 
             (with-output-to-string (λ () (output result))))))]))

(define-syntax include-template/xexpr
  (syntax-rules ()
    [(_ . p)
     (string->xexpr (include-template . p))]))

(define-syntax in
  (syntax-rules ()
    [(_ x xs e ...)
     (for/list ([x xs])
       (begin/text e ...))]))

(provide include-template
         in)
