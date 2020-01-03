(define (domain driverlog)
(:requirements :typing :fluents) 
(:types 
  location locatable - object
  driver truck obj - locatable
)

(:predicates 
  (link ?x ?y - location) ; there is a _road_ between `?x` and `?y`
  (path ?x ?y - location) ; there is a _foot path_ between `?x` and `?y`
  (empty ?t - truck) ; truck is empty
)

(:functions 
  (time-to-walk ?l1 ?l2 - location)
  (time-to-drive ?l1 ?l2 - location)
  (driven) ; total time driven
  (walked) ; total time walked

  (at_loc ?obj - locatable) - location ; location of `?obj`
  (in ?obj1 - obj)  - truck ; truck that contains package `?obj`
  (driving ?d - driver) - truck ; truck driven by driver `?d`
)

(:action LOAD-TRUCK
  :parameters (
    ?obj - obj
    ?truck - truck
    ?loc - location
  )
  :precondition (and 
    (= (at_loc ?truck) ?loc) 
    (= (at_loc ?obj) ?loc)
  )
  :effect (and 
    (assign (at_loc ?obj) undefined)
    (assign (in ?obj) ?truck)
  )
)

(:action UNLOAD-TRUCK
  :parameters (
    ?obj - obj
    ?truck - truck
    ?loc - location)
  :precondition (and 
    (= (at_loc ?truck) ?loc) 
    (= (in ?obj) ?truck)
  )
  :effect (and 
    (assign (in ?obj) undefined)
    (assign (at_loc ?obj) ?loc)
  )
)

(:action BOARD-TRUCK
  :parameters (
    ?driver - driver
    ?truck - truck
    ?loc - location)
  :precondition (and 
    (= (at_loc ?truck) ?loc) 
    (= (at_loc ?driver) ?loc) 
    (empty ?truck)
  )
  :effect (and 
    (assign (at_loc ?driver) undefined) 
    (assign (driving ?driver) ?truck) 
    (not (empty ?truck))
  )
)

(:action DISEMBARK-TRUCK
  :parameters (
    ?driver - driver
    ?truck - truck
    ?loc - location)
  :precondition (and 
    (= (at_loc ?truck) ?loc) 
    (= (driving ?driver) ?truck)
  )
  :effect (and 
    (assign (driving ?driver) undefined)
    (assign (at_loc ?driver) ?loc) 
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
    (= (at_loc ?truck) ?loc-from)
    (= (driving ?driver) ?truck)
    (link ?loc-from ?loc-to)
  )
  :effect (and 
    (assign (at_loc ?truck) ?loc-to)
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
    (= (at_loc ?driver) ?loc-from)
    (path ?loc-from ?loc-to)
  )
  :effect (and 
    (assign (at_loc ?driver) ?loc-to)
    (increase (walked) (time-to-walk ?loc-from ?loc-to))
  )
)
 
)
