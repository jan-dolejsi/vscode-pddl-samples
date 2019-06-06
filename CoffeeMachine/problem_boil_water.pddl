(define (problem boil) (:domain coffee-machine)

(:init
    (= (water-temperature) 20)
)

(:goal (and
        (>= (water-temperature) 21)
    )
)

)
