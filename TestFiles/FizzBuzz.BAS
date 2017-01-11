FOR x = 1 TO 100
    IF x MOD 15 = 0 THEN
        PRINT "FizzBuzz"
    ELSE
        IF x MOD 5 = 0 THEN
            PRINT "Buzz"
        ELSE
            IF x MOD 3 = 0 THEN
                PRINT "Fizz"
            ELSE
                PRINT x
            END IF
        END IF
    END IF
NEXT x
