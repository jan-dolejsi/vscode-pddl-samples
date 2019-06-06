; Airport ground operations planning model

(define (domain airport-ground-operations)

(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :negative-preconditions :duration-inequalities)

(:types plane runway gate cleaners fuel-truck
)

(:predicates
    (freezing) ; it is freezing

    ; plane properties
    (final-approach ?p - plane) ; Aircraft is prepared for landing
    (landing ?p - plane) ; Aircraft is landing and a runway must be reserved for it
    (landed ?p - plane) ; Aircraft has landed
    (at_gate ?p - plane) ; Aircraft is at a gate
    (at_plane_gate ?p - plane ?g - gate) ; Aircraft p is at gate g
    (no_passengers ?p - plane) ; There are no passengers on board
    (clean ?p - plane) ; Aircraft was cleaned or did not need cleaning
    (boarding-completed ?p - plane) ; Boarding is completed
    (re-fueled ?p - plane) ; Aircraft was re-fueled
    (pushing-back ?p - plane) ; Aircraft is being pushed back from the gate
    (pushed-back ?p - plane) ; Aircraft was pushed back from the gate
    (at_runway-beginning ?p - plane ?rw - runway) ; Aircraft is at the
    (de-iced ?p - plane) ; Aircraft **was** de-iced
    (cleared-for-take-off ?p - plane) ; Aircraft **was cleared for take-off** by the control tower
    (taken-off ?p - plane) ; plane took off
    (needs-disembarking ?p - plane)
    (needs-cleaning ?p - plane) ; Aircraft requires ground staff cleaning

    ; runway properties
    (available_runway ?rw - runway) ; Runway is **operational** and **available**

    ; gate properties
    (available_gate ?g - gate) ; Gate is **operational** and **available**

    ; cleaners properties
    (available_cleaners ?cl - cleaners) ; Cleaner crew is on duty and **not busy**

    ; fuel truck properties
    (available_fuel-truck ?ft - fuel-truck) ; Fuel-truck is available
)

(:functions
    (fuel-needed ?p - plane) ; Amount of fuel needed to re-fuel the aircraft, but at most `(fuel-plane-capacity)` in [gal]
    (fuel-plane-capacity) ; Maximum fuel capacity of the Boeing 737 [gal]
    (fuel-plane-level) ; Actual **fuel level in the aircraft**. During plan execution it comes from the aircraft systems. Note: for simplicity of the model and demo, the function is defined without the `?p` parameter, so we do not have to set it for every plane in the problem file.
    (fuel-truck-capacity) ; Fuel truck capacity [gal]
    (fuel-truck-level ?ft - fuel-truck) ; Level of fuel in the fuel truck [gal]
    (fueling-speed) ; Re-fueling speed the fuel truck can deliver [gal/min]
)

(:durative-action land
    :parameters (?p - plane ?rw - runway)
    :duration (= ?duration 2)
    :condition (and
        (at start (and
            (final-approach ?p)
            (available_runway ?rw)
        ))
    )
    :effect (and
        (at start (and
            (not (available_runway ?rw))
            (not (final-approach ?p))
            (landing ?p)
        ))
        (at end (and
            (available_runway ?rw)
            (landed ?p)
            (not (landing ?p))
        ))
    )
)

(:durative-action taxi-to-gate
    :parameters (?p - plane ?g - gate)
    :duration (= ?duration 5)
    :condition (and
        (at start (and
            (landed ?p)
            (available_gate ?g)
        ))
    )
    :effect (and
        (at start (and
            (not (landed ?p))
            (not (available_gate ?g))
        ))
        (at end (and
            (at_gate ?p)
            (at_plane_gate ?p ?g)
        ))
    )
)

(:durative-action disembark
    :parameters (?p - plane)
    :duration (= ?duration 7)
    :condition (and
        (at start (and
            (needs-disembarking ?p)
            (at_gate ?p)
        ))
        ; (over all ())
        ; (at end ())
    )
    :effect (and
        (at start (and
            (not (needs-disembarking ?p))
        ))
        (at end (and
            (no_passengers ?p)
        ))
    )
)

(:durative-action cleaning
    :parameters (?p - plane ?cl - cleaners)
    :duration (= ?duration 5)
    :condition (and
        (at start (and
            (no_passengers ?p)
            (needs-cleaning ?p)
            (available_cleaners ?cl)
        ))
    )
    :effect (and
        (at start (and
            (not (available_cleaners ?cl))
        ))
        (at end (and
            (clean ?p)
            ; (not (needs-cleaning ?p))
            (available_cleaners ?cl)
        ))
    )
)

(:durative-action boarding
    :parameters (?p - plane)
    :duration (= ?duration 15)
    :condition (and
        (at start (and
            (at_gate ?p)
            (no_passengers ?p)
            (clean ?p)
        ))
    )
    :effect (and
        (at start (and
            (not (no_passengers ?p))
        ))
        (at end (and
            (boarding-completed ?p)
        ))
    )
)

(:durative-action re-fuel
    :parameters (?p - plane ?ft - fuel-truck)
    :duration (= ?duration (+ 5 (/ (fuel-needed ?p) (fueling-speed))))
    :condition (and
        (at start (and
            (at_gate ?p)
            (not (re-fueled ?p))
            (>= (fuel-truck-level ?ft) (fuel-needed ?p))
            (available_fuel-truck ?ft)
        ))
        (over all (and
            ; must not over-fill the fuel capacity
            (<= (fuel-plane-level) (fuel-plane-capacity))
        ))
    )
    :effect (and
        (at start (and
            (not (available_fuel-truck ?ft))
        ))
        (at end (and
            (available_fuel-truck ?ft)
            (re-fueled ?p)
            (decrease (fuel-truck-level ?ft) (fuel-needed ?p))
        ))
    )
)

;; Re-fill the fuel truck
(:durative-action re-fill-fuel-truck
    :parameters (?ft - fuel-truck)
    :duration (= ?duration 30)
    :condition (and
        (at start
            (available_fuel-truck ?ft)
        )
    )
    :effect (and
        (at start (and
            (not (available_fuel-truck ?ft))
        ))
        (at end (and
            (available_fuel-truck ?ft)
            (assign (fuel-truck-level ?ft) (fuel-truck-capacity))
        ))
    )
)

; Push the  aircraft back from the gate for take-off
(:durative-action push-back
    :parameters (?p - plane ?g - gate)
    :duration (= ?duration 3)
    :condition (and
        (at start (and
            (at_gate ?p)
            (at_plane_gate ?p ?g)
            (boarding-completed ?p)
            ; the bug is right here!!! Missing condition: (re-fueled ?p)
            (not (pushing-back ?p))
            (not (pushed-back ?p))
        ))
    )
    :effect (and
        (at start (and
            (pushing-back ?p)
        ))
        (at end (and
            (available_gate ?g)
            (not (pushing-back ?p))
            (pushed-back ?p)
        ))
    )
)

(:durative-action de-ice
    :parameters (?p - plane ?rw - runway)
    :duration (= ?duration 10)
    :condition (and
        (at start (and
            (at_runway-beginning ?p ?rw)
            (freezing)
            (not (de-iced ?p))
        ))
    )
    :effect (and
        (at end (and
            (de-iced ?p)
            (freezing) ; this is to compensate a bug
        ))
    )
)

(:durative-action taxi-to-runway
    :parameters (?p - plane ?rw - runway)
    :duration (= ?duration 5)
    :condition (and
        (at start (and
            (pushed-back ?p)
        ))
    )
    :effect (and
        (at end (and
            (at_runway-beginning ?p ?rw)
        ))
    )
)

(:action _no-de-icing_needed
    :parameters (?p - plane ?rw - runway)
    :precondition (and
        (at_runway-beginning ?p ?rw)
        (not (freezing))
    )
    :effect (and
        (de-iced ?p)
    )
)

(:durative-action take-off
    :parameters (?p - plane ?rw - runway)
    :duration (= ?duration 2)
    :condition (and
        (at start (and
            (at_runway-beginning ?p ?rw)
            (available_runway ?rw)
            (de-iced ?p)
            (cleared-for-take-off ?p)
        ))
    )
    :effect (and
        (at start (and
            (not (available_runway ?rw))
        ))
        (at end (and
            (available_runway ?rw)
            (taken-off ?p)
        ))
    )
)

)