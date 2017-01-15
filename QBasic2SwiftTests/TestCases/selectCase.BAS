DIM KeyPressed AS STRING
KeyPressed = " "

SELECT CASE KeyPressed
  CASE "A"
     PRINT "A Was Entered"
  CASE "B"
     PRINT "B Was Entered"
  CASE "C"
     PRINT "C Was Entered"
  CASE "D"
     PRINT "D Was Entered"
  CASE ELSE
     PRINT "Some Other Key Was Entered"
END SELECT

~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var KeyPressed: String = ""
    KeyPressed &= " "
    switch KeyPressed {
    case "A":
        print("\("A Was Entered")", terminator: "\n")
    case "B":
        print("\("B Was Entered")", terminator: "\n")
    case "C":
        print("\("C Was Entered")", terminator: "\n")
    case "D":
        print("\("D Was Entered")", terminator: "\n")
    default:
        print("\("Some Other Key Was Entered")", terminator: "\n")
    }
}()
