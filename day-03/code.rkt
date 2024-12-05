#lang racket

(require rackunit
         threading)

;; part one
(define (file->muls-totaled file-name)
   (~> file-name
       (file->lines #:mode 'text)
       lines->digit-pairs
       (map mul-the-digit-pairs _)
       flatten
       (apply + _)))

(define (lines->digit-pairs lines)
  (~> lines
      (map line->raw-muls _)
      (map raw-muls->string-pairs _)
      (map string-pairs->digit-pairs _)))

(define (raw-muls->string-pairs muls)
  (map raw-mul->string-pair muls))

(define (string-pairs->digit-pairs string-pairs)
  (map string-pair->digit-pair string-pairs))

(define (line->raw-muls line)
  (regexp-match* #px"mul\\([[:digit:]]{1,3},[[:digit:]]{1,3}\\)" line))

(check-equal? (line->raw-muls "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
              '("mul(2,4)" "mul(5,5)" "mul(11,8)" "mul(8,5)"))

(define (string-pair->digit-pair string-pair)
  (list (string->number (first string-pair))
        (string->number (second string-pair))))

(check-equal? (string-pair->digit-pair '("2" "4")) '(2 4))

(define (raw-mul->string-pair mul)
  (regexp-match* #px"[[:digit:]]{1,3}" mul))

(check-equal? (raw-mul->string-pair "mul(2,4)")
              '("2" "4"))

(define (mul-the-digit-pairs digit-pairs)
  (map (lambda (digit-pair)
        (* (first digit-pair)
           (second digit-pair)))
     digit-pairs))

(check-equal? (mul-the-digit-pairs '((2 4) (5 5) (11 8) (8 5)))
              '(8 25 88 40))

(check-equal? (file->muls-totaled "short-example-list.txt") 161)
;(file->muls-totaled "input.txt")
