(define program '(+ (- 4 6) (/ 5 (* 2 (- 3 4) (* 5 6))) (+ 7 (* 4 5 (- 4 6)))))
;Value: program

(define simple-prog '(+ (* 4 5) 1))
;Value: simple-prog


(eval program (the-environment))
;Value: -421/12

(eval simple-prog (the-environment))
;Value: 21


(define (calc-deps program)
  (let loop ((spot (cdr program)) (count 0))
    (if (pair? (car spot))
	(set! count (+ 1 count)))    
    (if (= (length spot) 1)
	count
	(loop (cdr spot) count))))
;Value: calc-deps



(define (number-deps program sched parent)
  (let loop ((spot (cdr program)) (re-def `(,(car program))) (count 0))
    (if (pair? (car spot))
	(begin
	  (append! re-def `((get-dep ,(length sched))))
	  (set! sched (number-deps (car spot) sched (+ (length sched) (calc-deps program))))
	  (set! count (+ 1 count)))
	(append! re-def `(,(car spot))))
    (if (= (length spot) 1)
	(begin
	  (set! sched (append! sched `(,(cons re-def (cons count parent)))))
	  sched)
	(loop (cdr spot) re-def count))))
;Value: number-deps


(number-deps simple-prog '() #f)
(
 ((* 4 5) 0 . 1)
 ((+ (get-dep 0) 1) 1 . #f)
)

(pp (number-deps program '() #f))
(
 ((- 4 6) 0 . 3) 
 ((- 3 4) 0 . 3)
 ((* 5 6) 0 . 4)
 ((* 2 (get-dep 1) (get-dep 2)) 2 . 2)
 ((/ 5 (get-dep 1)) 1 . 4)
 ((- 4 6) 0 . 6)
 ((* 4 5 (get-dep 5)) 1 . 6)
 ((+ 7 (get-dep 5)) 1 . 8)
 ((+ (get-dep 0) (get-dep 1) (get-dep 5)) 3 . #f)
)









