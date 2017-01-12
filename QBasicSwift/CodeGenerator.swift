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
    
    func toSwift(_ prefix: String = "") -> String {
        
        var result = CodeGenerator.programHeaders
        
        let globalVars = Program.globalVarsPool
            .flatMap { (name, info) -> Variable? in
                if info.defType == .user {
                    return Variable(name: name, type: info.type, definedBy: info.defType)
                } else {
                    return nil
                }
            }

        if globalVars.isEmpty == false {
            result += "// Global vars declaration\n" +
                globalVars.map{ $0.declaration() }.joined(separator: "\n") +
            "\n\n"
        }

        if Program.subs.isEmpty == false {
            result +=   "// Subs\n"
            Program.subs.forEach {
                result += $0.toSwift()
            }
        }

        // Main loop
        result +=   "_ = {\n"

        let mainLoopVars = Program.mainLoopVarsPool
            .flatMap { (name, info) -> Variable? in
                if info.defType == .user {
                    return Variable(name: name, type: info.type, definedBy: info.defType)
                } else {
                    return nil
                }
            }

        if mainLoopVars.isEmpty == false {
            result += "\t// Main loop vars declaration\n" +
                mainLoopVars.map{ $0.declaration("\t") }.joined(separator: "\n") +
            "\n"
        }

        result += RunLoop(blocks: blocks, identifier: "main").toSwift("\t")
        
        result += "}()\n"
        
        return result
    }
}

struct RunLoop: Swiftable {
    let blocks: [Block]
    let identifier: String
    
    var firstBlockLabel: String {
        if let name = blocks.first?.label.name {
            if name.isEmpty {
                return "\"\""
            } else {
                return name
            }
        } else {
            return "\"\""
        }
    }
    
    var doneVarName: String { return identifier + "LoopDone__internal" }
    var nextLabelVarName: String { return identifier + "NextLabel__internal" }
    
    func loopStart(_ prefix: String) -> String {
        return [
            "// \(identifier) loop:",
            "var \(nextLabelVarName) = \(firstBlockLabel)",
            "var \(doneVarName) = false",
            "repeat {",
            "\tswitch \(nextLabelVarName) {"
        ].map { prefix + $0 }.joined(separator: "\n")
    }

    func loopEnd(_ prefix: String) -> String {
        return [
            "\tdefault:",
            "\t\t\(doneVarName) = true",
            "\t}",
            "} while \(doneVarName) == false",
            ""
        ].map { prefix + $0 }.joined(separator: "\n")
    }

    func toSwift(_ prefix: String = "") -> String {
        
        if blocks.count > 1 {
            // Needs interpretation using Swift
            var result = "\n" + loopStart(prefix)
            
            result += "\n"
            
            blocks.forEach {
                result += $0.toSwift("\t\t", loopNextLabelVarName: nextLabelVarName)
            }
            
            result += "\n"
            
            result += loopEnd(prefix)
            return result
        } else {
            // No Switch needed
            return "\n" + (blocks.first?.toSwiftWithoutSwitch(prefix, loopNextLabelVarName: nextLabelVarName) ?? "")
        }
    }
}



extension Block: Swiftable {
    
    internal func toSwift(_ prefix: String) -> String {
        return toSwift(prefix, loopNextLabelVarName: "")
    }
    
    func toSwift(_ prefix: String = "",  loopNextLabelVarName name: String) -> String {
        var result = prefix + "case \(label.toSwift("")):\n"
        
        result += toSwiftWithoutSwitch(prefix + "\t", loopNextLabelVarName: name)
        
        if case .goto(_)? = statements.last {
            // Do nothing, just the new line
            result += "\n"
        } else {
            result += prefix + "\tfallthrough\n"
        }
        
        return result
    }
    
    func toSwiftWithoutSwitch(_ prefix: String = "", loopNextLabelVarName name: String) -> String {
        return statements.map { $0.toSwift(prefix, loopNextLabelVarName: name) }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n") + "\n"
    }
}

extension Statement: Swiftable {
    internal func toSwift(_ prefix: String) -> String {
        return toSwift(prefix, loopNextLabelVarName: "")
    }

    func toSwift(_ prefix: String = "", loopNextLabelVarName: String) -> String {
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
            let blockCode = block.map { $0.toSwift(prefix + "\t", loopNextLabelVarName: loopNextLabelVarName) + "\n" }.joined()
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
                prefix + loopNextLabelVarName + " = " + l.toSwift("") + "\n" +
                    prefix + "continue"
            
        case .comment:
            // Comments are ignored
            return ""
            
        case .subInvocation(let sub, parameters: let params):
            let paramNames = sub.params.map { $0.name }
            
            assert(params.count == paramNames.count, "Function \(sub.name) called with \(params.count) parameters but declared with \(paramNames.count).")

            var paramsAndValues: [String] = []
            params.enumerated().forEach({ (index, parameter) in
                paramsAndValues.append(paramNames[index].sanitizedVariableName + ": " + parameter.toSwift())
            })
            
            return prefix + "\(sub.name.sanitizedVariableName)(\(paramsAndValues.joined(separator: ", "))"
            
        default:
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

extension Sub: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        
        let localVars = varPool.flatMap { (name, info) -> Variable? in
                            if info.defType == .user {
                                return Variable(name: name, type: info.type, definedBy: info.defType)
                            } else {
                                return nil
                            }
                        }
        
        var result = prefix + "func \(name)(\( params.map{ $0.asParameter() }.joined(separator: ", "))) -> Void {\n"
        
        if localVars.isEmpty == false {
            result += "\t// Local vars declaration\n" +
                localVars.map{ $0.declaration(prefix + "\t") }.joined(separator: "\n") +
            "\n"
        }
        
        result += RunLoop(blocks: blocks ?? [], identifier: name).toSwift("\t")
        
        result += "}\n\n"

        return result
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
        case .integer, .long,
             .single, .double:
            return prefix + "var \(toSwift()): \(typeName) = 0"
        
        case .string:
            return prefix + "var \(toSwift()): \(typeName) = \"\""
        }
    }
    
    func asParameter(_ prefix: String = "") -> String {
        return prefix + toSwift() + ": " + typeName
    }
    
    var typeName: String {
        guard let type = type else {
            fatalError("Trying to use var without type")
        }
        
        switch type {
        case .integer, .long:
            return "Int"
        case .single, .double:
            return "Double"
        case .string:
            return "String"
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
        case .vaiableName(let s), .subName(let s):
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



