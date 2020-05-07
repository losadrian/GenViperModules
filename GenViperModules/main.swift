//
//  main.swift
//  GenViperModules
//
//  Created by Adrian Lakatos on 5/7/20.
//  Copyright © 2020 LosAdrian. All rights reserved.
//

import Foundation

guard CommandLine.arguments.count > 1 else {
    ConsoleOut.printUsage()
    exit(-1)
}

let argumentDictionary = ArgumentHandler.retrieveArgumentDictionary(from: CommandLine.arguments)

guard let arguments = argumentDictionary else {
    exit(-1)
}

Generator.generateModules(userName: arguments["userName"]!, projectName: arguments["projectName"]!, copyRights: arguments["copyRights"], moduleName: arguments["moduleName"]!, localDataManager: arguments["localDataManager"], remoteDataManager: arguments["remoteDataManager"])
