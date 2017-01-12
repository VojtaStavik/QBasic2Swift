//
//  AST.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 06/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

struct Program {
    let elements: [Statement]
    
    typealias VariableName = String
    static var globalVarsPool: [VariableName: Variable.VarType?] = [:]
}

struct Block {
    let label: Label
    let statements: [Statement]
}

indirect enum Statement {
    enum Terminator {
        case none
        case tab
        case newLine
    }
    
    case print([(Operator?, Expression)], terminator: Terminator)
    case forLoop(index: Variable, start: Expression, end: Expression, step: Expression, block: [Statement])
    case if_(expression: Expression, block: [Statement], elseBlock: [Statement]?, elseIf: Statement?)
    case assignment(Variable, Expression)
    case declaration(Variable)
    case goto(label: Label)
    case input(text: Expression?, terminator: Operator?, variable: Variable)
    case cls
    case comment(String)
}


indirect enum Expression {
    case literals([Literal])
    case variable(Variable)
}

struct Variable {
    let name: String
    let type: VarType?
    let userDefined: Bool?
    
    init(name: String, type: VarType?, userDefined: Bool?) {

        self.name = name
        self.userDefined = userDefined
        
        guard let userDefined = userDefined else {
            // We don't know if var is user defined or not, nothing to do here
            self.type = type
            return
        }
        
        guard userDefined else {
            // Var is not user defined, nothing to do here
            self.type = nil
            return
        }

        if let type = type {
            // We know the type
            
            // Check if the existing type matches the current one
            if let existingType = Program.globalVarsPool[name] {
                if existingType != type {
                    fatalError("Variable declared multiple times with diferent type.")
                }
            } else {
                // Save the type to the pool
                Program.globalVarsPool[name] = type
            }
            
            self.type = type
            
        } else {
            // Fetch existing type
            if let existingType = Program.globalVarsPool[name] {
                self.type = existingType
            } else {
                fatalError("Variable used without prior declaration")
            }
        }
    }
    
    enum VarType {
        case string
        case integer
        case long
        case single
        case double
    }
}

extension Variable: Hashable {
    public var hashValue: Int {
        return name.hashValue / (userDefined ?? false ? 13 : 1)
    }
}

extension Variable: Equatable {
    static func == (l: Variable, r: Variable) -> Bool {
        return (l.hashValue == r.hashValue)
    }
}

struct Label {
    let name: String
}

extension Label {
    static var main: Label { return Label(name: "") }
}

extension Label: Swiftable {
    func toSwift(_ prefix: String) -> String {
        return prefix + "\"" + name + "\""
    }
}


indirect enum Literal {
    case vaiableName(String)
    case string(String)
    case numberInt(String)
    case numberFloat(String)
    case op(Operator)
}

enum Operator {
    case equal
    case plus
    case minus
    case leftBracket
    case rightBracket
    case lessThan
    case greaterThan
    case modulo
    case comma
    case semicolon
    case multiplication
    case division
}

struct Keyword {
    static func PRINT() -> StringParser<String>     { return string("PRINT")() }
    static func CLS() -> StringParser<String>       { return string("CLS")() }
    static func FOR() -> StringParser<String>       { return string("FOR")() }
    static func TO() -> StringParser<String>        { return string("TO")() }
    static func STEP() -> StringParser<String>      { return string("STEP")() }
    static func NEXT() -> StringParser<String>      { return string("NEXT")() }
    static func IF() -> StringParser<String>        { return string("IF")() }
    static func THEN() -> StringParser<String>      { return string("THEN")() }
    static func ELSE() -> StringParser<String>      { return string("ELSE")() }
    static func ELSEIF() -> StringParser<String>    { return string("ELSEIF")() }
    static func ENDIF() -> StringParser<String>     { return string("END IF")() }
    static func DIM() -> StringParser<String>       { return string("DIM")() }
    static func AS() -> StringParser<String>        { return string("AS")() }
    static func INTEGER() -> StringParser<String>   { return string("INTEGER")() }
    static func LONG() -> StringParser<String>      { return string("LONG")() }
    static func SINGLE() -> StringParser<String>    { return string("SINGLE")() }
    static func DOUBLE() -> StringParser<String>    { return string("DOUBLE")() }
    static func STRING() -> StringParser<String>    { return string("STRING")() }
    static func GOTO() -> StringParser<String>      { return string("GOTO")() }
    static func REM() -> StringParser<String>       { return string("REM")() }
    static func INPUT() -> StringParser<String>     { return string("INPUT")() }
    
    static let all: [String] = [
        "PRINT",
        "CLS",
        "FOR",
        "TO",
        "STEP",
        "NEXT",
        "IF",
        "THEN",
        "ELSE",
        "ELSEIF",
        "END",
        "DIM",
        "AS",
        "INTEGER",
        "LONG",
        "SINGLE",
        "DOUBLE",
        "STRING",
        "GOTO",
        "REM",
        "INPUT",
    ]
}
