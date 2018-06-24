; Templated driver log problem file
;;!pre-parsing:{type: "nunjucks", data: "problem00.json"}
 

(define (problem {{data.name}})
(:domain driverlog)
(:objects
    {{data.locations|join(" ")}} - location
    {{data.drivers|map("name")|join(" ")}} - driver
    {{data.trucks|map("name")|join(" ")}} - truck
    {{data.packages|map("name")|join(" ")}} - obj
)
(:init
;;( drivers
    {% for driver in data.drivers %}
    ; Driver: {{driver.name}}
        (at {{driver.name}} {{driver.initLocation}})
    {% endfor %}
;;)
;;( trucks
    {% for truck in data.trucks %}
    ; Truck: {{truck.name}}
        (at {{truck.name}} {{truck.initLocation}})
        {% if truck.empty %}
            (empty {{truck.name}})
        {% endif %}
    {% endfor %}
;;)

;;( packages
    {% for package in data.packages -%}
        (at {{package.name}} {{package.initLocation}})
    {%- endfor %}
;;)

;;( paths
    {% for path in data.paths %}
        (path {{path.a}} {{path.b}})
        (path {{path.b}} {{path.a}})
        (= (time-to-walk {{path.a}} {{path.b}}) {{path.timeToWalk}})
        (= (time-to-walk {{path.b}} {{path.a}}) {{path.timeToWalk}})
    {% endfor %}
;;)

;;( roads
    {% for link in data.links %}
        (link {{link.a}} {{link.b}})
        (link {{link.b}} {{link.a}})
        (= (time-to-drive {{link.a}} {{link.b}}) {{link.timeToDrive}})
        (= (time-to-drive {{link.b}} {{link.a}}) {{link.timeToDrive}})
    {% endfor %}
;;)

    ; numeric initializations
	(= (driven) 0)
	(= (walked) 0)
)

(:goal (and
    {% for driver in data.drivers -%}
        {% if driver.goalLocation -%}
            (at {{driver.name}} {{driver.goalLocation}})
        {%- endif %}
    {%- endfor %}

    {% for truck in data.trucks -%}
        {% if truck.goalLocation -%}
            (at {{truck.name}} {{truck.goalLocation}})
        {%- endif %}
    {%- endfor %}

    {% for package in data.packages -%}
        {% if package.goalLocation -%}
            (at {{package.name}} {{package.goalLocation}})
        {%- endif %}
    {%- endfor %}

))

(:metric minimize (+ (+ 
    (* 2  (total-time)) 
    (* 1  (driven))) 
    (* 3  (walked)))
)

)
