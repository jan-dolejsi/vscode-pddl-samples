(define (domain driverlog)
(:requirements :typing :fluents) 
(:types 
  location locatable - object
  driver truck obj - locatable
)

(:predicates 
  (at ?obj - locatable ?loc - location) ; `?obj` is at location `?loc`
  (in ?obj1 - obj ?t - truck) ; package `?obj` is in a truck `?t`
  (driving ?d - driver ?v - truck) ; driver `?d` is driving truck `?t`
  (link ?x ?y - location) ; there is a _road_ between `?x` and `?y`
  (path ?x ?y - location) ; there is a _foot path_ between `?x` and `?y`
  (empty ?t - truck) ; truck is empty
)

(:functions 
  (time-to-walk ?l1 ?l2 - location)
  (time-to-drive ?l1 ?l2 - location)
  (driven) ; total time driven
  (walked) ; total time walked
)

(:action LOAD-TRUCK
  :parameters (
    ?obj - obj
    ?truck - truck
    ?loc - location
  )
  :precondition (and 
    (at ?truck ?loc) 
    (at ?obj ?loc)
  )
  :effect (and 
    (not (at ?obj ?loc))
    (in ?obj ?truck)
  )
)

(:action UNLOAD-TRUCK
  :parameters (
    ?obj - obj
    ?truck - truck
    ?loc - location)
  :precondition (and 
    (at ?truck ?loc) 
    (in ?obj ?truck)
  )
  :effect (and 
    (not (in ?obj ?truck))
    (at ?obj ?loc)
  )
)

(:action BOARD-TRUCK
  :parameters (
    ?driver - driver
    ?truck - truck
    ?loc - location)
  :precondition (and 
    (at ?truck ?loc) 
    (at ?driver ?loc) 
    (empty ?truck)
  )
  :effect (and 
    (not (at ?driver ?loc)) 
    (driving ?driver ?truck) 
    (not (empty ?truck))
  )
)

(:action DISEMBARK-TRUCK
  :parameters (
    ?driver - driver
    ?truck - truck
    ?loc - location)
  :precondition (and 
    (at ?truck ?loc) 
    (driving ?driver ?truck)
  )
  :effect (and 
    (not (driving ?driver ?truck)) 
    (at ?driver ?loc) 
    (empty ?truck)
  )
)

(:action DRIVE-TRUCK
  :parameters (
    ?truck - truck
    ?loc-from - location
    ?loc-to - location
    ?driver - driver)
  :precondition (and 
    (at ?truck ?loc-from)
    (driving ?driver ?truck)
    (link ?loc-from ?loc-to)
  )
  :effect (and 
    (not (at ?truck ?loc-from)) 
    (at ?truck ?loc-to)
		(increase (driven) (time-to-drive ?loc-from ?loc-to)
  )
)
)

(:action WALK
  :parameters (
    ?driver - driver
    ?loc-from - location
    ?loc-to - location)
  :precondition (and 
    (at ?driver ?loc-from)
    (path ?loc-from ?loc-to)
  )
  :effect (and 
    (not (at ?driver ?loc-from))
    (at ?driver ?loc-to)
	  (increase (walked) (time-to-walk ?loc-from ?loc-to))
  )
)
 
)
