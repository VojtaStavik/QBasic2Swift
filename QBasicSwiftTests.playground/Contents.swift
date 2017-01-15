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
func &= ( left: inout Int, right: Double) { left = Int(right) }
func &= ( left: inout Double, right: Int) { left = Double(right) }
func &= ( left: inout String, right: String) { left = right }
// STDLIB Functions
func LCASE__string(text__string: String) -> String {
    return text__string.lowercased()
}
func LOG(num__double: Double) -> Double {
    return log(num__double)
}
func RND() -> Double {
    return Double(arc4random()) / 0xFFFFFFFF
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
func UCASE__string(text__string: String) -> String {
    return text__string.uppercased()
}
_ = {
    for x__int in stride(from: 1, to: 100, by: 1) {
        if x__int%15==0 {
            print("\("FizzBuzz")", terminator: "\n")
        } else {
            if x__int%5==0 {
                print("\("Buzz")", terminator: "\n")
            } else {
                if x__int%3==0 {
                    print("\("Fizz")", terminator: "\n")
                } else {
                    print("\(x__int)", terminator: "\n")
                }
            }
        }
    }
}()
