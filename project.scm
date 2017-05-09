
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



(define (number-deps sched queue)
  (let qloop ((queue queue)) 
    (if (= (length queue) 0)
	sched
	(let ((program (car (car queue)))) 
	  (let loop ((spot (cdr program)) (re-def `(,(car program))) (count 0))
	    (if (pair? (car spot))
		(begin
		  (append! re-def `((get-dep ,(+ (length sched) (length queue)))))
		  (set! queue (append! queue `(,(cons (car spot) (length sched)))))
		  (set! count (+ 1 count)))
		(append! re-def `(,(car spot))))
	    (if (= (length spot) 1)
		(begin
		  (set! sched (append! sched `(,(cons re-def (cons count (cdr (car queue)))))))
		  (qloop (cdr queue)))
		(loop (cdr spot) re-def count)))))))
;Value: number-deps


(define (make-sched program)
  (number-deps '() `((,program #f))))
;Value: make-sched


(pp (make-sched simple-prog))
(
 ((+ (get-dep 1) 1) 1 #f) 
 ((* 4 5) 0 . 0)
)


(pp (make-sched program))
(
 ((+ (get-dep 1) (get-dep 2) (get-dep 3)) 3 #f) 
 ((- 4 6) 0 . 0)
 ((/ 5 (get-dep 4)) 1 . 0)
 ((+ 7 (get-dep 5)) 1 . 0)
 ((* 2 (get-dep 6) (get-dep 7)) 2 . 2)
 ((* 4 5 (get-dep 8)) 1 . 3)
 ((- 3 4) 0 . 4)
 ((* 5 6) 0 . 4)
 ((- 4 6) 0 . 5)
)

