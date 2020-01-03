(define (domain trucks)
(:requirements :typing :fluents :durative-actions :duration-inequalities :negative-preconditions)
(:types vehicle location)
(:predicates
	(at ?x - vehicle ?y - location)
	(driving ?x - vehicle ?y ?z - location) ; Truck is driving from ?y to ?z
	(usedMotorway ?x - vehicle ?y ?z - location) ; Records whether the vehicle used the motorway between the two locations
	(trucking ?v - vehicle) ; Is the truck driving on a regular road?
	(speeding ?v - vehicle) ; Is the truck driving on a high-way?
	(refreshed ?v - vehicle) ; Is the driver refreshed (at the truck stop)
	(road ?x ?y - location) ; Road exists between two locations
)

(:functions
	(distanceTravelled ?v - vehicle) ; The total distance the truck traveled from the origin
	(distance ?x ?y - location) ; Distance between two locations
	(speed ?v - vehicle) ; Speed while driving on a regular road
	(fastspeed ?v - vehicle) ; Speed increase if driving on a highway
)

(:durative-action drive
	:parameters (?v - vehicle ?a ?b - location)
	:duration (<= ?duration 10000) ; this is basically un-constrained duration. The planner will decide when to stop driving.
	:condition (and
		(at start (at ?v?a))
		(at start (road ?a ?b))
		(over all (driving ?v ?a ?b))
	)
	:effect (and
		(at start (assign (distanceTravelled ?v) 0))
		(increase (distanceTravelled ?v) (* #t (speed ?v)))
		(at start (driving ?v ?a ?b)) (at start (not (at ?v ?a)))
	)
)

(:durative-action useMotorway
	:parameters (?v - vehicle ?a ?b - location)
	:duration (<= ?duration 10000)
	:condition (and
		(over all (driving ?v ?a ?b))
		(at start (trucking ?v))
		(at start (refreshed ?v))
	)
	:effect (and
		(at start (not (trucking ?v)))
		(at end (trucking ?v))
		(at start (speeding ?v)) (at end (not (speeding ?v)))
		(at end (usedMotorway ?v ?a ?b)) (at end (not (refreshed ?v)))
		(increase (distanceTravelled ?v) (* #t (fastspeed ?v)))
	)
)

(:action arrive
	:parameters (?v - vehicle ?a ?b - location)
	:precondition (and
		(>= (distanceTravelled ?v) (distance ?a ?b))
		(driving ?v ?a ?b))
	:effect (and
		(not (driving ?v ?a ?b))
		(at ?v ?b)
	)
)

(:action visitTruckStop ; driver needs refreshing...
	:parameters (?v - vehicle)
	:precondition (and
		(>= (distanceTravelled ?v) 10)
		(<= (distanceTravelled ?v) 20)
		(not (refreshed ?v))
	)
	:effect
		(refreshed ?v)
	)
)
