extends Node2D


# This is Poopatron's Rock btw
# I didn't recognized what the phrase meant, so I'm like really sorry.
#I just bursted in laughter because of how loud it was, and accepted it.
#so sorry sorry if this was weird. or i'm weird.

# I hate you Poopatron I genuienly regret putting this in LOL

@onready var hurtbox_component:= $HurtboxComponent

func _ready() -> void:
	hurtbox_component.hurt.connect(on_hurtbox_component_hurt)

func on_hurtbox_component_hurt() -> void:
	$AudioStreamPlayer2D.play()
