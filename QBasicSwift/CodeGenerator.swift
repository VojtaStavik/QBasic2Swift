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
        "import Foundation\n" +
        "\n" +
        "// Helper functions\n" +
            "func + (l: Double, r: Int) -> Double { return l + Double(r) }\n" +
            "func + (l: Int, r: Double) -> Double { return r + l }\n" +
            "func - (l: Double, r: Int) -> Double { return l - Double(r) }\n" +
            "func - (l: Int, r: Double) -> Double { return Double(l) - r }\n" +
            "func * (l: Double, r: Int) -> Double { return l * Double(r) }\n" +
            "func * (l: Int, r: Double) -> Double { return r * l }\n" +
            "func / (l: Double, r: Int) -> Double { return l / Double(r) }\n" +
            "func / (l: Int, r: Double) -> Double { return Double(l) / r }\n" +
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
        
        let autodeclaredVars = Set(blocks.flatMap { block -> [Variable?] in
            block.statements.map { element -> Variable? in
                if case .assignment(let variable, _) = element {
                    if variable.isAutodecalared {
                        return variable
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }.flatMap{ $0 }
            }.flatMap{ $0 })
        
        result += "// Declarations:\n" +
                    autodeclaredVars.map{ $0.declaration() }.joined(separator: "\n") +
                    "\n\n"
        
        let mainLabelName = blocks.first!.label.toSwift("")
        
        result += "var \(CodeGenerator.nextLabelVariable) = \(mainLabelName)\n"
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
        
        result += statements.map { $0.toSwift(prefix + "\t") }.joined(separator: "\n") + "\n"
        
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
            var printExpressions = e.reduce("", { (result, element: (Operator?, Expression)) -> String in
                return result + "\(element.0?.toSwift() ?? "")" + "\"\\(\(element.1.toSwift()))\""
            })
            
            if printExpressions.isEmpty {
                printExpressions = "\"\""
            }
            
            return prefix + "print(\(printExpressions), separator: \"\", terminator: \(term.toSwift()))"
            
        case .assignment(let variable, let expression):
            return prefix + variable.toSwift() + " = " + expression.toSwift()
            
        case .forLoop(index: let variable, start: let start, end: let end, step: let step, block: let block):
            let blockCode = block.map { $0.toSwift(prefix + "\t") + "\n" }.joined()
            return prefix + "for " + variable.toSwift() +
                " in stride(from: \(start.toSwift()), to: \(end.toSwift()), by: \(step.toSwift())) {\n" +
                blockCode +
                prefix + "}"
            
        case .if_(expression: let exp, block: let block, elseBlock: let elseBlock):
            let blockCode = block.map { $0.toSwift(prefix + "\t") + "\n" }.joined()
            var result = prefix + "if " + exp.toSwift() + " {\n" +
                blockCode +
                prefix + "}"
            
            if elseBlock.isEmpty == false {
                let blockCode = elseBlock.map { $0.toSwift(prefix + "\t") + "\n" }.joined()
                result += " else {\n" +
                    blockCode +
                    prefix + "}"
            }
            
            return result
            
        case .cls:
            return prefix + "// CLS is not implemented yet"
            
        case .declaration(let var_):
            return var_.declaration(prefix)
            
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
        return prefix + self.name
    }
    
    var name: String {
        let rawName: String
        switch self {
        case .stringType(name: let name, autodeclared: _),
             .integerType(name: let name, autodeclared: _),
             .longType(name: let name, autodeclared: _),
             .singleType(name: let name, autodeclared: _),
             .doubleType(name: let name, autodeclared: _),
             .local(let name):
            rawName = name
        }
        
        // Sanitize var name for Swift
        return rawName.sanitizedVariableName
    }
    
    func declaration(_ prefix: String = "") -> String {
        switch self {
        case .stringType(name: _, autodeclared: _):
            return prefix + "var \(name): String = \"\""
            
        case .integerType(name: _, autodeclared: _),
             .longType(name: _, autodeclared: _):
            // Both int and log will be Int
            return prefix + "var \(name): Int = 0"
            
        case .singleType(name: _, autodeclared: _),
             .doubleType(name: _, autodeclared: _):
            // Both float and double will be double
            return prefix + "var \(name): Double = 0"
            
        default:
            return ""
        }
    }
    
    var isAutodecalared: Bool {
        switch self {
        case .stringType(name: _, autodeclared: true),
             .integerType(name: _, autodeclared: true),
             .longType(name: _, autodeclared: true),
             .singleType(name: _, autodeclared: true),
             .doubleType(name: _, autodeclared: true):
            return true
        default:
            return false
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



