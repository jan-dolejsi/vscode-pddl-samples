; Simple domain that is used to demonstrate dynamic problem templating

(define (domain pumping)

(:requirements :strips :fluents :negative-preconditions)

(:functions 
    (target-amount) ; Desired fluid level
    (actual-amount) ; Actual fluid level
)

(:action pumping
    :parameters ()
    :precondition ()
    :effect (and 
        (increase (actual-amount) 1)
    )
)


)