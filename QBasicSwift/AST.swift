//
//  AST.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 06/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

typealias VariableName = String
typealias SubName = String
typealias VarInfo = (type: Variable.VarType?, defType: Variable.DefinitionType?)

struct Program {
    let elements: [Statement]
    
    // Vars defined with SHARED keyword
    static var globalVarsPool: [VariableName: VarInfo] = [:]
    
    // Default scope
    static var mainLoopVarsPool: [VariableName: VarInfo] = [:]
    
    static var subs: Set<Sub> = []
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
    
    // Subs
    case subDeclaration(Sub, parameters: [Variable])
    case subInvocation(Sub, parameters: [Expression])
    case subImplementation(Sub)
}


indirect enum Expression {
    case literals([Literal])
    case variable(Variable)
}

struct Variable {
    let name: String
    let type: VarType?
    let definedBy: DefinitionType?
    
    init(name: String, type: VarType?, definedBy: DefinitionType?, scope: SubName? = nil) {

        self.name = name
        
        guard let definedBy_ = definedBy else {
            // We don't know if var is user defined or not, nothing to do here
            self.type = type
            self.definedBy = definedBy
            return
        }
        
        if case .system = definedBy_ {
            // Var is not user defined, nothing to do here
            self.type = nil
            self.definedBy = definedBy
            return
        }
        
        var varPool: [VariableName :VarInfo] {
            get { return scope == nil ? Program.mainLoopVarsPool : Program.subs.filter{ $0.name == scope! }
                                                                            .first!
                                                                            .varPool
            }
            set {
                if scope == nil {
                    Program.mainLoopVarsPool = newValue
                } else {
                    var sub = Program.subs.filter{ $0.name == scope! }.first!
                    sub.varPool = newValue
                    Program.subs.update(with: sub)
                }
            }
        }
        
        if let type = type {
            // We know the type
            
            // Check if the existing type matches the current one
            if let existingType = varPool[name]?.type {
                if existingType != type {
                    fatalError("Variable \(name) declared multiple times with diferent type.")
                }
            } else {
                // Save the type to the pool
                varPool[name] = (type, definedBy_)
            }
            
            self.type = type
            self.definedBy = definedBy_
            
        } else {
            // Fetch existing type
            if let existingType = varPool[name] {
                self.type = existingType.type
                self.definedBy = existingType.defType
            } else {
                fatalError("Variable \(name) used without prior declaration")
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
    
    enum DefinitionType {
        case user
        case system
        case parameter
    }
}

extension Variable: Hashable {
    public var hashValue: Int {
        let salt: Int
        switch definedBy {
        case .user?:
            salt = 13
        case .parameter?:
            salt = 21
        default:
            salt = 1
        }
        return name.hashValue / salt
    }
}

extension Variable: Equatable {
    static func == (l: Variable, r: Variable) -> Bool {
        return (l.hashValue == r.hashValue)
    }
}

struct Sub {
    let name: SubName
    var blocks: [Block]?
    var varPool: [VariableName: VarInfo] = [:]
    
    init(name: SubName, blocks: [Block]?) {
        self.name = name
        
        if let existing = Program.subs.filter({ $0.name == name }).first {
            self.blocks = blocks ?? existing.blocks
            self.varPool = existing.varPool
            Program.subs.update(with: self)
        } else {
            self.blocks = blocks
            Program.subs.insert(self)
        }
    }
    
    /// Return existing sub or nil
    static func existing(withName name: SubName) -> Sub? {
        return Program.subs.filter { $0.name == name }.first
    }
    
    var params: [Variable] {
        return varPool.flatMap { (name, info) -> Variable? in
            if info.defType == .parameter {
                return Variable(name: name, type: info.type, definedBy: info.defType)
            } else {
                return nil
            }
        }
    }
}

extension Sub: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension Sub: Equatable {
    static func == (l: Sub, r: Sub) -> Bool {
        return l.name == r.name
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
    case subName(String)
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
    static func DECLARE() -> StringParser<String>   { return string("DECLARE")() }
    static func SUB() -> StringParser<String>       { return string("SUB")() }
    static func ENDSUB() -> StringParser<String>    { return string("END SUB")() }
    
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
        "DECLARE",
        "SUB",
    ]
}
