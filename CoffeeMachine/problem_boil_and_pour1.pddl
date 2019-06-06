(define (problem boil) (:domain coffee-machine)

(:init
    (= (water-temperature) 35) ; [degC]
    (cup-in-place)
    (= (cup-capacity) 250) ; [ml]
    (= (cup-level) 77) ; [ml]
)

(:goal (and
        (>= (cup-level) (cup-capacity))
    )
)

)
