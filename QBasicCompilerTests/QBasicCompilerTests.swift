//
//  QBasicCompilerTests.swift
//  QBasicCompilerTests
//
//  Created by Stavik, Vojta
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Quick
import Nimble
@testable import QBasic2Swift

//class QBasic2SwiftTests: QuickSpec {
//    override func spec() {
//        
//        let testCasesPath = Bundle(for: type(of: self)).paths(forResourcesOfType: "BAS", inDirectory: nil)
//        
//        let parser = QBasicParser()
//        
//        beforeEach {
//            // TODO -> make these variables instant?
//            Program.functions.removeAll()
//            Program.globalVarsPool.removeAll()
//            Program.mainLoopVarsPool.removeAll()
//        }
//        
//        for path in testCasesPath {
//            let contents = try! String(contentsOfFile: path)
//            let components = contents.components(separatedBy: "~~~~~~~~~~~~~~~~~~~~")
//            
//            describe(path.components(separatedBy: "/").last!) {
//                it("is compiled correctly") {
//                    let result = parse(parser.program, "", components[0].characters)
//                    if case .right(let rawBlocks) = result {
//                        let code = CodeGenerator(blocks: rawBlocks).toSwift("", onlyUserCode: true)
//                            .trimmingCharacters(in: .whitespacesAndNewlines)
//                        
//                        let reference = components[1]
//                            .trimmingCharacters(in: .whitespacesAndNewlines)
//                            .replacingOccurrences(of: "\r", with: "")
//                        
//                        print("\n" + code + "\n")
//                        print("\n" + reference + "\n")
//                        
//                        expect(code) == reference
//                    } else {
//                        fail()
//                    }
//                }
//            }
//        }
//    }
//}
