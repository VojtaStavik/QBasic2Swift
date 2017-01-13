//: Playground - noun: a place where people can play

import Foundation


// Because QBasic is not that strict about types, we need these helper functions
// to make Swift work the same way.
func + (l: Double, r: Int) -> Double { return l + Double(r) }
func + (l: Int, r: Double) -> Double { return r + l }
func - (l: Double, r: Int) -> Double { return l - Double(r) }
func - (l: Int, r: Double) -> Double { return Double(l) - r }
func * (l: Double, r: Int) -> Double { return l * Double(r) }
func * (l: Int, r: Double) -> Double { return r * l }
func / (l: Double, r: Int) -> Double { return l / Double(r) }
func / (l: Int, r: Double) -> Double { return Double(l) / r }
func > (l: Double, r: Int) -> Bool { return l > Double(r) }
func > (l: Int, r: Double) -> Bool { return Double(l) > r }
func < (l: Double, r: Int) -> Bool { return l < Double(r) }
func < (l: Int, r: Double) -> Bool { return Double(l) < r }
func == (l: Double, r: Int) -> Bool { return l == Double(r) }
func == (l: Int, r: Double) -> Bool { return Double(l) == r }
func != (l: Double, r: Int) -> Bool { return l != Double(r) }
func != (l: Int, r: Double) -> Bool { return Double(l) != r }

// STDLIB Functions
func LOG(num__double: Double) -> Double {
    
    return log(num__double)
}

func ABS(absInternal: Int) -> Int {
    
    if absInternal>=0 {
        return absInternal
        
    } else {
        return -absInternal
        
    }
}

func STR__string(num__double: Double) -> String {
    
    return String(num__double)
}

func LCASE__string(text__string: String) -> String {
    
    return text__string.lowercased()
}


// User functions
func AnotherSub(greeting__string: String) -> Void {
    // Local vars declaration
    var i__int: Int = 0
    
    // AnotherSub loop:
    var AnotherSubNextLabel__internal = ""
    var AnotherSubLoopDone__internal = false
    repeat {
        switch AnotherSubNextLabel__internal {
        case "":
            print("\("This Is AnotherSub Running")", terminator: "\n")
            print("\("I Am Going To Do A Calculation")", terminator: "\n")
            print("\("25 + 5 * 4 =")"+"\(25+5*4)", terminator: "\n")
            print("\("The greeting is: ")"+"\(greeting__string)", terminator: "\n")
            i__int = 0
            fallthrough
        case "counter":
            if i__int<10 {
                print("\(i__int)", terminator: "\n")
                i__int = i__int+1
                AnotherSubNextLabel__internal = "counter"
                continue
            } else {
                print("\("We're done here: ")"+"\(i__int)", terminator: "\n")
            }
            fallthrough
        default:
            AnotherSubLoopDone__internal = true
        }
    } while AnotherSubLoopDone__internal == false
}

func MySub() -> Void {
    
    print("\("Yes, I Am Here")", terminator: "\n")
}

_ = {
    // Main loop vars declaration
    var i__int: Int = 0
    
    // CLS is not implemented yet
    print("\("Sub, Are You Here?")", terminator: "\n")
    MySub()
    print("\("Let's Run Another Sub")", terminator: "\n")
    AnotherSub(greeting__string: ";=)")
    
}()

