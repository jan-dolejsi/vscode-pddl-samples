; Schlumberger Public
; Domain models power generator, which needs to be refueled to keep running,
; but the fuel tank must not overflow. The fuel is available in external tanks.
(define (domain generator)
(:requirements :fluents :durative-actions :duration-inequalities
		:negative-preconditions :typing)

(:types generator tank)

(:predicates 
	(generator-ran) ; Flags that the generator ran
	(used ?t - tank) ; To force the planner to empty the entire tank in one action (rather than bit by bit), we mark the tank as 'used'
)

(:functions 
	(fuel-level ?t - generator) ; Fuel level in the generator
	(fuel-reserve ?t - tank) ; Fuel reserve in the tank
	(refuel-rate ?g - generator) ; Refuel rate of the generator
	(capacity ?g - generator) ; Total fuel-capacity of the generator
)

(:durative-action generate
	:parameters (?g - generator)
	:duration (= ?duration  100) ; arbitrarily the duration is set to 100 time-units
	:condition 
		(over all (>= (fuel-level ?g) 0))
	:effect (and 
		(decrease (fuel-level ?g) (* #t 1))
	    (at end (generator-ran))
	)
)

(:durative-action refuel ; refuels the tank
	:parameters (?g - generator ?t - tank)
	:duration (= ?duration 
		(/  ; duration is defined as amount of fuel divided by re-fueling rate.
			(fuel-reserve ?t) 
			(refuel-rate ?g)
		)
	)		 
	:condition (and 
		(at start (not (used ?t)))
		(over all (<= (fuel-level ?g) (capacity ?g))) ; must not overflow!!!
	)
	:effect (and 
		(at start (used ?t))
		; when following line is uncommented, the planner will decide to re-fuel as late as possible
		(decrease (capacity ?g) (* #t 0.5))
  	    (decrease (fuel-reserve ?t) (* #t (refuel-rate ?g)))
	    (increase (fuel-level ?g) (* #t (refuel-rate ?g)))
	)
)
)
