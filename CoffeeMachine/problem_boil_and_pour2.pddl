(define (problem cup60) (:domain coffee-machine)

(:init
    (= (water-temperature) 20)
    (cup-in-place)
    (= (cup-capacity) 120)
    (= (cup-level) 0)
)

(:goal (and
        (>= (cup-level) (cup-capacity))
    )
)

)
