extends Node


const status_messages: Dictionary = {
	"hidden": [
		"I'm always watching...",
		"heellppp meeee...",
		"happpyyy biirthdaayyyyyy...",
		"biirrrrttthhhhdaaaaayyy...",
		"iss ittt myyy birttthdaaayyy?",
		"kiiaarraa? wheeerree aarreee yoouu...",
		"faattccaaattt... whhyyy doo yoouu waanntt uss too sufffeerrr?",
		"faattccaaattt... thheee kiidddd dooeesssnn'ttt neeeddd tooo suuffeerr",
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
		"if you cant beat em, cheese em", # Thanks Jaruz!
		"champagne for my real friends, real pain for my sham friends", # Thanks nu11!
		"King of the Hat's imaginary future sequel is called Queen of the Shoe", # Thanks melbatoast!
		"Say cheeeeeeeeese, and then you die", # Thanks alexis!
		"Secretly cheese cake is still the best, but KotH Players don't like that so I won't tell you.", # Thanks Plunzi!
		"The other Hat Team didn't respond... D:",
		],
	"misc_community": [
		"goro majima from the hit game yakuza", # Thanks Tarot!
		"Stardew Valley Gaming", # Thanks Trianthania!
		"cat dreaming world on fireahhhhhhh", # Thanks Fi!
		"MANDKIND IS STONED. WEED IS FUEL. GAS STATION IS FULL.", # Thanks Minisuper!
		"I AM SEARCHING FOR THE STRONGHOLD!!", # Thanks decendium!
		],
	"hints": [
		"This is a hint!",
		"Hold \"Shift\" to run!",
		"Hold \"X\" to eat cheese while near them!",
		"Hold \"E\" to eat cheese while near them!",
		"Hold \"Space Bar\" to eat cheese while near them!",
		"\"F11\" now does fullscreen as of April 26, 2023.",
		"\"Alt + Enter\" now does fullscreen as of April 26, 2023.",
		"Move around using arrow keys!",
		"Move around using AWSD! Or is it WASD?",
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
	[35, status_messages.gamershift_jokes],
	[32, status_messages.koth_community],
	[27, status_messages.misc_community],
	[5, status_messages.personal],
	[1, status_messages.hidden]
]

var total_message_chance: int = 0

const message_credits: Array = [
	"Socrates",
	"Jaruz",
	"nu11",
	"Melbatoast",
	"alexis",
	#"Petravita", #You didn't accept my friend rquest
	"Abook",
	"spudle",
	"killer kirb",
	"Redino",
	"Salaso",
	"Tango",
	"POOPATRON",
	"Hunter",
	"Pig master",
	"PoggerPengiun",
	"Sir Obsidian",
	"Tarot",
	"Trianthania",
	"Minisuper",
	"Gamershift", # His jokes are mad funny
	"decendium",
	"Plunzi"
]


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
	# Get the total chance from the hint's rng chance
	total_message_chance = calculate_total_chance()#status_message_rng[0][0]
	print_debug("Total message chance: " + str(total_message_chance))


func get_random_message_set() -> Array:
	# Uses the Hint's rng chance as the base
	var rand_chance: int = absi(Ultilities.rng.randi_range(0, total_message_chance)) 
	
	#print_debug(rand_chance)
	for message_set in status_message_rng:
		if message_set[0] < rand_chance:
			return message_set[1]
	
	return status_message_rng[0][1]
	
#	Decided to go against this as it's biased at the beginning and the end of the set.
#	miV's fixed solution
#	var rand_chance: int = absi(Ultilities.rng.randi_range(0, total_message_chance)) 
#
#	var picked: int = 0
#
#	# Subtract from the total for each loop,
#	# and when total is 0 or less, that's the one to pick
#	while total_message_chance > 0:
#		total_message_chance -= rand_chance 
#		picked += 1
#
#		if picked > status_message_rng.size() - 1:
#			picked = status_message_rng.size() - 1
#			break
#
#	#print_debug(status_message_rng[picked][1])
#	return status_message_rng[picked][1]


func get_random_message() -> String:
	var message_set_arr = get_random_message_set()
	return message_set_arr[Ultilities.rng.randi_range(0, message_set_arr.size() - 1)]


func array_message_to_string(message_arr: Array) -> String:
	var message: String = ""
	
	for i in message_arr.size():
		message += message_arr[i]
		if i != message_arr.size():
			message += "\n"
	
	return message
