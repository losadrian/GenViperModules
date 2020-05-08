//
//  Generator.swift
//  GenViperModules
//
//  Created by Adrian Lakatos on 5/7/20.
//  Copyright © 2020 LosAdrian. All rights reserved.
//

import Foundation

class Generator {
    private init(){}
    class func generateModules(userName: String, projectName: String, copyRights: String?, moduleName: String, localDataManager: String?, remoteDataManager: String?, cocoaFramework: String?) {
        var localDataManagerIsNeeded = false
        var remoteDataManagerIsNeeded = false
        var isCocoaApi = false
        if let _ = localDataManager {
            localDataManagerIsNeeded = true
        }
        if let _ = remoteDataManager {
            remoteDataManagerIsNeeded = true
        }
        if let _ = cocoaFramework {
            isCocoaApi = true
        }
        let oneOfDataManagerIsNeeded = localDataManagerIsNeeded || remoteDataManagerIsNeeded
        
        var uiFramework = "UIKit"
        var storyboardType = "UIStoryboard"
        var viewControllerType = "UIViewController"
        var instantiateUIControllerMethodName = "instantiateViewController"
        
        if (isCocoaApi) {
            uiFramework = "Cocoa"
            storyboardType = "NSStoryboard"
            viewControllerType = "NSViewController"
            viewControllerType = "NSViewController"
            instantiateUIControllerMethodName = "instantiateController"
        }
        
        ConsoleOut.writeMessage("localDataManagerIsNeeded : \(localDataManagerIsNeeded)", to: .standard)
        ConsoleOut.writeMessage("remoteDataManagerIsNeeded : \(remoteDataManagerIsNeeded)", to: .standard)
        let fileManager = FileManager.default
        
        let workUrl                 = URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
        
        let moduleUrl               = workUrl.appendingPathComponent(moduleName)
        let builderImpUrl           = moduleUrl.appendingPathComponent("Builder")
        let dataManagerImpUrl       = moduleUrl.appendingPathComponent("DataManager")
        let interactorImpUrl        = moduleUrl.appendingPathComponent("Interactor")
        let presenterImpUrl         = moduleUrl.appendingPathComponent("Presenter")
        let protocolsUrl            = moduleUrl.appendingPathComponent("Protocols")
        let routerImpUrl            = moduleUrl.appendingPathComponent("Router")
        let viewControllerImpUrl    = moduleUrl.appendingPathComponent("View")
        
        let protocolInteractorUrl           = protocolsUrl.appendingPathComponent(moduleName+"InteractorProtocol").appendingPathExtension("swift")
        let protocolLocalDataManagerUrl     = protocolsUrl.appendingPathComponent(moduleName+"LocalDataManagerProtocol").appendingPathExtension("swift")
        let protocolPresenterUrl            = protocolsUrl.appendingPathComponent(moduleName+"PresenterProtocol").appendingPathExtension("swift")
        let protocolRemoteDataManagerUrl    = protocolsUrl.appendingPathComponent(moduleName+"RemoteDataManagerProtocol").appendingPathExtension("swift")
        let protocolRouterUrl               = protocolsUrl.appendingPathComponent(moduleName+"RouterProtocol").appendingPathExtension("swift")
        let protocolViewControllerUrl       = protocolsUrl.appendingPathComponent(moduleName+"ViewControllerProtocol").appendingPathExtension("swift")
        
        let builderUrl              = builderImpUrl.appendingPathComponent(moduleName+"Builder").appendingPathExtension("swift")
        let localDataManagerUrl     = dataManagerImpUrl.appendingPathComponent(moduleName+"LocalDataManager").appendingPathExtension("swift")
        let remoteDataManagerUrl    = dataManagerImpUrl.appendingPathComponent(moduleName+"RemoteDataManager").appendingPathExtension("swift")
        let interactorUrl           = interactorImpUrl.appendingPathComponent(moduleName+"Interactor").appendingPathExtension("swift")
        let presenterUrl            = presenterImpUrl.appendingPathComponent(moduleName+"Presenter").appendingPathExtension("swift")
        let routerUrl               = routerImpUrl.appendingPathComponent(moduleName+"Router").appendingPathExtension("swift")
        let viewControllerUrl       = viewControllerImpUrl.appendingPathComponent(moduleName+"ViewController").appendingPathExtension("swift")
        
        func fileComment(for module: String, type: String) -> String {
            let today       = Date()
            let calendar    = Calendar(identifier: .gregorian)
            let year        = String(calendar.component(.year, from: today))
            let month       = String(format: "%02d", calendar.component(.month, from: today))
            let day         = String(format: "%02d", calendar.component(.day, from: today))
            
            return """
            //
            //  \(module)\(type).swift
            //  \(projectName)
            //
            //  Created by \(userName) on \(day)/\(month)/\(year).
            //  Copyright © \(year) \(copyRights ?? userName). All rights reserved.
            //
            """
        }
        
        var interfaceInteractor = """
        \(fileComment(for: moduleName, type: "InteractorProtocol"))
        
        import Foundation
        
        protocol \(moduleName)InteractorProtocol {
        \tvar presenter: \(moduleName)PresenterProtocol? { get set }
        
        """
        if (localDataManagerIsNeeded) {
            interfaceInteractor.append("""
                \tvar localDataManager: \(moduleName)LocalDataManagerProtocol? { get set }
                \t
                """)
        }
        if (remoteDataManagerIsNeeded) {
            interfaceInteractor.append("""
                \tvar remoteDataManager: \(moduleName)RemoteDataManagerProtocol? { get set }
                \t
                """)
        }
        interfaceInteractor.append("""
        }
        """)
        
        
        let interfaceLocalDataManager = """
        \(fileComment(for: moduleName, type: "LocalDataManagerProtocol"))
        
        import Foundation
        
        protocol \(moduleName)LocalDataManagerProtocol: class {
        }
        """
        
        let interfacePresenter = """
        \(fileComment(for: moduleName, type: "PresenterProtocol"))
        
        import Foundation
        
        protocol \(moduleName)PresenterProtocol: class {
        \tvar router: \(moduleName)RouterProtocol? { get set }
        \tvar interactor: \(moduleName)InteractorProtocol? { get set }
        \tvar view: \(moduleName)ViewControllerProtocol? { get set }
        }
        """
        
        
        let interfaceRemoteDataManager = """
        \(fileComment(for: moduleName, type: "RemoteDataManagerProtocol"))
        
        import Foundation
        
        protocol \(moduleName)RemoteDataManagerProtocol: class {
        }
        """
        
        let interfaceRouter = """
        \(fileComment(for: moduleName, type: "RouterProtocol"))
        
        import Foundation
        
        protocol \(moduleName)RouterProtocol {
        \tvar presenter: \(moduleName)PresenterProtocol? { get set }
        }
        """
        
        let interfaceViewController = """
        \(fileComment(for: moduleName, type: "ViewControllerProtocol"))
        
        import Foundation
        
        protocol \(moduleName)ViewControllerProtocol: class {
        \tvar presenter: \(moduleName)PresenterProtocol? { get set }
        }
        """
        
        
        
        var defaultBuilder = """
        \(fileComment(for: moduleName, type: "Builder"))
        
        import Foundation
        import \(uiFramework)
        
        class \(moduleName)Builder {
        \tclass func create\(moduleName)Module() -> \(viewControllerType) {
        \t\tlet refTo\(moduleName)View = storyboard.\(instantiateUIControllerMethodName)(withIdentifier: "\(moduleName)ViewController") as? \(moduleName)ViewController
        \t\t
        \t\tlet presenter: \(moduleName)PresenterProtocol = \(moduleName)Presenter()
        \t\tlet router: \(moduleName)RouterProtocol = \(moduleName)Router()
        \t\tlet interactor: \(moduleName)InteractorProtocol = \(moduleName)Interactor()
        """
        if (localDataManagerIsNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tlet localDataManager: \(moduleName)LocalDataManagerProtocol = \(moduleName)LocalDataManager()
                \t
                """)
        }
        if (remoteDataManagerIsNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tlet remoteDataManager: \(moduleName)RemoteDataManagerProtocol = \(moduleName)RemoteDataManager()
                \t
                """)
        }
        defaultBuilder.append("""
            \t\t
            \t\trefTo\(moduleName)View?.presenter = presenter
            \t\tpresenter.view = refTo\(moduleName)View
            \t\tpresenter.view?.presenter = presenter
            \t\tpresenter.router = router
            \t\tpresenter.router?.presenter = presenter
            \t\tpresenter.interactor = interactor
            """)
        if (localDataManagerIsNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tpresenter.interactor?.localDataManager = localDataManager
                """)
        }
        if (remoteDataManagerIsNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tpresenter.interactor?.remoteDataManager = remoteDataManager
                """)
        }
        defaultBuilder.append("""
            \t\t
            \t\tpresenter.interactor?.presenter = presenter
            \t\t
            \t\treturn refTo\(moduleName)View!
            \t}
            \t
            \tstatic var storyboard: \(storyboardType) {
            \t\treturn \(storyboardType)(name:"Main",bundle: Bundle.main)
            \t}
            }
            """)
        
        let defaultLocalDataManagerUrl = """
        \(fileComment(for: moduleName, type: "LocalDataManager"))
        
        import Foundation
        
        class \(moduleName)LocalDataManager: \(moduleName)LocalDataManagerProtocol {
        \t
        }
        """
        
        let defaultRemoteDataManagerUrl = """
        \(fileComment(for: moduleName, type: "RemoteDataManager"))
        
        import Foundation
        
        class \(moduleName)RemoteDataManager: \(moduleName)RemoteDataManagerProtocol {
        \t
        }
        """
        
        var defaultInteractor = """
        \(fileComment(for: moduleName, type: "Interactor"))
        
        import Foundation
        
        class \(moduleName)Interactor: \(moduleName)InteractorProtocol {
        \tweak var presenter: \(moduleName)PresenterProtocol?
        """
        if (localDataManagerIsNeeded) {
            defaultInteractor.append("""
                \t
                \tvar localDataManager: \(moduleName)LocalDataManagerProtocol?
                """)
        }
        if (remoteDataManagerIsNeeded) {
            defaultInteractor.append("""
                \t
                \tvar remoteDataManager: \(moduleName)RemoteDataManagerProtocol?
                """)
        }
        defaultInteractor.append("""
        \t
        }
        """)
        
        let defaultPresenter = """
        \(fileComment(for: moduleName, type: "Presenter"))
        
        import Foundation
        
        class \(moduleName)Presenter: \(moduleName)PresenterProtocol {
        \tvar router: \(moduleName)RouterProtocol?
        \tvar interactor: \(moduleName)InteractorProtocol?
        \tweak var view: \(moduleName)ViewControllerProtocol?
        \t
        }
        """
        
        let defaultRouter = """
        \(fileComment(for: moduleName, type: "Router"))
        
        import Foundation
        import \(uiFramework)
        
        class \(moduleName)Router: \(moduleName)RouterProtocol {
        \tweak var presenter: \(moduleName)PresenterProtocol?
        \t
        }
        """
        
        let defaultViewController = """
        \(fileComment(for: moduleName, type: "ViewController"))
        
        import Foundation
        import \(uiFramework)
        
        class \(moduleName)ViewController: \(viewControllerType), \(moduleName)ViewControllerProtocol {
        \tvar presenter: \(moduleName)PresenterProtocol?
        \t
        }
        """
        
        do {
            var directoryPathUrlArray = [URL]()
            directoryPathUrlArray.append(moduleUrl)
            directoryPathUrlArray.append(builderImpUrl)
            if (oneOfDataManagerIsNeeded) {
                directoryPathUrlArray.append(dataManagerImpUrl)
            }
            directoryPathUrlArray.append(interactorImpUrl)
            directoryPathUrlArray.append(presenterImpUrl)
            directoryPathUrlArray.append(protocolsUrl)
            directoryPathUrlArray.append(routerImpUrl)
            directoryPathUrlArray.append(viewControllerImpUrl)
            
            try directoryPathUrlArray.forEach {
                try fileManager.createDirectory(at: $0, withIntermediateDirectories: true, attributes: nil)
            }
            try interfaceInteractor.write(to: protocolInteractorUrl, atomically: true, encoding: .utf8)
            if (localDataManagerIsNeeded) {
                try interfaceLocalDataManager.write(to: protocolLocalDataManagerUrl, atomically: true, encoding: .utf8)
            }
            try interfacePresenter.write(to: protocolPresenterUrl, atomically: true, encoding: .utf8)
            if (remoteDataManagerIsNeeded) {
                try interfaceRemoteDataManager.write(to: protocolRemoteDataManagerUrl, atomically: true, encoding: .utf8)
            }
            try interfaceRouter.write(to: protocolRouterUrl, atomically: true, encoding: .utf8)
            try interfaceViewController.write(to: protocolViewControllerUrl, atomically: true, encoding: .utf8)
            
            try defaultBuilder.write(to: builderUrl, atomically: true, encoding: .utf8)
            if (localDataManagerIsNeeded) {
                try defaultLocalDataManagerUrl.write(to: localDataManagerUrl, atomically: true, encoding: .utf8)
            }
            if (remoteDataManagerIsNeeded) {
                try defaultRemoteDataManagerUrl.write(to: remoteDataManagerUrl, atomically: true, encoding: .utf8)
            }
            try defaultBuilder.write(to: builderUrl, atomically: true, encoding: .utf8)
            try defaultInteractor.write(to: interactorUrl, atomically: true, encoding: .utf8)
            try defaultPresenter.write(to: presenterUrl, atomically: true, encoding: .utf8)
            try defaultRouter.write(to: routerUrl, atomically: true, encoding: .utf8)
            try defaultViewController.write(to: viewControllerUrl, atomically: true, encoding: .utf8)
            
            ConsoleOut.writeMessage("Files generated to: \(workUrl)", to: .standard)
        }
        catch {
            ConsoleOut.writeMessage(error.localizedDescription, to: .error)
        }
    }
}
