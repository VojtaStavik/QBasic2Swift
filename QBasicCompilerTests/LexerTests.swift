//
//  LexerTests.swift
//  QBasic2Swift
//
//  Created by Stavik, Vojta on 16/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Quick
import Nimble

@testable import QBasicCompiler

class LexerTests: QuickSpec {
    
    typealias TestCase = (code: String, tokens: [Token])
    
    let testCases = TestCases()
    
    override func spec() {
        describe("Lexer") {
            testCases.all.forEach { testCase in
                it("should parse \(testCase.name)") {
                    let lexer = QBasicLexer(code: testCase.rawCode)
                    let tokens = try! lexer.getTokens()
                    
                    print(tokens.map{ $0.rawValue }.joined(separator: "\n"))
                    print("====")
                    print(testCase.tokens.map{ $0.rawValue }.joined(separator: "\n"))
                    
                    for (left, right) in zip(tokens, testCase.tokens) {
                        if left != right {
                            print("")
                        }
                    }
                    
                    expect(tokens) == testCase.tokens
                }
            }
        }
    }
}
