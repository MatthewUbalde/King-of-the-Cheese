extends Node


const status_messages: Dictionary = {
	"hidden": [
		"I'm always watching...",
		"happpyyy biirthdaayyyyyy...",
		"biirrrrttthhhhdaaaaayyy...",
		"iss ittt myyy birttthdaaayyy?",
		"kiiaarraa? wheeerree aarreee yoouu...",
		"wheereee aaammm I?...",
		"sooo maannyyyy cheeesseeee...",
		"i waaanttt tooo gooo hoomeeeeee...",
		"eeverrryythiinngg wwasss paaiinnnffuulll...",
		"eeverrryythiinngg iss... peaceful.",
		],
	"personal": [ # I made these ha.
		"Onward and upward!",
		"\"Hold on a minute, we're missing something...\"",
		"Thank you Hat Games for making the game! Good job Hat Team!",
		"Imagine writing a story about your escapism... Can't be me!",
		"\"No little faith is meaningless, but without action is.\" - C.",
		"Mustard mustard mustard mustard mustard mustard mustard",
		"The game is pretty buggy, but I'm lazy to fix it!",
		"Oyasumi! Oyasumi! Close your eyes...",
		"mewo~",
		"nyan nyan nyan~!",
		"Let's ride into the sunset together...",
		"Big gun on his hip. Big gun on hiss hiippp...",
		"The dev is a fish and loves eating fish",
		"Hotdog",
		"Do an Kickflip!",
		"The birds are singing and the flowers are blooming...",
		"Pata pata pata pon!",
		"FEVER!!",
		"Booyah!",
		"Why did the bike fell over? Because it was two-tired. Hahahah...",
		"The Hat Team are cool people",
		],
	"gamershift_jokes": [ # These ones are fire, so I'm adding multiple ones LOL
		"WHAT DO YOU CALL A HAT THAT CAN CUT A TREE? A HAT-CHET", # Thanks Pig master's closest friend! (Gamershift)
		"SORRY, HAT PUNS ARE HARD. THEY'RE A REAL HEADSCRACTHER", # Thanks Pig master's closest friend! (Gamershift)
		"DO YOU KONW THE BOROUGH WITH THE BEST HAT STORES? IT'S MAN-HAT-TEN", # Thanks Pig master's closest friend! (Gamershift)
		"FEDORABLE. I DON'T EVEN HAVE A SETUP FOR THAT ONE", # Thanks Pig master's closest friend! (Gamershift)
		],
	"koth_community": [
		"mad hatter, joxy'd", # Thanks Abook!
		"i'd hat to say no", # Thanks spudle!
		"ok", # Thanks killer kirb!
		"I hat your IP hatdress", # Thanks Redino!
		"bozo", # Thanks Salaso!
		"Splosh", # Thanks Tango!
		"Don't step the rock-alikes or something I guess?", # Thanks POOPATRON (Not really a direct quote. Just a hint...)
		"Something (said in funny voice)", # Thanks Hunter!
		"This game is way ahat of its time", # Thanks Pig master!
		"ITs cheesing time", #Thanks PoggerPenguin!
		"Hat's on for cheese", #Thanks Sir Obisdian!
		"I heard there’s a hidden ending if you play for long enough", # Thanks Tr4shJ4ck!
		"Hat to throw out my cheese when it started growing mould", # Thanks R2D2Vader!
		"Ever since I ended my greek fast, yogurt is my new chicken nuggets", # Thanks Socrates!
		"The other Hat Team didn't respond... D:",
		],
	"misc_community": [
		"goro majima from the hit game yakuza", # Thanks Tarot!
		"Stardew Valley Gaming", # Thanks Trianthania!
		"cat dreaming world on fireahhhhhhh", # Thanks Fi!
		"MANDKIND IS STONED. WEED IS FUEL. GAS STATION IS FULL.", # Thanks Minisuper!
		],
	"hints": [
		"This is a hint!",
		"Hold \"Shift\" to run!",
		"Hold \"X\" to eat cheese while near them!",
		"Hold \"E\" to eat cheese while near them!",
		"Hold \"Space Bar\" to eat cheese while near them!",
		"Move around using arrow keys!",
		"Cheese adds on every day!",
		"You can zoom using \"Ctrl +/-\".",
		"Use your mouse wheel with \"Ctrl and Shift\" to zoom as well.",
		"\"Ctrl and Spacebar\" resets the zoom!",
		"Play King of the Hat!",
		"Screenshots are in \"AppData/Roaming/Godot/app_userdata/King of The Hat Cheese\"",
		]
}

const status_message_rng: Array = [
	[175, status_messages.hints],
	[50, status_messages.gamershift_jokes],
	[35, status_messages.koth_community],
	[35, status_messages.misc_community],
	[20, status_messages.personal],
	[1, status_messages.hidden]
]

var total_message_chance: int = 0

#const secret_messages: Array = [
#	"I'm always watching...",
#	"happpyyy biirthdaayyyyyy...",
#	"biirrrrttthhhhdaaaaayyy...",
#	"iss ittt myyy birttthdaaayyy?",
#	"kiiaarraa? wheeerree aarreee yoouu...",
#	]
#
#const personal_messages: Array = [
#	"Onward and upward!",
#	"\"Hold on a minute, we're missing something...\"",
#	"Thank you Hat Games for making the game! Good job Hat Team!",
#	"Imagine writing a story about your escapism... Can't be me!",
#	"\"No little faith is meaningless, but without action is.\" - C.",
#	"Mustard Seed",
#	"The game is pretty buggy, but I'm lazy to fix it!",
#	"Oyasumi! Oyasumi! Close your eyes...",
#	"mewo~",
#	"nyan nyan nyan~!"]
#
#const koth_community_messages: Array = [
#	"mad hatter, joxy'd", # Thanks Abook!
#	"i'd hat to say no", # Thanks spudle
#	"ok", # Thanks killer kirb!
#	"I hat your IP hatdress", # Thanks Redino
#	"bozo", # Thanks Salaso!
#	"Splosh", # Thanks Tango!
#	"Don't step the rock-alikes or something I guess?", # Thanks POOPATRON (Not really a direct quote. Just a hint...)
#	"Something (said in funny voice)", # Thanks Hunter!
#	"This game is way ahat of its time", # Thanks Pig master!
#	"ITs cheesing time", #Thanks PoggerPenguin
#	"Hat's on for cheese", #Thanks Sir Obisdian
#	]
#
#const misc_community_messages: Array = [
#	"goro majima from the hit game yakuza", # Thanks Tarot!
#	"Stardew Valley Gaming", # Thanks Trianthania!
#	"cat dreaming world on fireahhhhhhh", # Thanks Fi!
#	"MANDKIND IS STONED. WEED IS FUEL. GAS STATION IS FULL.", # Thanks Minisuper!
#	# These ones are fire, so I'm adding multiple ones LOL
#	"WHAT DO YOU CALL A HAT THAT CAN CUT A TREE? A HAT-CHET", # Thanks Pig master's closest friend! (Gamershift)
#	"SORRY, HAT PUNS ARE HARD. THEY'RE A REAL HEADSCRACTHER", # Thanks Pig master's closest friend! (Gamershift)
#	"DO YOU KONW THE BOROUGH WITH THE BEST HAT STORES? IT'S MAN-HAT-TEN", # Thanks Pig master's closest friend! (Gamershift)
#	"FEDORABLE. I DON'T EVEN HAVE A SETUP FOR THAT ONE", # Thanks Pig master's closest friend! (Gamershift)
#	]
#
#const hint_messages: Array = [
#	"This is status message!",
#	"Hold 'Shift' to run!",
#	"Hold 'X' to eat cheese while near them!",
#	"Move around using arrow keys!",
#	"Cheese adds on every day! Make sure you come back every now and then!",
#	"Made by Fish with Headphones",
#	"Made in Godot!",
#	"You can zoom using Ctrl +/-. Even Ctrl and mouse scroll works!",
#	"Ctrl and Spacebar resets the zoom!",
#	"Play King of the Hat!",
#	]
#
#const message_credits: Array = [
#	"Abook",
#	"spudle",
#	"killer kirb",
#	"Redino",
#	"Salaso",
#	"Tango",
#	"POOPATRON",
#	"Hunter",
#	"Pig master",
#	"PoggerPengiun",
#	"Sir Obsidian",
#	"Tarot",
#	"Trianthania",
#	"Minisuper",
#	"Pig master's closest friend, Gamershift", # His jokes are mad funny
#]


# Thanks miV for the help on this one!
func calculate_total_chance() -> int:
	var total_chance: int = 0
	
	for array in status_message_rng:
		total_chance += array[0]
	
	return total_chance


func _ready():
	# Make the status messages read only
	status_messages.make_read_only()
	
	# Get the total chance to be used later in get_random_message_set()
	total_message_chance = calculate_total_chance()
	print_debug("Total message chance: " + str(total_message_chance))
	
#	Used for testing
#	print(get_random_message())


## TODO: Potiential bug, runs the method twice somehow
#func get_random_message_set() -> Array:
#	var select_set_message: int = randi_range(1, status_messages.size()) 
#	#print_debug("what")
#	match select_set_message:
#		1:
#			return status_messages.hidden
#		2:
#			return status_messages.personal
#		3:
#			return status_messages.koth_community
#		4:
#			return status_messages.misc_community
#		5:
#			return status_messages.hints
#		_:
#			return []


# Thanks miV for the help on this one!
func get_random_message_set() -> Array:
	var rand_chance: int = randi_range(0, total_message_chance)
	var picked: int = 0
	
	# Subtract from the total for each loop,
	# and when total is 0 or less, that's the one to pick
	while total_message_chance > 0:
		total_message_chance -= rand_chance 
		picked += 1
		
		if picked > status_message_rng.size() - 1:
			picked = status_message_rng.size() - 1
			break
	
	return status_message_rng[picked][1]


func get_random_message() -> String:
	var message_set_arr = get_random_message_set()
	return message_set_arr[randi_range(0, message_set_arr.size() - 1)]


func array_message_to_string(message_arr: Array) -> String:
	var message: String = ""
	
	for i in message_arr.size():
		message += message_arr[i]
		if i != message_arr.size():
			message += "\n"
	
	return message
