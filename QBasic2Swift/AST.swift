//
//  AST.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 06/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

typealias VariableName = String
typealias FunctionName = String
typealias VarInfo = (type: Variable.VarType?, defType: Variable.DefinitionType?)

struct Program {
    let elements: [Statement]
    
    // Vars defined with SHARED keyword
    static var globalVarsPool: [VariableName: VarInfo] = [:]
    
    // Default scope
    static var mainLoopVarsPool: [VariableName: VarInfo] = [:]
    
    static var functions: Set<Function> = []
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
    
    // Functions
    case funcDeclaration(Function, parameters: [Variable])
    case funcInvocation(Function, parameters: [Expression])
    case funcImplementation(Function)
    case funcReturn(value: Expression)
    
    // Helpers
    case swiftCode(String) // This inserts the code directly into the output file (useful for STDLIB)
}


indirect enum Expression {
    case literals([Literal])
    case variable(Variable)
    case statement(Statement)
}

struct Variable {
    let name: String
    let type: VarType?
    let definedBy: DefinitionType?
    
    init(name: String, type: VarType?, definedBy: DefinitionType?, scope: FunctionName? = nil) {

        self.name = name
        
        guard let definedBy_ = definedBy else {
            // We don't know if var is user defined or not, nothing to do here
            self.type = type
            self.definedBy = definedBy
            return
        }
        
        if case .system = definedBy_ {
            // Var is not user defined, nothing to do here
            self.type = type
            self.definedBy = definedBy
            return
        }
        
        var varPool: [VariableName :VarInfo] {
            get { return scope == nil ? Program.mainLoopVarsPool : Program.functions.filter{ $0.name == scope! }
                                                                            .first!
                                                                            .varPool
            }
            set {
                if scope == nil {
                    Program.mainLoopVarsPool = newValue
                } else {
                    var function = Program.functions.filter{ $0.name == scope! }.first!
                    function.varPool = newValue
                    Program.functions.update(with: function)
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

struct Function {
    let name: FunctionName
    var blocks: [Block]?
    var returnType: Variable?
    var varPool: [VariableName: VarInfo] = [:]
    
    /// Indicates if the function if part of STDLIB
    var isSTDLIB: Bool
    
    init(name: FunctionName, blocks: [Block]?, returnType: Variable? = nil, isSTDLIB: Bool = false) {
        self.name = name
        self.isSTDLIB = isSTDLIB
        
        if let existing = Program.functions.filter({ $0.name == name }).first {
            self.blocks = blocks ?? existing.blocks
            self.returnType = returnType ?? existing.returnType
            self.varPool = existing.varPool
            Program.functions.update(with: self)
        } else {
            self.blocks = blocks
            self.returnType = returnType
            Program.functions.insert(self)
        }
    }
    
    /// Return existing Function or nil
    static func existing(withName name: FunctionName) -> Function? {
        return Program.functions.filter { $0.name == name.sanitizedVariableName }.first
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

extension Function: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension Function: Equatable {
    static func == (l: Function, r: Function) -> Bool {
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
    case functionName(String)
    case string(String)
    case numberInt(String)
    case numberFloat(String)
    case op(Operator)
}

enum Operator {
    case equal
    case notEqual
    case plus
    case minus
    case leftBracket
    case rightBracket
    case lessThan
    case lessOrEqual
    case greaterThan
    case greaterOrEqual
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
    static func FUNCTION() -> StringParser<String>  { return string("FUNCTION")() }
    static func STDLIBFUNCTION() -> StringParser<String>  { return string("_FUNCTION")() }
    static func ENDSUB() -> StringParser<String>    { return string("END SUB")() }
    static func ENDFUNCTION() -> StringParser<String> { return string("END FUNCTION")() }
    
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
        "FUNCTION",
    ]
}
