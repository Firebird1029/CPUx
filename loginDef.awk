#!/usr/bin/awk -f
# LoginDef

BEGIN {
   str = $0
   print "String before replacement = " str
   
   gsub("World", "Jerry", str)
   print "String after replacement = " str
}

END {
	
}