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


;;;;;;;;;;;;;;;;;;;;;;;;Test Cases;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(make-sched '(map (lambda (d) (+ d 1)) '(1 2 3)))