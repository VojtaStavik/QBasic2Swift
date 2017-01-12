//
//  CodeGenerator.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 06/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

protocol Swiftable {
    func toSwift(_ prefix: String) -> String
}

struct CodeGenerator: Swiftable {

    let blocks: [Block]

    static let nextLabelVariable = "nextLabel__internal"
    static let doneVariable = "done__internal"
    
    
    static let programHeaders: String =
        "#!/usr/bin/env xcrun swift\n" +
        "\n" +
        "import Foundation\n" +
        "\n" +
        "// Because QBasic is not that strict about types, we need these helper functions\n" +
        "// to make it work the same way.\n" +
            "func + (l: Double, r: Int) -> Double { return l + Double(r) }\n" +
            "func + (l: Int, r: Double) -> Double { return r + l }\n" +
            "func - (l: Double, r: Int) -> Double { return l - Double(r) }\n" +
            "func - (l: Int, r: Double) -> Double { return Double(l) - r }\n" +
            "func * (l: Double, r: Int) -> Double { return l * Double(r) }\n" +
            "func * (l: Int, r: Double) -> Double { return r * l }\n" +
            "func / (l: Double, r: Int) -> Double { return l / Double(r) }\n" +
            "func / (l: Int, r: Double) -> Double { return Double(l) / r }\n" +
            "\n" +
            "func > (l: Double, r: Int) -> Bool { return l > Double(r) }\n" +
            "func > (l: Int, r: Double) -> Bool { return Double(l) > r }\n" +
            "func < (l: Double, r: Int) -> Bool { return l < Double(r) }\n" +
            "func < (l: Int, r: Double) -> Bool { return Double(l) < r }\n" +
            "func == (l: Double, r: Int) -> Bool { return l == Double(r) }\n" +
            "func == (l: Int, r: Double) -> Bool { return Double(l) == r }\n" +
            "func != (l: Double, r: Int) -> Bool { return l != Double(r) }\n" +
            "func != (l: Int, r: Double) -> Bool { return Double(l) != r }\n" +
            "\n\n"
    
    static let mainLoopStart: String =
        "// Main loop:\n" +
        "var \(CodeGenerator.doneVariable) = false\n" +
        "repeat {\n" +
        "\tswitch \(CodeGenerator.nextLabelVariable) {\n"
        
    static let mainLoopEnd: String =
        "\tdefault:\n" +
        "\t\t// End of the program\n" +
        "\t\t\(CodeGenerator.doneVariable) = true\n" +
        "\t\tbreak\n" +
        "\t}\n"
    
    func toSwift(_ prefix: String = "") -> String {
        
        var result = CodeGenerator.programHeaders
        
        let variablesNeededDeclaration = Program.globalVarsPool.map { (name, type) -> Variable in
            return Variable(name: name, type: type, userDefined: nil)
        }

        result += "// Declarations:\n" +
                    variablesNeededDeclaration.map{ $0.declaration() }.joined(separator: "\n") +
                    "\n\n"
        
        let mainLabelName = blocks.first!.label.toSwift("")
        
        result += "var \(CodeGenerator.nextLabelVariable) = \(mainLabelName)\n\n"
        result += CodeGenerator.mainLoopStart
        
        blocks.forEach {
            result += $0.toSwift("\t")
        }
        
        result += CodeGenerator.mainLoopEnd
        
        result += "} while \(CodeGenerator.doneVariable) == false\n" +
                  "\n\n"


        return result
    }
}

extension Block: Swiftable {
    
    func toSwift(_ prefix: String = "") -> String {
        var result = prefix + "case \(label.toSwift("")):\n"
        
        result += statements.map { $0.toSwift(prefix + "\t") }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n") + "\n"
        
        if case .goto(_)? = statements.last {
            // Do nothing, just the new line
            result += "\n"
        } else {
            result += prefix + "\tfallthrough\n\n"
        }
        
        return result
    }
}

extension Statement: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .print(let e, let term):
            var printExpressions = e.reduce("", { (result, element: (op: Operator?, exp: Expression)) -> String in
                var toAppend = "\(element.op?.toSwift() ?? "")" + "\"\\(\(element.exp.toSwift()))\""
                if result.hasSuffix("\"") == false && toAppend.hasPrefix("+") {
                    // Remove the "+" sign if needed
                   toAppend = toAppend.substring(from: toAppend.index(after: toAppend.startIndex))
                }
                return result + toAppend
            })
            
            if printExpressions.isEmpty {
                printExpressions = "\"\""
            }
            
            return prefix + "print(\(printExpressions), terminator: \(term.toSwift()))"
            
        case .input(text: let exp, terminator: let term, variable: let var_):
            
            let terminator: String
            switch term {
            case .comma?:
                terminator = "\"\""
            case .semicolon?:
                // When Semicolon, QBasic appends '?' and one space character to the text
                terminator = "\"? \""
            default:
                terminator = "\"\\n\""
            }
            
            var result = ""
            if let exp_ = exp {
                result += prefix + "print(\(exp_.toSwift()), terminator: \(terminator))\n"
            }
            
            let info: (variableType: String, defaultValue: String)
            guard let type = var_.type else {
                fatalError("Using variable before its declaration")
            }
            
            switch type {
            case .double, .single:
                info = (variableType: "Double", defaultValue: "?? 0")
            case .integer, .long:
                info = (variableType: "Int", defaultValue: "?? 0")
            case .string:
                info = (variableType: "String", defaultValue: "")
            }
            
            result +=
                prefix + "let _ = {\n" +
                prefix + "\tlet input = readLine() ?? \"\"\n" +
                prefix + "\t\(var_.toSwift()) = \(info.variableType)(input) \(info.defaultValue)\n" +
                prefix + "}()\n"

            return result
            
        case .assignment(let variable, let expression):
            return prefix + variable.toSwift() + " = " + expression.toSwift()
            
        case .forLoop(index: let variable, start: let start, end: let end, step: let step, block: let block):
            let blockCode = block.map { $0.toSwift(prefix + "\t") + "\n" }.joined()
            return prefix + "for " + variable.toSwift() +
                " in stride(from: \(start.toSwift()), to: \(end.toSwift()), by: \(step.toSwift())) {\n" +
                blockCode +
                prefix + "}"
            
        case .if_(expression: let exp, block: let block, elseBlock: let elseBlock, elseIf: let elseif):
            let blockCode = block.map { $0.toSwift(prefix + "\t") + "\n" }.joined()
            var result = prefix + "if " + exp.toSwift() + " {\n" +
                blockCode +
                prefix + "}"
            
            if elseBlock != nil && elseif != nil {
                fatalError("If statement can't have both elseBlock and elseIf.")
            }

            if elseBlock == nil && elseif == nil {
                return result
            }
            
            let finalElseBlock: [Statement]
            
            if let elseIfStatement = elseif {
                finalElseBlock = [elseIfStatement]
            } else {
                finalElseBlock = elseBlock!
            }
            
            if finalElseBlock.isEmpty == false {
                let blockCode = finalElseBlock.map { $0.toSwift(prefix + "\t") + "\n" }.joined()
                result += " else {\n" +
                    blockCode +
                    prefix + "}"
            }
            
            return result
            
        case .cls:
            return prefix + "// CLS is not implemented yet"
            
        case .declaration:
            // Explicit declarations are not needed yet
            return ""
            
        case .goto(label: let l):
            return
                prefix + CodeGenerator.nextLabelVariable + " = " + l.toSwift("") + "\n" +
                    prefix + "continue"
            
        case .comment:
            // Comments are ignored
            return ""
        }
    }
}

extension Statement.Terminator: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .none:
            return prefix + "\"\""
        case .tab:
            return prefix + "\"\\t\""
        case .newLine:
            return prefix + "\"\\n\""
        }
    }
}

extension Variable: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        return prefix + name.sanitizedVariableName
    }
    
    func declaration(_ prefix: String = "") -> String {
        guard let type = type else {
            fatalError("Trying to declare var without type")
        }
        
        switch type {
        case .integer, .long:
            return prefix + "var \(toSwift()): Int = 0"
        case .single, .double:
            return prefix + "var \(toSwift()): Double = 0"
        case .string:
            return prefix + "var \(toSwift()): String = \"\""
        }
    }
}

extension String {
    var sanitizedVariableName: String {
        return self.replacingOccurrences(of: "$", with: "__string")
            .replacingOccurrences(of: "%", with: "__int")
            .replacingOccurrences(of: "&", with: "__long")
            .replacingOccurrences(of: "!", with: "__single")
            .replacingOccurrences(of: "#", with: "__double")
    }
}


extension Expression: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .literals(let l):
            return prefix + l.map{ $0.toSwift() }.joined(separator: "")
        case .variable(let v):
            return prefix + v.toSwift()
        }
    }
}

extension Literal: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .vaiableName(let s):
            return prefix + s.sanitizedVariableName
        case .string(let s):
            return prefix + "\"\(s)\""
        case .numberInt(let s), .numberFloat(let s):
            return prefix + s
        case let .op(o):
            return o.toSwift(prefix)
        }
    }
}

extension Operator: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .equal:
            return prefix + "=="
        case .plus:
            return prefix + "+"
        case .minus:
            return prefix + "-"
        case .leftBracket:
            return prefix + "("
        case .rightBracket:
            return prefix + ")"
        case .lessThan:
            return prefix + "<"
        case .greaterThan:
            return prefix + ">"
        case .modulo:
            return prefix + "%"
        case .comma:
            return prefix + "+\"\\t\"+"
        case .semicolon:
            return prefix + "+"
        case .multiplication:
            return prefix + "*"
        case .division:
            return prefix + "/"
            
        }
    }
}



