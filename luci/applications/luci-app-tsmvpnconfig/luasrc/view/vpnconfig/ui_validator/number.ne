
#
# Lets describe the rules for numbers
#

MAIN 			-> NUMBER

NUMBER			->  [0-9]:+
					| [0-9]:+ "." [0-9]:+
					| [0-9]:+ "," [0-9]:+