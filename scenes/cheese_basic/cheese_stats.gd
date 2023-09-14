extends Node

#var speed_rand_range := 20.0
#var speed_base := 75
##var speed_boost: float = 1.0 # Means no boost!
#
#var idle_wait_time_range: float = 3.0
#var move_wait_time_range: float = 3.0
#var idle_wait_time: float = 6.0 # Default
#var move_wait_time: float = 4.0 # Default

const SPEED_RAND_RANGE := 20.0
const SPEED_BASE := 75

const SPEED_INSANE_FACTOR := 1.25
const SPEED_MADNESS_FACTOR := 3.00
const SPEED_DELUSIONAL_FACTOR := 0.90

const IDLE_WAIT_TIME_BASE := 4
const IDLE_WAIT_TIME_INSANE := 2.4
const IDLE_WAIT_TIME_MADNESS := 0.24
const IDLE_WAIT_TIME_DELUSIONAL := 0.024

const MOVE_WAIT_TIME_BASE := 6
const MOVE_WAIT_TIME_INSANE := 3.5
#const MOVE_WAIT_TIME_MADNESS := 3.00
const MOVE_WAIT_TIME_DELUSIONAL := 2.0

const IDLE_WAIT_TIME_RANGE: float = 3.0
const MOVE_WAIT_TIME_RANGE: float = 3.0
