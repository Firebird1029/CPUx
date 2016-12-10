#!/usr/bin/awk -f
# LoginDef

BEGIN {
	gsub(/PASS_MIN_DAYS\t[0-9]+/, "PASS_MIN_DAYS	10")
	print str
}

END {
	
}