(define (problem Houston-Austin-ElPaso)
(:domain trucks)

(:objects
	bigRed - vehicle
    Houston Austin elpaso - location
)

(:init
	; (= (distanceTravelled bigRed) 0)
	(road Houston Austin)
	(road Austin ElPaso)
	(at bigRed Houston)
	(= (distance Houston Austin) 165)
	(= (distance Austin ElPaso) 574)
	(trucking bigRed)
    (= (speed bigRed) 40)
	(= (fastSpeed bigred) 20)
	(refreshed bigred)
)

 (:goal (and (at bigRed ElPaso)
	;(usedmotorway bigred houston austin)
	;(usedmotorway bigred austin elpaso)
	)
)
)