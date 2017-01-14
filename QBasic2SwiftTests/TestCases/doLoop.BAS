DIM x AS INTEGER

CLS

x = 1
DO
   PRINT "Post condition UNTIL"
   x = x + 1
LOOP UNTIL x > 10

x = 1
DO
    PRINT "Post condition WHILE"
    x = x + 1
LOOP WHILE x < 11

x = 1
DO UNTIL x > 10
    PRINT "Pre condition UNTIL"
    x = x + 1
LOOP

x = 1
DO WHILE x < 11
    PRINT "Pre condition WHILE"
    x = x + 1
LOOP
~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var x: Int = 0

    // CLS is not implemented yet
    x = 1
    repeat {
        print("\("Post condition UNTIL")", terminator: "\n")
        x = x+1
    } while (((x>10) == false))
    x = 1
    repeat {
        print("\("Post condition WHILE")", terminator: "\n")
        x = x+1
    } while (x<11)
    x = 1
    while (((x>10) == false)) {
        print("\("Pre condition UNTIL")", terminator: "\n")
        x = x+1
    }
    x = 1
    while (x<11) {
        print("\("Pre condition WHILE")", terminator: "\n")
        x = x+1
    }

}()
