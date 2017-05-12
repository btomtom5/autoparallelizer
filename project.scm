(load "schedule")

(define program '(+ (- 4 6) (/ 5 (* 2 (- 3 4) (* 5 6))) (+ 7 (* 4 5 (- 4 6)))))
;Value: program

(define simple-prog '(+ (* 4 5) 1))
;Value: simple-prog


(eval program (the-environment))
;Value: -421/12

(eval simple-prog (the-environment))
;Value: 21



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
    

(auto-parallelize simple-prog async-run)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(map (lambda (d) (+ d 1)) '(1 2 3))
;Value 26: (2 3 4)

(static-eval prog var-alist)






