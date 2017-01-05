//
//  main.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 05/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation



func shell(_ command: String) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["bash", "-c", command]
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let parser = QBasicParser()

let result = try! parse(parser.program, contentsOfFile: "/Users/vstavik/Documents/OSS/QBasicSwift/TestFiles/FizzBuzz.BAS")

switch result {
case let .left(err): print(err)
case let .right(blocks):
    
    print("\(blocks)")
    
    print("===========\n\n\n")
    
    print(CodeGenerator(blocks: blocks).toSwift())
}
