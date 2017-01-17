//
//  Lexer.swift
//  QBasic2Swift
//
//  Created by Stavik, Vojta
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

enum Token {
    case keyword(Token.Keyword)
    case `operator`(Token.Operator)
    case stringLiteral(String)
    case numberLiteral(String)
    case identifier(String)
}

extension Token {
    enum Keyword: String {
        case print  = "PRINT"
        case cls    = "CLS"
        case `for`  = "FOR"
        case to     = "TO"
        case step   = "STEP"
        case next   = "NEXT"
        case `if`   = "IF"
        case then   = "THEN"
        case `else` = "ELSE"
        case elseif = "ELSEIF"
        case end    = "END"
        case dim    = "DIM"
        case `as`   = "AS"
        case integer = "INTEGER"
        case long   = "LONG"
        case single = "SINGLE"
        case double = "DOUBLE"
        case string = "STRING"
        case goto   = "GOTO"
        case rem    = "REM"
        case input  = "INPUT"
        case declare = "DECLARE"
        case sub    = "SUB"
        case function = "FUNCTION"
        case `do`   = "DO"
        case loop = "LOOP"
        case until = "UNTIL"
        case `while` = "WHILE"
        case select = "SELECT"
        case `case` = "CASE"
        case randomize = "RANDOMIZE"
        case timer  = "TIMER"
        case comment = "'"
    }
}

extension Token {
    enum Operator: String {
        case equal  = "="
        case notEqual = "<>"
        case plus   = "+"
        case minus  = "-"
        case lessThan = "<"
        case lessOrEqual = "<="
        case greaterThan = ">"
        case greaterOrEqual = ">="
        case modulo = "MOD"
        case comma = ","
        case semicolon = ";"
        case multiplication = "*"
        case division = "/"
        case leftParenthesis = "("
        case rightParenthesis = ")"
        case colon = ":"
        case boolAND = "AND"
        case boolOR = "OR"
    }
}

//extension Token {
//    enum TypeSpecifier: String {
//        case string = "$"
//        case integer = "%"
//        case long = "&"
//        case single = "!"
//        case double = "#"
//    }
//}

// MARK: -
struct QBasicLexer {
    let code: String
    
    init(code: String) {
        self.code = code.replacingOccurrences(of: "\r", with: "")
    }
    
    func getTokens() throws -> [Token] {
        let result = parse(spaces >>> many(attempt(token) <<< spaces) <<< eof, "Code", code.characters)
        switch result {
        case let .left(error):
            throw error
        case let .right(tokens):
            return tokens
        }
    }
    
    private func token() -> StringParser<Token> {
        return (
            attempt(keyword) <|>
            attempt(`operator`) <|>
            attempt(stringLiteral) <|>
            attempt(numberLiteral) <|>
            attempt(identifier)
        )()
    }

    private func keyword() -> StringParser<Token> {
        // Create a parser for each keyword
        let keywordParsers: [() -> StringParser<Token>] = iterateEnum(Token.Keyword.self)
            .map { keyword in return { return (string(keyword.rawValue) >>- { _ in create(.keyword(keyword)) })() } }
        
        // Join them
        let emptyParser: () -> StringParser<Token> = { return parserZero() }
        let all = keywordParsers.reduce(emptyParser) { (result, next) -> (() -> StringParser<Token>) in
            return result <|> attempt(next)
        }
        
        return all()
    }

    private func `operator`() -> StringParser<Token> {
        // Create a parser for each operator
        let operatorParsers: [() -> StringParser<Token>] = iterateEnum(Token.Operator.self)
            .map { op in return { return (string(op.rawValue) >>- { _ in create(.`operator`(op)) })() } }
        
        // Join them
        let emptyParser: () -> StringParser<Token> = { return parserZero() }
        let all = operatorParsers.reduce(emptyParser) { (result, next) -> (() -> StringParser<Token>) in
            return result <|> attempt(next)
        }
        
        return all()
    }
    
    func stringLiteral() -> StringParser<Token> {
        let quote: () -> StringParser<Character>  = { return (char("\""))() }
        return (between(quote, quote, (many1(noneOf("\"")))) >>- { create(.stringLiteral(String($0))) })()
    }

    func numberLiteral() -> StringParser<Token> {
        return (many1(oneOf("0123456789.")) >>- { create(.numberLiteral(String($0))) })()
    }

    func identifier() -> StringParser<Token> {
        return (alphaNum >>- { firstChar in
            let operators = iterateEnum(Token.Operator.self).map{ $0.rawValue }.joined()
            return many(noneOf(operators + " \n")) >>- { rest in
                create(.identifier(String([firstChar] + rest)))
            }
        })()
    }
}

// MARK: - Extensions

extension Token: Equatable {
    static func == (l: Token, r: Token) -> Bool {
        switch (l, r) {
        case let (.keyword(kl), .keyword(kr)):
            return kl == kr
        case let (.`operator`(kl), .`operator`(kr)):
            return kl == kr
        case (.stringLiteral(let ls), .stringLiteral(let rs)),
             (.numberLiteral(let ls), .numberLiteral(let rs)),
             (.identifier(let ls), .identifier(let rs)):
            return ls == rs
        default:
            return false
        }
    }
}
