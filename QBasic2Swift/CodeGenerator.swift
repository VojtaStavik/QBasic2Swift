//
//  CodeGenerator.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 06/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

let tabIndent = "    "

protocol Swiftable {
    func toSwift(_ prefix: String) -> String
}

struct CodeGenerator: Swiftable {

    let blocks: [Block]

    static let nextLabelVariable = "nextLabel__internal"
    static let doneVariable = "done__internal"
    
    
    static let programHeaders: String =
        "#!/usr/bin/env xcrun swift\n" +
        "import Foundation\n"
    
    func toSwift(_ prefix: String = "") -> String {
        return toSwift(prefix, onlyUserCode: false)
    }
    
    func toSwift(_ prefix: String, onlyUserCode: Bool) -> String {
        
        var result = ""
        
        if onlyUserCode == false {
            
            result += CodeGenerator.programHeaders
            
            result += "\n"
            
            let stdLibBlock = blocks.filter{ $0.label.name == "STDLIBINTERNAL" }.first!
            result += stdLibBlock.toSwiftWithoutSwitch(loopNextLabelVarName: "")
            
            result += "\n"
            
            let stdLibFunctions = Program.functions.filter{ $0.isSTDLIB }
            result +=   "// STDLIB Functions\n"
            stdLibFunctions.forEach {
                result += $0.toSwift()
            }
        }
       
        result += "\n"
        
        // Global variables
        
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
            "\n"
        }
        
        // User defined functions
        let userFunctions = Program.functions.filter{ $0.isSTDLIB == false }
        if userFunctions.isEmpty == false {
            result +=   "// User functions\n"
            userFunctions.forEach {
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
            result += "\(tabIndent)// Main loop vars declaration\n" +
                mainLoopVars.map{ $0.declaration(tabIndent) }.joined(separator: "\n") +
            "\n"
        }

        result += RunLoop(blocks: blocks.filter{ $0.label.name != "STDLIBINTERNAL" }, identifier: "main").toSwift(tabIndent)
        
        result += "\n}()\n"
        
        return result
    }
}

struct RunLoop: Swiftable {
    let blocks: [Block]
    let identifier: String
    
    var firstBlockLabel: String {
        let blocksWithoutSTDLIB = blocks.filter{ $0.label.name != "STDLIBINTERNAL" }
        if let name = blocksWithoutSTDLIB.first?.label.name {
            if name.isEmpty {
                return "\"\""
            } else {
                return "\"name\""
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
            "\(tabIndent)switch \(nextLabelVarName) {\n",
        ].map { prefix + $0 }.joined(separator: "\n")
    }

    func loopEnd(_ prefix: String) -> String {
        return [
            "\(tabIndent)default:",
            "\(tabIndent)\(tabIndent)\(doneVarName) = true",
            "\(tabIndent)}",
            "} while \(doneVarName) == false",
        ].map { prefix + $0 }.joined(separator: "\n")
    }

    func toSwift(_ prefix: String = "") -> String {
        
        if blocks.count > 1 {
            // Needs interpretation using Swift
            var result = "\n" + loopStart(prefix)
            
            blocks.forEach {
                result += $0.toSwift("\(tabIndent)\(tabIndent)", loopNextLabelVarName: nextLabelVarName)
            }
            
            result += loopEnd(prefix) + "\n"
            return result
        } else {
            // No Switch needed
            return blocks.first?.toSwiftWithoutSwitch(prefix, loopNextLabelVarName: nextLabelVarName) ?? ""
        }
    }
}



extension Block: Swiftable {
    
    internal func toSwift(_ prefix: String = "") -> String {
        return toSwift(prefix, loopNextLabelVarName: "")
    }
    
    func toSwift(_ prefix: String = "",  loopNextLabelVarName name: String) -> String {
        var result = prefix + "case \(label.toSwift("")):"
        
        result += toSwiftWithoutSwitch(prefix + tabIndent, loopNextLabelVarName: name)
        
        if case .goto(_)? = statements.last {
            // Do nothing, just the new line
            result += "\n"
        } else {
            result += prefix + "\(tabIndent)fallthrough\n"
        }
        
        return result
    }
    
    func toSwiftWithoutSwitch(_ prefix: String = "", loopNextLabelVarName name: String) -> String {
        return
            "\n" +
            statements.map { $0.toSwift(prefix, loopNextLabelVarName: name) }
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
                info = (variableType: "Double", defaultValue: " ?? 0")
            case .integer, .long:
                info = (variableType: "Int", defaultValue: " ?? 0")
            case .string:
                info = (variableType: "String", defaultValue: "")
            case .void:
                fatalError("this shouldn't happen")
            }
            
            result +=
                prefix + "let _ = {\n" +
                prefix + "\(tabIndent)let input = readLine() ?? \"\"\n" +
                prefix + "\(tabIndent)\(var_.toSwift()) = \(info.variableType)(input)\(info.defaultValue)\n" +
                prefix + "}()\n"

            return result
            
        case .assignment(let variable, let expression):
            return prefix + variable.toSwift() + " = " + expression.toSwift()
            
        case .forLoop(index: let variable, start: let start, end: let end, step: let step, block: let block):
            let blockCode = block.map { $0.toSwift(prefix + tabIndent) + "\n" }.joined()
            return prefix + "for " + variable.toSwift() +
                " in stride(from: \(start.toSwift()), to: \(end.toSwift()), by: \(step.toSwift())) {\n" +
                blockCode +
                prefix + "}"
            
        case .if_(expression: let exp, block: let block, elseBlock: let elseBlock, elseIf: let elseif):
            let blockCode = block.map { $0.toSwift(prefix + tabIndent, loopNextLabelVarName: loopNextLabelVarName) }.joined(separator: "\n")
            var result = prefix + "if " + exp.toSwift() + " {\n" +
                blockCode + "\n" +
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
                let blockCode = finalElseBlock.map { $0.toSwift(prefix + tabIndent) }.joined(separator: "\n")
                result += " else {\n" +
                    blockCode + "\n" +
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
            
        case .funcInvocation(let sub, parameters: let params):
            let paramNames = sub.params.map { $0.name }
            
            assert(params.count == paramNames.count, "Function \(sub.name) called with \(params.count) parameters but declared with \(paramNames.count).")

            var paramsAndValues: [String] = []
            params.enumerated().forEach({ (index, parameter) in
                paramsAndValues.append(paramNames[index].sanitizedVariableName + ": " + parameter.toSwift())
            })
            
            let r = "\(sub.name.sanitizedVariableName)(\(paramsAndValues.joined(separator: ", ")))"
            
            return prefix + r
            
        case .funcReturn(value: let exp):
            return prefix + "return \(exp.toSwift())\n"
            
        case .swiftCode(let code):
            return prefix + code
            
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

extension Function: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        
        let swiftReturnType: String
        switch returnType?.type {
        case .integer?, .long?:
            swiftReturnType = "Int"

        case .single?, .double?:
            swiftReturnType = "Double"
            
        case .string?:
            swiftReturnType = "String"

        default:
            swiftReturnType = "Void"
        }
        
        var result = prefix + "func \(name)(\( params.map{ $0.asParameter() }.joined(separator: ", "))) -> \(swiftReturnType) {\n"
        
        let localVars = varPool.flatMap { (name, info) -> Variable? in
            if info.defType == .user {
                return Variable(name: name, type: info.type, definedBy: info.defType)
            } else {
                return nil
            }
        }
        
        if localVars.isEmpty == false {
            result += "\(tabIndent)// Local vars declaration\n" +
                localVars.map{ $0.declaration(prefix + tabIndent) }.joined(separator: "\n") +
            "\n"
        }
        
        result += RunLoop(blocks: blocks ?? [], identifier: name).toSwift(tabIndent)
        
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
            
        case .void:
            fatalError("This shouldn't happen")
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
        case .void:
            return "Void"
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
            return v.toSwift(prefix)
        case .statement(let stat):
            return stat.toSwift(prefix)
        }
    }
}

extension Literal: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .vaiableName(let s), .functionName(let s):
            return prefix + s.sanitizedVariableName
        case .string(let s):
            return prefix + "\"\(s)\""
        case .numberInt(let s), .numberFloat(let s):
            return prefix + s
        case let .op(o):
            return o.toSwift(prefix)
        case .braced(let literals):
            print("\(literals)")
            return prefix + literals.map{ $0.toSwift() }.joined()
        }
    }
}

extension Operator: Swiftable {
    func toSwift(_ prefix: String = "") -> String {
        switch self {
        case .equal:
            return prefix + "=="
        case .notEqual:
            return prefix + "!="
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
        case .lessOrEqual:
            return prefix + "<="
        case .greaterThan:
            return prefix + ">"
        case .greaterOrEqual:
            return prefix + ">="
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



