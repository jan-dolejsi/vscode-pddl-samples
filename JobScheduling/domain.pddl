; Job-scheduling experimental syntax sample
; Note that the current version of VAL is not supporting this experimental syntax, so you will see validation errors

(define (domain job-scheduling-example)

    (:requirements 
        :strips :fluents :durative-actions :typing :negative-preconditions 
        :job-scheduling)

    (:types
        house - location
        painter - resource
        floor - object
    )

    (:constants
        ground first - floor
    )

    (:predicates
        (luxurious ?h - house)
        (experienced ?p - painter)
    )

    (:functions
        (cost)
    )

    (:job paint
        :parameters (?h - house ?f - floor ?p - painter)
        :condition (and
            (at start (imply (luxurious ?h) (experienced ?p)))
        )
        :effect (and
            (at start (increase (cost) (paint_duration ?h ?l)))
        )
    )
    (:job clean-up
        :parameters (?h - house ?p - painter)
        :condition (and 
            (at start (and 
                (forall (?f -floor) 
                    (paint_done ?h ?f)
                )
            ))
        )
        :effect (and 
        )
    )
)






