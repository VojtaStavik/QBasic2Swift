PRINT "Beginnig"
GOTO Line
PRINT "Skipped"
Line:
PRINT "End"
~~~~~~~~~~~~~~~~~~~~
_ = {

    // main loop:
    var mainNextLabel__internal = ""
    var mainLoopDone__internal = false
    repeat {
        switch mainNextLabel__internal {
        case "":
            print("\("Beginnig")", terminator: "\n")
            mainNextLabel__internal = "Line"
            continue
            print("\("Skipped")", terminator: "\n")
            fallthrough
        case "Line":
            print("\("End")", terminator: "\n")
            fallthrough
        default:
            mainLoopDone__internal = true
        }
    } while mainLoopDone__internal == false

}()
