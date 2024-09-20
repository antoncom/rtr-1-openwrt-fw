
#
# Lets describe the rules for any name
#

MAIN 			-> NAME

NAME 			-> (LETTER|NUMBER|SYMBOL):+
LETTER			-> [a-zA-Z]
NUMBER			-> [0-9]
SYMBOL			-> [_]