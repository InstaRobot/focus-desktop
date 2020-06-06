//
//  ScriptLauncher.swift
//  Focus Desktop
//
//  Created by Vitaliy Podolskiy on 04.06.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import Foundation

struct AppleScriptExecutor {
    
    @discardableResult
    func runScript(scriptName: String?, keyParams: [String: String] = [:], bundle: Bundle = Bundle.main) -> (success: Bool, error: NSDictionary?) {
        guard
            let scriptFilePath = bundle.path(forResource: scriptName, ofType: "scpt") else {
            return (false, nil)
        }
        var contentOfFile = try? String(contentsOfFile: scriptFilePath)
        keyParams.forEach { (param) in
           contentOfFile = contentOfFile?.replacingOccurrences(of: param.key, with: param.value)
        }
        guard
            let appleScript = contentOfFile else {
            return (false, nil)
        }
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: appleScript) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                &error)
            if error == nil {
                return (output.booleanValue, nil)
            }
            else {
                return (false, error)
            }
        }
        return (false, error)
    }

}
