; 10 planes problem file

(define (problem _10_planes) (:domain airport-ground-operations)
(:objects 
    rw1 - runway
    p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 - plane
    g1 g2 g3 g4 g5 - gate
    cl1 cl2 - cleaners
    ft1 ft2 - fuel-truck
)

(:init
    (= (fuel-truck-capacity) 10000) ; [gal]
    (= (fueling-speed) 800) ; [gal/min]
    (= (fuel-plane-capacity) 6875) ; [gal]
    (= (fuel-plane-level) 0) ; [gal]

    (available_gate g1)
    (available_gate g2)
    (available_gate g3)
    (available_gate g4)
    (available_gate g5)

    (available_runway rw1)
    (available_cleaners cl1)
    ; Un-comment following lines to add a second crew, but for just limited time
    ; (at 40 (available_cleaners cl2))
    ; (at 90 (not (available_cleaners cl2)))

    (available_fuel-truck ft1)
    (= (fuel-truck-level ft1) 10000) ; [gal]
    (available_fuel-truck ft2)
    (= (fuel-truck-level ft2) 10000) ; [gal]

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

    (at 20 (final-approach p4))
    (needs-disembarking p4)
    (needs-cleaning p4) 
    (= (fuel-needed p4) 6789) ; [gal]
    (cleared-for-take-off p4)
    ; (at 90 (not (cleared-for-take-off p4)))

    (at 20 (final-approach p5))
    (needs-disembarking p5)
    (needs-cleaning p5) 
    (= (fuel-needed p5) 1234) ; [gal]
    (cleared-for-take-off p5)

    (at 30 (final-approach p6))
    (needs-disembarking p6)
    (needs-cleaning p6) 
    (= (fuel-needed p6) 2345) ; [gal]
    (cleared-for-take-off p6)

    (at 35 (final-approach p7))
    (needs-disembarking p7)
    (needs-cleaning p7) 
    (= (fuel-needed p7) 3456) ; [gal]
    (cleared-for-take-off p7)

    (at 40 (final-approach p8))
    (needs-disembarking p8)
    (needs-cleaning p8) 
    (= (fuel-needed p8) 1234) ; [gal]
    (cleared-for-take-off p8)

    (at 45 (final-approach p9))
    (needs-disembarking p9)
    (needs-cleaning p9) 
    (= (fuel-needed p9) 1234) ; [gal]
    (cleared-for-take-off p9)

    (at 50 (final-approach p10))
    (needs-disembarking p10)
    (needs-cleaning p10) 
    (= (fuel-needed p10) 1234) ; [gal]
    (cleared-for-take-off p10)

    ; un-comment the next line to trigger standard operational procedure for winter weather
    ; (at 60 (freezing))
)

(:goal (and
        (taken-off p1)
        (taken-off p2)
        (taken-off p3)
        (taken-off p4)
        (taken-off p5)
        (taken-off p6)
        (taken-off p7)
        (taken-off p8)
        (taken-off p9)
        (taken-off p10)
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (cost))
)
