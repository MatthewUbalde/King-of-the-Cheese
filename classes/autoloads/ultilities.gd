extends Node

const INVALID_TEMP = "INVALID"

const MONTH_LONG_FORM: Array[String] = [
	INVALID_TEMP, # Unexpected value
	"JANUARY",
	"FEBRUARY",
	"MARCH",
	"APRIL",
	"MAY",
	"JUNE",
	"JULY",
	"AUGUST",
	"SEPTEMBER",
	"OCTOBER",
	"NOVEMBER",
	"DECEMBER"
]

const MONTH_SHORT_FORM: Array[String] = [
	INVALID_TEMP, # Unexpected value
	"JAN",
	"FEB",
	"MAR",
	"APRIL",
	"MAY",
	"JUNE",
	"JULY",
	"AUG",
	"SEPT",
	"OCT",
	"NOV",
	"DEC"
]

func get_month_string(month_num: int, short_form: bool = false) -> String:
	if month_num < 1 && month_num > 12: 
		return INVALID_TEMP # Invalid
	
	if short_form:
		return MONTH_SHORT_FORM[month_num]
	
	return MONTH_LONG_FORM[month_num]


# Trusting that it has the same keys
func get_date_string_from_dict(date: Dictionary) -> String:
	var date_string: String = ""
	if date.month:
		date_string += get_month_string(date.month) + " "
	if date.day:
		date_string += str(date.day) + " "
	if date.year:
		date_string += ", " + str(date.year)
	
	return date_string
