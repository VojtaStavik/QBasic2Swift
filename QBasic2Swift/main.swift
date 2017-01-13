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
file = "/Users/vstavik/Documents/OSS/QBasicSwift/TestFiles/QBT38_3.BAS"


let stdLib = try! String(contentsOfFile: Bundle.main.path(forResource: "STDLIB", ofType: "BAS")!)
let contents = try! String(contentsOfFile: file)
let complete = stdLib + "\nUserProgramInternal:\n" + contents

// print(complete)

let result = parse(parser.program, file, complete.characters)

switch result {
case let .left(err): print(err)
case let .right(blocks):
    print(CodeGenerator(blocks: blocks).toSwift())
}
