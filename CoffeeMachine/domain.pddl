; This domain demonstrates how an autonomous coffee machine could be operated.
; Specifically, this is the kind of poor-man's espresso machine that
; has to repeat the heat-up and pump cycle several times,
; because the pump pressure is insufficient to brew one cup in one go.

(define (domain coffee-machine)

(:requirements :strips :fluents :durative-actions :typing :negative-preconditions :duration-inequalities)

(:predicates
    (boiling)
    (pumping)
    (cup-in-place)
)


(:functions
    (water-temperature) ; temperature of the water inside the coffee maker boiler [degC]
    (cup-capacity) ; capacity of coffee cup [ml]
    (cup-level) ; level of coffee in the cup [ml]
)

(:durative-action boil-water
    :parameters ()
    :duration (>= ?duration 0)
    :condition (and
        (at start (and
            (not (boiling))
        ))
        (over all (and
            (<= (water-temperature) 100)
        ))
    )
    :effect (and
        (at start (and
            (boiling)
        ))
        (at end (and
            (not (boiling))
        ))
        (increase (water-temperature) (* #t 1.0))
    )
)

(:durative-action pump-boiling-water
    :parameters ()
    :duration (>= ?duration 0)
    :condition (and
        (at start (and
            (not (pumping))
            ; (>= (water-temperature) 99)
        ))
        (over all (and
            (>= (water-temperature) 90)
            (<= (cup-level) (cup-capacity))
            (cup-in-place)
            (boiling)
        ))
    )
    :effect (and
        (at start (and
            (pumping)
        ))
        (at end (and
            (not (pumping))
        ))
        (decrease (water-temperature) (* #t 3.0))
        (increase (cup-level) (* #t 10)) ; 10ml of coffee per second
    )
)


)