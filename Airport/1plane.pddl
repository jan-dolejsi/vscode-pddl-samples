; Single plan problem file

(define (problem _1plane) (:domain airport-ground-operations)
(:objects
    rw1 - runway
    p1 - plane
    g1 - gate
    cl1 - cleaners
    ft1 - fuel-truck
)

(:init
    (= (fuel-truck-capacity) 10000) ; [gal]
    (= (fueling-speed) 800) ; [gal/min]
    (= (fuel-plane-capacity) 6875) ; [gal]
    (= (fuel-plane-level) 0) ; [gal] - at plan execution the actual value comes from sensors

    (available_gate g1)

    (available_runway rw1)
    (available_cleaners cl1)

    (available_fuel-truck ft1)
    (= (fuel-truck-level ft1) 10000) ; [gal]

    (at 5 (final-approach p1))
    (needs-disembarking p1)
    (needs-cleaning p1)
    (= (fuel-needed p1) 2345) ; [gal]
    (at 50 (cleared-for-take-off p1))

    ; (freezing)
)

(:goal (and
        (taken-off p1)
    )
)

)
