//
//  ConsoleOut.swift
//  GenViperModules
//
//  Created by Adrian Lakatos on 5/7/20.
//  Copyright © 2020 LosAdrian. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleOut {
    private init(){}
    
    class func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\u{001B}[;m\(message)")
        case .error:
            fputs("\u{001B}[0;31m\(message)\n", stderr)
            print("\u{001B}[;m")
        }
    }
    
    class func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        writeMessage("commands:")
        writeMessage("-ldm : Generate LocalDataManager layer (optional)")
        writeMessage("-rdm : Generate RemoteDataManager layer (optional)")
        writeMessage("-u : User/developer name")
        writeMessage("-p : Project name")
        writeMessage("-c : Company name for Copyrights (optional)")
        writeMessage("-m : Module name")
        writeMessage("")
        writeMessage("usage examples:")
        writeMessage("\(executableName) -u \"Test Developer\" -p TestProject -m TestModule")
        writeMessage("\(executableName) -u \"Test Developer\" -p TestProject -c TestCompany -m TestModule")
        writeMessage("\(executableName) -u TestDeveloper -p TestProject -c TestCompany -m TestModule")
        writeMessage("\(executableName) -ldm -rdm -u \"Test Developer\" -p TestProject -m TestModule")
        writeMessage("\(executableName) -rdm -u \"Test Developer\" -p TestProject -m TestModule")
        writeMessage("\(executableName) -ldm -u \"Test Developer\" -p TestProject -m TestModule")
    }
}
