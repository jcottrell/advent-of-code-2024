#lang racket

(require rackunit
         threading)

;; part one
(define (file->number-of-safe-reports file-name)
  (~> file-name
      (file->lines #:mode 'text)
      lines->reports
      (filter valid-report _)
      length))

(define (lines->reports lines)
  (map (lambda (line)
        (map string->number
           (regexp-split #rx" +" line)))
     lines))

(check-equal? (lines->reports '("7 6 4 2 1" "1 2 7 8 9" "9 7 6 2 1" "1 3 2 4 5" "8 6 4 4 1" "1 3 6 7 9"))
              '((7 6 4 2 1) (1 2 7 8 9) (9 7 6 2 1) (1 3 2 4 5) (8 6 4 4 1) (1 3 6 7 9)))

(define (valid-report report)
   (and (or (one-direction > report)
            (one-direction < report))
        ((constrained 1 3) report)))

(define (one-direction direction numbers [previous-value #f])
  (cond [(null? numbers) #t]
        [(or (not previous-value)
             (direction previous-value (first numbers)))
         (one-direction direction (rest numbers) (first numbers))]
        [else #f]))

(check-equal? (one-direction < '(1 2 3 4 5)) #t)
(check-equal? (one-direction > '(10 8 5 1)) #t)
;; test stopping early
(check-equal? (one-direction > '(1 5 4 "error here")) #f)

(define (constrained lowest-change highest-change)
  (lambda (numbers)
    (letrec ([check-two (lambda (remaining)
                          (cond [(<= (length remaining) 1) #t]
                                [else (let* ([left (first remaining)]
                                             [right (second remaining)]
                                             [change (abs (- left right))])
                                        (and (>= change lowest-change)
                                             (<= change highest-change)
                                             (check-two (rest remaining))))]))])
      (check-two numbers))))

(check-equal? ((constrained 1 3) '(1 2)) #t)
(check-equal? ((constrained 1 3) '(2 1)) #t)
(check-equal? ((constrained 1 3) '(3 2 1)) #t)
(check-equal? ((constrained 1 3) '(1 5)) #f)
(check-equal? ((constrained 1 3) '(1 1)) #f)
(check-equal? ((constrained 1 2) '(5 3 1)) #t)

(check-equal? (valid-report '(7 6 4 2 1)) #t)
(check-equal? (valid-report '(1 2 7 8 9)) #f)
(check-equal? (valid-report '(9 7 6 2 1)) #f)
(check-equal? (valid-report '(1 3 2 4 5)) #f)
(check-equal? (valid-report '(8 6 4 4 1)) #f)
(check-equal? (valid-report '(1 3 6 7 9)) #t)

(check-equal? (file->number-of-safe-reports "short-example-list.txt") 2)
;(file->number-of-safe-reports "input.txt"); 246