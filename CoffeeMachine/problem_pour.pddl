(define (problem boil) (:domain coffee-machine)

(:init
    (= (water-temperature) 86)
    (cup-in-place)
    (= (cup-capacity) 150)
    (= (cup-level) 0)
)

(:goal (and
        (>= (cup-level) (cup-capacity))
    )
)

)
