PRINT "Sound check ... 1, 2, 3 ..."
PRINT 5 + 5
PRINT "5", "+", "5", "="; 5 + 5
PRINT "QB", "Tutorial", "3"
PRINT "QB "; "Tutorial "; "3"
PRINT "Calculation"; 4 + 5

PRINT "5 + 10 ="; 5 + 10
PRINT "6 - 5 ="; 6 - 5
PRINT "7 * 6 ="; 7 * 6
PRINT "10 / 2 ="; 10 / 2
PRINT "5 * 2 + 10 ="; 5 * 2 + 10
PRINT "(5 * 2) + 10 ="; (5 * 2) + 10
PRINT "5 * (2 + 10) ="; 5 * (2 + 10)

PRINT ,"Hey"
~~~~~~~~~~~~~~~~~~~~
_ = {

    print("\("Sound check ... 1, 2, 3 ...")", terminator: "\n")
    print("\(5+5)", terminator: "\n")
    print("\("5")"+"\t"+"\("+")"+"\t"+"\("5")"+"\t"+"\("=")"+"\(5+5)", terminator: "\n")
    print("\("QB")"+"\t"+"\("Tutorial")"+"\t"+"\("3")", terminator: "\n")
    print("\("QB ")"+"\("Tutorial ")"+"\("3")", terminator: "\n")
    print("\("Calculation")"+"\(4+5)", terminator: "\n")
    print("\("5 + 10 =")"+"\(5+10)", terminator: "\n")
    print("\("6 - 5 =")"+"\(6-5)", terminator: "\n")
    print("\("7 * 6 =")"+"\(7*6)", terminator: "\n")
    print("\("10 / 2 =")"+"\(10/2)", terminator: "\n")
    print("\("5 * 2 + 10 =")"+"\(5*2+10)", terminator: "\n")
    print("\("(5 * 2) + 10 =")"+"\((5*2)+10)", terminator: "\n")
    print("\("5 * (2 + 10) =")"+"\(5*(2+10))", terminator: "\n")
    print("\t"+"\("Hey")", terminator: "\n")

}()
