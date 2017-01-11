#!/usr/bin/env xcrun swift

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
var Num1__int: Int = 0
var Num2__int: Int = 0

var nextLabel__internal = ""

// Main loop:
var done__internal = false
repeat {
	switch nextLabel__internal {
	case "":
		// CLS is not implemented yet
		print("Enter First Integer: ", terminator: "")
		let _ = {
			let input = readLine() ?? ""
			Num1__int = Int(input) ?? 0
		}()

		print("Enter Second Integer: ", separator: "", terminator: "")
		let _ = {
			let input = readLine() ?? ""
			Num2__int = Int(input) ?? 0
		}()

		if Num1__int>Num2__int {
			print("\(Num1__int)"+"\("Is Greater Than")"+"\(Num2__int)", separator: "", terminator: "\n")
		} else {
			if Num2__int>Num1__int {
				print("\(Num2__int)"+"\("Is Greater Than")"+"\(Num1__int)", separator: "", terminator: "\n")
			} else {
				print("\("The Numbers Are The Same")", separator: "", terminator: "\n")
			}
		}
		fallthrough

	default:
		// End of the program
		done__internal = true
		break
	}
} while done__internal == false



