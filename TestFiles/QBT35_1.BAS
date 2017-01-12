DECLARE SUB MySub ()
DECLARE SUB AnotherSub (greeting$)
CLS
PRINT "Sub, Are You Here?"
MySub
PRINT "Let's Run Another Sub"
AnotherSub ";=)"

SUB AnotherSub (greeting$)
    PRINT "This Is AnotherSub Running"
    PRINT "I Am Going To Do A Calculation"
    PRINT "25 + 5 * 4 ="; 25 + 5 * 4
    PRINT "The greeting is: "; greeting$

    i% = 0
    counter:
    IF i% < 10 THEN
        PRINT i%
        i% = i% + 1
        GOTO counter
    ELSE
        PRINT "We're done here: "; i%
    END IF
END SUB

SUB MySub
    PRINT "Yes, I Am Here"
END SUB

