DECLARE SUB PrintName (TheName AS STRING)
DIM FirstName AS STRING

CLS

INPUT "Enter Name: ", FirstName

PrintName (FirstName)

SUB PrintName (TheName AS STRING)
PRINT "The Name Printed Is: "; TheName
END SUB

