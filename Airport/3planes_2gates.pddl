; 10 planes problem file

(define (problem _3planes_2gates) (:domain airport-ground-operations)
(:objects 
    rw1 - runway
    p1 p2 p3 - plane
    g1 g2 - gate
    cl1 - cleaners
    ft1 - fuel-truck
)


(:init
    (= (fuel-truck-capacity) 10000) ; [gal]
    (= (fueling-speed) 800) ; [gal/min]
    (= (fuel-plane-capacity) 6875) ; [gal]
    (= (fuel-plane-level) 0) ; [gal]

    (available_gate g1)
    (available_gate g2)

    (available_runway rw1)
    (available_cleaners cl1)
    ; Un-comment following lines to add a second crew, but for just limited time
    ; (at 40 (available_cleaners cl2))
    ; (at 90 (not (available_cleaners cl2)))

    (available_fuel-truck ft1)
    (= (fuel-truck-level ft1) 10000) ; [gal]

    (at 5 (final-approach p1))
    (needs-disembarking p1)
    (needs-cleaning p1)
    (= (fuel-needed p1) 2345) ; [gal]
    (cleared-for-take-off p1)

    (at 10 (final-approach p2))
    (needs-disembarking p2)
    (needs-cleaning p2)
    (= (fuel-needed p2) 3456) ; [gal]
    (cleared-for-take-off p2)

    (at 15 (final-approach p3))
    (needs-disembarking p3)
    ; try removing (needs-cleaning) and adding (clean) 
    ; (clean p3) ; Easyjet does not pay for ground staff cleaning
    (needs-cleaning p3) 
    (= (fuel-needed p3) 1234) ; [gal]
    (cleared-for-take-off p3)
    ; un-comment the next line to trigger standard operational procedure for winter weather
    ; (at 60 (freezing))
)

(:goal (and
        (taken-off p1)
        (taken-off p2)
        (taken-off p3)
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (cost))
)
