//
//  main.swift
//  QBasic2Swift
//
//  Created by Stavik, Vojta on 05/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation
import Cocoa

if NSClassFromString("XCTestCase") != nil {
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    
} else {

    let parser = QBasicParser()
    
    let file: String
    file = "/Users/vstavik/Documents/OSS/QBasicSwift/QBasic2SwiftTests/TestCases/guessNumber.BAS_"
    
    
    let stdLib = try! String(contentsOfFile: Bundle.main.path(forResource: "STDLIB", ofType: "BAS")!)
    let contents = try! String(contentsOfFile: file)
    let complete = (stdLib + "\nUserProgramInternal:\n" + contents).components(separatedBy: "~~~~~~~~~~~~~~~~~~~~").first!
    
    print(complete)
    
    let result = parse(parser.program, file, complete.characters)
    
    switch result {
    case let .left(err): print(err)
    case let .right(blocks):
        print(CodeGenerator(blocks: blocks).toSwift())
    }
    
}
