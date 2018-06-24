;; This is the template for problem files for the 4-action blocks world model.


(define (problem {{data.name}})
(:domain blocks)
  
(:objects
{% if data.blocks|length > 0 %}
	{{ data.blocks|join(' ')}} - block
{% endif %}
)

{% macro output_state(state) %}
	{% for tower in state.towers %}
	; Tower #{{loop.index}}
		{% for block in tower %}
			{% if loop.first %}(ontable {{block}})
			{% else %}(on {{block}} {{tower[loop.index0 - 1]}})
			{% endif %}
			{% if loop.last %}(clear {{block}}){% endif %}
		{% endfor %}
	{% endfor %}

	{% if state.hand %}
	; Hand
		{% if state.hand.empty %}
			(handempty)
		{% endif %}
		{% if state.hand.holding %}
			(holding {{state.hand.holding}})
		{% endif %}
	{% endif %}
{% endmacro %}

(:init
{{output_state(data.init)}}
)

(:goal (and 
{{output_state(data.goal)}}
))
)

