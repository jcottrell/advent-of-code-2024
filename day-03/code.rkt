#lang racket

(require rackunit
         threading)

(provide (rename-out [file->muls-totaled part1])
         (rename-out [file->do-dont-muls-totaled part2]))

;; part one
(define (file->muls-totaled file-name)
   (~> file-name
       (file->lines #:mode 'text)
       flatten
       (string-join "")
       line->raw-muls
       raw-muls->string-pairs
       string-pairs->digit-pairs
       mul-the-digit-pairs
       (apply + _)))

(define (line->raw-muls line)
  (regexp-match* #px"mul\\([[:digit:]]{1,3},[[:digit:]]{1,3}\\)" line))

(define (raw-muls->string-pairs muls)
  (map raw-mul->string-pair muls))

(define (string-pairs->digit-pairs string-pairs)
  (map string-pair->digit-pair string-pairs))

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

(check-equal? (file->muls-totaled "short-example-list1.txt") 161)
(check-equal? (file->muls-totaled "input.txt") 173529487)

;; part two
(define (file->do-dont-muls-totaled file-name)
    (~> file-name
        (file->lines #:mode 'text)
        flatten
        (string-join "")
        line->do-dont-and-muls
        filter-do-donts->raw-muls
        raw-muls->string-pairs
        string-pairs->digit-pairs
        mul-the-digit-pairs
        (apply + _)))

(define (line->do-dont-and-muls line)
  (regexp-match* #px"do\\(\\)|don't\\(\\)|mul\\([[:digit:]]{1,3},[[:digit:]]{1,3}\\)" line))

(check-equal? (line->do-dont-and-muls "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
              '("mul(2,4)" "don't()" "mul(5,5)" "mul(11,8)" "do()" "mul(8,5)"))

(define (filter-do-donts->raw-muls do-dont-and-muls)
  (letrec ([filter-muls (lambda (remaining do-on? result)
                          (cond [(null? remaining) result]
                                [else (let* ([command-or-mul (first remaining)]
                                             [next-remaining (rest remaining)])
                                        (cond [(equal? "do()" command-or-mul)
                                               (filter-muls next-remaining #t result)]
                                              [(equal? "don't()" command-or-mul)
                                               (filter-muls next-remaining #f result)]
                                              [do-on? (filter-muls next-remaining do-on? (append result (list command-or-mul)))]
                                              [else (filter-muls next-remaining do-on? result)]))]))])
    (filter-muls do-dont-and-muls #t '())))

(check-equal? (filter-do-donts->raw-muls '("mul(2,4)" "don't()" "mul(5,5)" "mul(11,8)" "do()" "mul(8,5)"))
              '("mul(2,4)" "mul(8,5)"))

(check-equal? (file->do-dont-muls-totaled "short-example-list2.txt") 48)
(check-equal? (file->do-dont-muls-totaled "input.txt") 99532691)
