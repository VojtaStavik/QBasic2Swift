DECLARE SUB MySub (param1$)

PRINT "Yes, I Am Here"

DECLARE SUB AnotherSub ()
PRINT "Yes, I Am Here2"

IF 5 = 5 THEN PRINT "Hello"

r% = 123

IF r% = 123 THEN
    PRINT " World"
    PRINT "Hello Jupiter"
    PRINT "Good ByeFor Now"
END IF


SUB MySub (param1$)
    title$ = "Hello"
    PRINT "MySub declaration", param1$, title$
END SUB
