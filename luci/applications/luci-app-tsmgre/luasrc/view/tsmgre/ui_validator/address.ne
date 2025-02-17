
#
# Lets describe the rules for IP address, e.g: 192.168.0.1 or URL, e.g: my.network.com
#

MAIN 			-> URL
					
URL				-> DOMAIN ("." DOMAIN):*
					
DOMAIN			-> (LETTER|NUMBER|SYMBOL):+
LETTER			-> [a-zA-Z]
NUMBER			-> [0-9]
SYMBOL			-> [_\-%/:?&=]