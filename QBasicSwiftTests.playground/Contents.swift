//: Playground - noun: a place where people can play

import Foundation

// Because QBasic is not that strict about types, we need these helper functions
// to make it work the same way.
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


// Functions
func LOG(num__double: Double) -> Double {
    return log(num__double)
}

func Power__single(y: Double, x: Double) -> Double {
    return x+y
    
}

func ABS(absInternal: Int) -> Int {
    if absInternal>=0 {
        return absInternal
    } else {
        return -absInternal
    }
}

func LCASE__string(text__string: String) -> String {
    return text__string.lowercased()
}

_ = {
    // Main loop vars declaration
    var Num2: Double = 0
    var Num1: Double = 0
    var Answer: Double = 0
    // CLS is not implemented yet
    print("Enter First Number: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        Num1 = Double(input) ?? 0
    }()
    
    print("Enter Second Number: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        Num2 = Double(input) ?? 0
    }()
    
    Answer = Power__single(y: Num1, x: Num2)
    print("\("The Answer Is:")"+"\(Answer)", terminator: "\n")
}()

