//
//  AppDelegate.swift
//  Focus Desktop
//
//  Created by Vitaliy Podolskiy on 04.06.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var appleScriptExecutor = AppleScriptExecutor()
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var hotKey: HotKey!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem.button?.action = #selector(self.statusBarButtonClicked(sender:))
        statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        hotKey = HotKey(key: .h, modifiers: [.command, .option])
        hotKey.keyDownHandler = {
            self.changeHideMode()
        }
        updateViews()
    }

    private func updateViews() {
        let status = updatedDesktopStatus()
        if status {
            statusBarItem.button?.image = NSImage(imageLiteralResourceName: "visible")
        }
        else {
            statusBarItem.button?.image = NSImage(imageLiteralResourceName: "hidden")
        }
    }

    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            NSApplication.shared.terminate(self)
        }
        else {
            changeHideMode()
        }
    }

    @discardableResult
    private func updatedDesktopStatus() -> Bool {
        let status = appleScriptExecutor.runScript(scriptName: "desktopStatus")
        return status.success
    }

    @objc private func changeHideMode() {
        let completion = AppleScriptExecutor().runScript(scriptName: "changeState")
        if completion.success {
            updateViews()
        }
    }

}
