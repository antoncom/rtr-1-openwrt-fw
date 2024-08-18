# Lets describe the rules for phone number, e.g.: +79030507255

MAIN 			-> PREFIX CODE OPERATOR NUMBER

PREFIX 			->  "+"

CODE			->  [1-9]
					| [1-9] [0-9]									# 1..99 - this is a country code

OPERATOR		->  [1-9] [0-9] [0-9] 								# 100..999 - this is an cell provider code

NUMBER 			->  [0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9] 		# 0000000..9999999 - this is the phone number itself