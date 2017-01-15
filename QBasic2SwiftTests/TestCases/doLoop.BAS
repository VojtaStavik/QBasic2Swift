DIM x AS INTEGER
DIM y AS INTEGER

CLS

x = 1
y = 1
DO
   PRINT "Post condition UNTIL"
   x = x + 1
LOOP UNTIL x > 10 AND y = 1

x = 1
DO
    PRINT "Post condition WHILE"
    x = x + 1
LOOP WHILE x < 11 AND y = 1

x = 1
DO UNTIL x > 10 OR y < 1
    PRINT "Pre condition UNTIL"
    x = x + 1
LOOP

x = 1
DO WHILE x < 11 OR y < 1
    PRINT "Pre condition WHILE"
    x = x + 1
LOOP
~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var y: Int = 0
    var x: Int = 0
    // CLS is not implemented yet
    x &= 1
    y &= 1
    repeat {
        print("\("Post condition UNTIL")", terminator: "\n")
        x &= x+1
    } while (((x>10&&y==1) == false))
    x &= 1
    repeat {
        print("\("Post condition WHILE")", terminator: "\n")
        x &= x+1
    } while (x<11&&y==1)
    x &= 1
    while (((x>10||y<1) == false)) {
        print("\("Pre condition UNTIL")", terminator: "\n")
        x &= x+1
    }
    x &= 1
    while (x<11||y<1) {
        print("\("Pre condition WHILE")", terminator: "\n")
        x &= x+1
    }
}()
