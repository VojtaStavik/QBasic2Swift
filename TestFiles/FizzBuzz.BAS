FOR x = 1 TO 100
    IF x MOD 15 = 0 THEN
        PRINT "FizzBuzz"
    ELSEIF x MOD 5 = 0 THEN
        PRINT "Buzz"
    ELSEIF x MOD 3 = 0 THEN
        PRINT "Fizz"
    ELSE
        PRINT x
    END IF
NEXT x
