//
//  main.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 05/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

let parser = QBasicParser()

let file: String
if CommandLine.arguments.count > 1 {
    file = CommandLine.arguments[1]
} else {
    file = "/Users/vstavik/Documents/OSS/QBasicSwift/TestFiles/QBT37_2.BAS"
}

do {

    let result = try parse(parser.program, contentsOfFile: file)
    
    switch result {
    case let .left(err): print(err)
    case let .right(blocks):
        print(blocks)
        print(CodeGenerator(blocks: blocks).toSwift())
    }

} catch {
    print(error)
}

