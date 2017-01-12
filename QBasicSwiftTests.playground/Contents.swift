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


// Declarations:


var nextLabel__internal = ""

// Main loop:
var done__internal = false
repeat {
    switch nextLabel__internal {
    case "":
        for x in stride(from: 1, to: 100, by: 1) {
            if x%15==0 {
                print("\("FizzBuzz")", separator: "", terminator: "\n")
            } else {
                if x%5==0 {
                    print("\("Buzz")", separator: "", terminator: "\n")
                } else {
                    if x%3==0 {
                        print("\("Fizz")", separator: "", terminator: "\n")
                    } else {
                        print("\(x)", separator: "", terminator: "\n")
                    }
                }
            }
        }
        fallthrough
        
    default:
        // End of the program
        done__internal = true
        break
    }
} while done__internal == false

