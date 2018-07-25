;;!pre-parsing:{type: "jinja2", data: "static.json"}

(define (problem {{data.name}}) (:domain pumping)

(:init
    (= (actual-amount) 0)
    (= (target-amount) {{data.amount}})
)

(:goal (and
        (>= (actual-amount) (target-amount))
    )
)

)
