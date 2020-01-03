(define (problem boil) (:domain coffee-machine)

(:init
    (= (water-temperature) 20) ; [degC]
    (cup-in-place)
    (= (cup-capacity) 60) ; [ml]
    (= (cup-level) 0) ; [ml]
)

(:goal (and
        (>= (cup-level) (cup-capacity))
    )
)

)
