(define (problem do-all-jobs) (:domain job-scheduling-example)
    (:requirements :timed-initial-literals)
(:objects 
    red blue - house
    jay pro - painter
    pub - location
)

(:init
    ; red house
    (at 3 (is_available red))
    (at 13 (not (is_available red)))
    (= (paint_duration red) 8)

    ; blue house
    (is_available blue)
    (luxurious blue)
    (= (paint_duration blue) 8)

    ; jay (inexperienced) painter
    (is_available jay)
    (located_at jay pub)

    ; pro painter
    (is_available pro)
    (experienced pro)
    (located_at pro pub)

    (= (travel_time pub blue) 1)
    (= (travel_time pub red) 3)

    (= (cost) 0)
)

(:goal (and
    (forall (?h - house)
        (clean-_done ?h)
    )
))

(:metric minimize (cost))
)


