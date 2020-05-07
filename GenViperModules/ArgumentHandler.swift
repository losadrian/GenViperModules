//
//  ArgumentHandler.swift
//  GenViperModules
//
//  Created by Adrian Lakatos on 5/7/20.
//  Copyright © 2020 LosAdrian. All rights reserved.
//

import Foundation

enum OptionType: String {
    case userName = "-u"
    case projectName = "-p"
    case copyRights = "-c"
    case moduleName = "-m"
    case localDataManager = "-ldm"
    case remoteDataManager = "-rdm"
    case unknown
    
    init(value: String) {
        switch value {
        case "-u": self = .userName
        case "-p": self = .projectName
        case "-c": self = .copyRights
        case "-m": self = .moduleName
        case "-ldm": self = .localDataManager
        case "-rdm": self = .remoteDataManager
        default: self = .unknown
        }
    }
}

class ArgumentHandler {
    private init(){}
    class func retrieveArgumentDictionary(from arguments:[String]) -> Dictionary<String, String>? {
        let argumentsCount = arguments.count
        guard argumentsCount >= 7 else {
            ConsoleOut.printUsage()
            return nil
        }
        
        var retVal = Dictionary<String, String>()
        
        for i in 1..<argumentsCount {
            let argument = arguments[i]
            
            if (argument.first == "-") {
                let optionTypeArgument = argument
                
                let option : OptionType = getOption(optionTypeArgument)
                
                var valueTypeArgument = ""
                
                if(option != .localDataManager && option != .remoteDataManager) {
                    valueTypeArgument = arguments[i+1]
                }
                
                switch option {
                case .userName:
                    retVal["userName"] = valueTypeArgument
                case .projectName:
                    retVal["projectName"] = valueTypeArgument
                case .copyRights:
                    retVal["copyRights"] = valueTypeArgument
                case .moduleName:
                    retVal["moduleName"] = valueTypeArgument
                case .localDataManager:
                    retVal["localDataManager"] = valueTypeArgument
                case .remoteDataManager:
                    retVal["remoteDataManager"] = valueTypeArgument
                case .unknown:
                    ConsoleOut.writeMessage("The \"\(optionTypeArgument)\" argument is an unknown option", to: .error)
                    ConsoleOut.printUsage()
                    return nil
                }
            }
            
            
            
        }
        return retVal
    }
    
    class func getOption(_ argument:String) -> OptionType {
        return (OptionType(value: argument))
    }
}
