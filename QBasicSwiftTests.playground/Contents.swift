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


// Subs
func DoubleNum(Number: Int) -> Void {
    print("\("The Number Doubled: ")"+"\(Number*2)", terminator: "\n")
}

_ = {
    // Main loop vars declaration
    var Num1: Int = 0
    // CLS is not implemented yet
    print("Enter An Integer To Double: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        Num1 = Int(input) ?? 0
    }()
    
    DoubleNum(Number: Num1)
}()
