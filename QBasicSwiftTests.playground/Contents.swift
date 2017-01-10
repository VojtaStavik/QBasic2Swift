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


var nextLabel__internal = ""
// Main loop:
var done__internal = false
repeat {
    switch nextLabel__internal {
    case "":
        // CLS is not implemented yet
        print("\("QB")"+"\t"+"\("Tutorial")"+"\t"+"\("3")", separator: "", terminator: "\n")
        print("\("QB ")"+"\("Tutorial ")"+"\("3")", separator: "", terminator: "\n")
        print("\("Calcualtion")"+"\(4+5)", separator: "", terminator: "\n")
        print("\("1")", separator: "", terminator: "")
        print("\("2")", separator: "", terminator: "")
        print("", separator: "", terminator: "\n")
        print("\("next line")", separator: "", terminator: "\n")
        fallthrough
        
    default:
        // End of the program
        done__internal = true
        break
    }
} while done__internal == false


