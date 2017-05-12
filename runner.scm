(define (list-set! list k val)
    (if (zero? k)
        (set-car! list val)
        (list-set! (cdr list) (- k 1) val)))
;Value: list-set!



(define (start-runnables sched full-sched i async-run cb)
  (if (= (length sched) 0)
      'done
      (begin
	(if (= (cadr (car sched)) 0)
	    (async-run (car (car sched)) full-sched i cb))
	(start-runnables (cdr sched) full-sched (+ 1 i) async-run cb))))
;Value: start-runnables



(define (async-run prog data id cb)
  (cb id (eval prog (the-environment))))



(define (auto-parallelize program-data async-run)
  (let ((the-schedule (make-sched program-data)))
    (define (cb id result)
      (let ((parent-id (cadr (cadr (list-ref the-schedule id)))))
	(let ((parent (list-ref the-schedule parent-id)))
	  (list-set! the-schedule id result)
	  (if (= (- (list-ref parent 1) 1))
	      (async-run (car parent) the-schedule parent-id cb)
	      (list-set! parent 1 (- (list-ref parent 1) 1))))))
    (start-runnables the-schedule the-schedule 0 async-run cb)