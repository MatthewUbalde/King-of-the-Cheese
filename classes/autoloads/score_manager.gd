extends Node

# Signals
signal score_update(score: int)

# Score
enum score_type {
	DEFAULT,
	POKE,
	PET,
	TALK,
	PLAY,
	EAT,
}

var score_value = {
	score_type.DEFAULT: 1,
	score_type.POKE: 20,
	score_type.PET: 50,
	score_type.TALK: 100,
	score_type.PLAY: 250,
	score_type.EAT: 500,
}

# Penalty
enum penalty_type {
	DEFAULT,
	INSULT,
	ANNOY,
	HARASS,
	SCARE,
}

var penalty_value = {
	penalty_type.DEFAULT: 1,
	penalty_type.INSULT: 5,
	penalty_type.ANNOY: 50,
	penalty_type.HARASS: 150,
	penalty_type.SCARE: 750, 
}

var score_current: int = 0

func increase_score() -> void:
	score_current += score_value.get(score_type.DEFAULT)
	score_update.emit(score_current)


func increase_by_score(type: score_type = score_type.DEFAULT) -> void:
	score_current += score_value.get(type)
	score_update.emit(score_current)


func decrease_score() -> void:
	score_current -= score_value.get(penalty_type.DEFAULT)
	score_update.emit(score_current)


func decrease_by_penalty(type: penalty_type = penalty_type.DEFAULT) -> void:
	score_current -= penalty_type.get(type)
	score_update.emit(score_current)
