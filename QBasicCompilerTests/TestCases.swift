//
//  TestCases.swift
//  QBasic2Swift
//
//  Created by Stavik, Vojta
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation
@testable import QBasicCompiler

class TestCases {

    typealias Case = (name: String, rawCode: String, tokens: [Token])
    
    let all: [Case]
    
    init() {
        let testCasesPath = Bundle(for: type(of: self)).paths(forResourcesOfType: "BAS", inDirectory: nil)
        all = testCasesPath.map { path in
            let name = path.components(separatedBy: "/").last!
            
            let components = try! String(contentsOfFile: path).components(separatedBy: "~~~~~~~~~~~~~~~~~~~~")
            
            let rawCode = components[0]
            
            let tokens = components[1]
                            .components(separatedBy: "\n")
                            .flatMap(Token.init(rawValue:))
            
            return (name, rawCode, tokens)
        }
    }
}

extension Token: RawRepresentable {
    private static var separator: String { return " \t#@# " }
    private static var keywordRawValue: String      { return "KEYWORD    " }
    private static var operatorRawValue: String     { return "OPERATOR   " }
    private static var stringRawValue: String       { return "STRING     " }
    private static var numberRawValue: String       { return "NUMBER     " }
    private static var identifierRawValue: String   { return "IDENTIFIER " }
    
    public var rawValue: String {
        switch self {
        case let .keyword(kwd):
            return Token.keywordRawValue + Token.separator + kwd.rawValue
        case let .`operator`(op):
            return Token.operatorRawValue + Token.separator + op.rawValue
        case let .stringLiteral(lit):
            return Token.stringRawValue + Token.separator + lit
        case let .numberLiteral(lit):
            return Token.numberRawValue + Token.separator + lit
        case let .identifier(ident):
            return Token.identifierRawValue + Token.separator + ident.sanitized
        }
    }
    
    public init?(rawValue: String) {
        let components = rawValue
                            .sanitized
                            .components(separatedBy: Token.separator)
        
        switch components[0] {
        case Token.keywordRawValue:
            self = .keyword(Token.Keyword(rawValue: components[1])!)
        case Token.operatorRawValue:
            self = .`operator`(Token.Operator(rawValue: components[1])!)
        case Token.stringRawValue:
            self = .stringLiteral(components[1])
        case Token.numberRawValue:
            self = .numberLiteral(components[1])
        case Token.identifierRawValue:
            self = .identifier(components[1])
        default:
            return nil
        }
    }
}

extension String {
    var sanitized: String {
        return replacingOccurrences(of: "\r", with: "")
    }
}
