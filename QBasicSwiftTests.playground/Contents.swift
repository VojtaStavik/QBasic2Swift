//: Playground - noun: a place where people can play

import Foundation

// Helper functions
func + (l: Double, r: Int) -> Double { return l + Double(r) }
func + (l: Int, r: Double) -> Double { return r + l }
func - (l: Double, r: Int) -> Double { return l - Double(r) }
func - (l: Int, r: Double) -> Double { return Double(l) - r }
func * (l: Double, r: Int) -> Double { return l * Double(r) }
func * (l: Int, r: Double) -> Double { return r * l }
func / (l: Double, r: Int) -> Double { return l / Double(r) }
func / (l: Int, r: Double) -> Double { return Double(l) / r }


// Declarations:


var nextLabel = ""
// Main loop:
var done = false
repeat {
    switch nextLabel {
    case "":
        for x in stride(from: 1, to: 100, by: 1) {
            if x%15==0 {
                print("\("FizzBuzz")")
            } else {
                if x%5==0 {
                    print("\("Buzz")")
                } else {
                    if x%3==0 {
                        print("\("Fizz")")
                    } else {
                        print("\(x)")
                    }
                }
            }
        }
        fallthrough
        
    default:
        // End of the program
        done = true
        break
    }
} while done == false

