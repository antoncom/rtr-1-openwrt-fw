
#
# Lets describe the rules for netmask like 255.255.255.0 or 24
#

MAIN 			-> NETMASK

NETMASK			-> net_mask | From_0_to_32

net_mask		-> From_0_to_255 "." From_0_to_255 "." From_0_to_255 "." From_0_to_255

From_0_to_255 	-> 	[0-9] 					# 0..9
					| [1-9] [0-9] 			# 10..99
					| "1" [0-9] [0-9] 		# 100.. 199
					| "2" [0-5] [0-5]		# 200..255


From_0_to_32	->  [0-9]			# 0..9
					| [0-2] [0-9]	# 01..29
					| "3" [0-2]		# 30..32