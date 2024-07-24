
;; This is the 4-action blocks world domain which does not refer to a table object and distinguishes actions for moving blocks to-from blocks and moving blocks to-from table

(define (domain blocksworld)

(:requirements :typing
:negative-preconditions)

(:types block) ; we do not need a table type as we use a special ontable predicate

(:predicates
	(on ?a ?b - block)
	(clear ?a - block)
	(holding ?a - block)
	(handempty)
	(ontable ?x - block)
)

(:action pickup ; this action is only for picking from table
:parameters (?x - block)
:precondition (and (ontable ?x)
				(handempty)
				(clear ?x)
			)
:effect (and (holding ?x)
			 (not (handempty))
			 (not (clear ?x))
			 (not (ontable ?x))
		)
)
(:action unstack ; only suitable for picking from block
:parameters (?x ?y - block)
:precondition (and (on ?x ?y)
				(handempty)
				(clear ?x)
			)
:effect (and (holding ?x)
			 (not (handempty))
			 (not (clear ?x))
			 (clear ?y)
			 (not (on ?x ?y))
		)
)

(:action putdown
:parameters (?x - block)
:precondition (and (holding ?x)
			)
:effect (and (ontable ?x)
			 (not (holding ?x))
			 (handempty)
			 (clear ?x)
		)
)

(:action stack
:parameters (?x ?y - block)
:precondition (and (holding ?x)
				(clear ?y)
			)
:effect (and (on ?x ?y)
			 (not (holding ?x))
			 (handempty)
			 (not (clear ?y))
			 (clear ?x)
		)
)

)