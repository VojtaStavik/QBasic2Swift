' This is a collection of basic functions provided by QBasic

FUNCTION ABS AS INTEGER (absInternal AS INTEGER)
    IF absInternal >= 0 THEN
        ABS = absInternal
    ELSE
        ABS = -absInternal
    END IF
END FUNCTION

FUNCTION LCASE$ (text$)
    //SWIFT return text__string.lowercased()
END FUNCTION

FUNCTION LOG AS DOUBLE (num#)
    //SWIFT return log(num__double)
END FUNCTION
