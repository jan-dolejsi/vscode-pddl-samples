(define (problem blocks)(:domain blocksworld)

(:objects
    red green blue brown pink gold - block
    )

(:init
    ;tower
    (ontable red) ; Block red
    (on green red) ; Block green
    (on blue green)(clear blue) ; Block blue
    ;tower
    (ontable brown) ; Block brown
    (on pink brown) ; Block pink
    (on gold pink)(clear gold) ; Block gold

    (handempty)

)

(:goal (and
    (on red brown)
    (on green red)
    (holding gold)
))
)