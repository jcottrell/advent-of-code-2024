#lang racket

(require rackunit
         threading)

(provide (rename-out [file->difference-total part1])
         (rename-out [file->similarity-score part2]))

;; part 1
(define (file->difference-total file-name)
   (~> file-name
       (file->lines #:mode 'text)
       lines->pairs
       pairs->number-lists
       (map (lambda (number-list) (sort number-list <)) _)
       lists->differences
       (apply + _)))

(define (lines->pairs lines [result '()])
  (cond [(null? lines) result]
        [else (lines->pairs (cdr lines)
                            (append result
                                    (list (map string->number (regexp-split #rx" +" (car lines))))))]))

(check-equal? (lines->pairs '("3   4"
                              "4   3"
                              "2   5"
                              "1   3"
                              "3   9"
                              "3   3"))
            '((3 4)
              (4 3)
              (2 5)
              (1 3)
              (3 9)
              (3 3)))

(define (pairs->number-lists pairs)
  (list (map first pairs)
        (map second pairs)))

(check-equal? (pairs->number-lists '((3 4)
                                     (4 3)
                                     (2 5)
                                     (1 3)
                                     (3 9)
                                     (3 3)))
              '((3 4 2 1 3 3)
                (4 3 5 3 9 3)))

(define (lists->differences list-of-lists)
  (map (lambda (left right)
        (abs (- left right)))
     (first list-of-lists)
     (second list-of-lists)))

(check-equal? (lists->differences '((1 2 3 3 3 4)
                                    (3 3 3 4 5 9)))
              '(2 1 0 1 2 5))

(check-equal? (file->difference-total "short-example-list.txt") 11)
;(file->difference-total "input.txt"); 2904518

;; part two
(define (file->similarity-score file-name)
   (~> file-name
       (file->lines #:mode 'text)
       lines->pairs
       pairs->number-lists
       lists->occurances
       left-list*occurances
       (apply + _)))

(define (count-occurances some-number some-list)
  (count (lambda (number-from-list)
           (= number-from-list some-number))
         some-list))

(check-equal? (count-occurances 5 '(1 2 3 4 5 4 3 2 5)) 2)
(check-equal? (count-occurances 6 '(1 2 3 4 5 4 3 2 5)) 0)

(define (lists->occurances list-of-lists)
  (let ([left-list (first list-of-lists)]
        [right-list (second list-of-lists)])
    (list left-list
          (map (lambda (l) (count-occurances l right-list))
             left-list))))

(check-equal? (lists->occurances '((3 4 2 1 3 3)
                                   (4 3 5 3 9 3)))
              '((3 4 2 1 3 3)
                (3 1 0 0 3 3)))

(define (left-list*occurances left-and-occurances)
  (map (lambda (left occurance)
        (* left occurance))
     (first left-and-occurances)
     (second left-and-occurances)))

(check-equal? (left-list*occurances '((3 4 2 1 3 3)
                                      (3 1 0 0 3 3)))
              '(9 4 0 0 9 9))

(check-equal? (file->similarity-score "short-example-list.txt") 31)
;(file->similarity-score "input.txt"); 18650129
