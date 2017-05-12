(load "schedule")



(eval program (the-environment))
;Value: -421/12

(eval simple-prog (the-environment))
;Value: 21
    

(auto-parallelize simple-prog async-run)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(map (lambda (d) (+ d 1)) '(1 2 3))
;Value 26: (2 3 4)

(static-eval prog var-alist)






