; Job-scheduling experimental syntax sample

(define (domain job-scheduling-example)

    (:requirements 
        :universal-preconditions :disjunctive-preconditions
        :job-scheduling)
    ; to activate the VS Code :job-scheduling code injection, enable the "PDDL: Job Scheduling" setting in your VS Code Settings

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
        (had-coffee-with-owner ?h - house)
        (is_above ?f1 ?f2 - floor)
        )

    (:functions
        (cost)
        )

    (:job paint
        :parameters (?h - house ?f - floor ?p - painter)
        :condition (and
            ; luxurious houses must be decorated by experienced painters
            (at start (imply (luxurious ?h) (experienced ?p)))
            ; example of job predecessor/succcessor encoding: upper floors should be done first
            (at start (forall (?f1 - floor) (imply (is_above ?f1 ?f) (paint_job_done ?h ?f1))))
            )
        :effect (and
            (at start (increase (cost) (paint_job_duration ?h ?f)))
            )
    )
    (:job clean-up
        :parameters (?h - house ?p - painter)
        :condition (and 
            (at start (and 
                (forall (?f - floor) 
                    (paint_job_done ?h ?f)
                )
            ))
            )
        )

    (:durative-action coffee
        :parameters (?h - house ?p - painter)
        :duration (= ?duration 1)
        :condition (and (at start (not (had-coffee-with-owner ?h))) (over all (not (busy ?p))) (over all (located_at ?p ?h)))
        :effect (and (at end (had-coffee-with-owner ?h)))
    )

    )
