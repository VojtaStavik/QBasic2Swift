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
// We use &= as assignment operator so we can assign Int to Double etc.
func &= ( left: inout Int, right: Double) { left = Int(right) }
func &= ( left: inout Int, right: Int) { left = right }
func &= ( left: inout Double, right: Int) { left = Double(right) }
func &= ( left: inout Double, right: Double) { left = right }
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
    // Main loop vars declaration
    var Game: String = ""
    var Guess: Int = 0
    var Cnt: Int = 0
    var Answer: Int = 0
    repeat {
        // CLS is not implemented yet
        repeat {
            print("\("Guess My Number Game:")", terminator: "\n")
            print("", terminator: "\n")
            print("\("A) 10")", terminator: "\n")
            print("\("B) 100")", terminator: "\n")
            print("\("C) 1000")", terminator: "\n")
            print("Please Enter A Game: ", terminator: "")
            Game = String(readLine() ?? "")
            Game &= UCASE__string(text__string: Game)
        } while (((Game=="A"||Game=="B"||Game=="C") == false))
        // CLS is not implemented yet
        switch Game {
        case "A":
            Answer &= (RND()*9)+1
            print("\("Game 1 - 10")", terminator: "\n")
        case "B":
            Answer &= (RND()*99)+1
            print("\("Game 1 - 100")", terminator: "\n")
        case "C":
            Answer &= (RND()*999)+1
            print("\("Game 1 - 1000")", terminator: "\n")
        default:
            break
        }
        Guess &= 0
        Cnt &= 0
        repeat {
            print("Please Enter A Guess: ", terminator: "")
            Guess = Int(readLine() ?? "") ?? 0
            Cnt &= Cnt+1
            if Guess<Answer {
                print("\("Too Low!")", terminator: "\n")
            } else {
                if Guess>Answer {
                    print("\("Too High!")", terminator: "\n")
                } else {
                    print("\("You Guessed My Number In")"+"\(Cnt)"+"\("Tries")", terminator: "\n")
                }
            }
        } while (((Guess==Answer) == false))
        print("", terminator: "\n")
        repeat {
            print("Play Again Y/N ", terminator: "")
            Game = String(readLine() ?? "")
            Game &= UCASE__string(text__string: Game)
        } while (((Game=="Y"||Game=="N") == false))
    } while (((Game=="N") == false))
}()
