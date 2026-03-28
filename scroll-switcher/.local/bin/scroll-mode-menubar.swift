#!/usr/bin/env swift
//
// scroll-mode-menubar.swift
//
// Tiny macOS menu-bar indicator for the current scroll mode.
// Reads a state file written by scroll-direction-switcher.sh and also
// queries the actual system natural-scroll setting via `defaults read`
// each refresh.  The menubar icon reflects the actual system setting
// (source of truth), and the dropdown shows both detected mode and
// actual natural-scroll status.
//

import AppKit
import Foundation

class ScrollModeMenuBar: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private let stateFilePath: String
    private let debugLogPath = "/tmp/scroll-mode-menubar.debug.log"

    private func debugLog(_ msg: String) {
        let line = "\(Date()) \(msg)\n"
        if let data = line.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: debugLogPath) {
                if let handle = FileHandle(forWritingAtPath: debugLogPath) {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    try? handle.close()
                }
            } else {
                try? data.write(to: URL(fileURLWithPath: debugLogPath))
            }
        }
    }

    override init() {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        self.stateFilePath = "\(home)/.local/state/scroll-mode.state"
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        debugLog("applicationDidFinishLaunching")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        debugLog("statusItem created; button nil? \(statusItem.button == nil)")

        // Build the menu
        let menu = NSMenu()

        let modeItem = NSMenuItem(title: "Mode: unknown", action: nil, keyEquivalent: "")
        modeItem.tag = 1
        modeItem.isEnabled = false
        menu.addItem(modeItem)

        let naturalItem = NSMenuItem(title: "Natural scroll: unknown", action: nil, keyEquivalent: "")
        naturalItem.tag = 2
        naturalItem.isEnabled = false
        menu.addItem(naturalItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu

        // Initial update
        debugLog("before initial updateDisplay")
        updateDisplay()

        // Poll every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateDisplay()
        }
    }

    private func readState() -> String? {
        guard FileManager.default.fileExists(atPath: stateFilePath) else {
            return nil
        }
        return try? String(contentsOfFile: stateFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Query the actual macOS natural-scroll setting via UserDefaults.
    /// Returns true (natural ON), false (natural OFF), or nil (unknown/error).
    private func readSystemNaturalScroll() -> Bool? {
        let defaults = UserDefaults.standard
        let key = "com.apple.swipescrolldirection"
        guard defaults.object(forKey: key) != nil else { return nil }
        return defaults.bool(forKey: key)
    }

    private func updateDisplay() {
        debugLog("updateDisplay start")
        let state = readState()
        let naturalScroll = readSystemNaturalScroll()

        // --- Icon: based on actual system setting (source of truth) ---
        let icon: String
        switch naturalScroll {
        case true:
            icon = "🍃"   // natural ON → trackpad-style
        case false:
            icon = "📜"   // natural OFF → mouse-style
        default:
            icon = "??"
        }
        if let button = statusItem.button {
            button.title = icon
            debugLog("set icon=\(icon), state=\(state ?? "nil"), natural=\(String(describing: naturalScroll)), buttonExists=true")
        } else {
            debugLog("failed to set icon: buttonExists=false")
        }

        // --- Menu line 1: detected device mode from state file ---
        let modeText: String
        switch state {
        case "mouse":
            modeText = "Using mouse"
        case "trackpad":
            modeText = "Using trackpad"
        default:
            modeText = "Unknown device"
        }
        if let modeItem = statusItem.menu?.item(withTag: 1) {
            modeItem.title = modeText
        }

        // --- Menu line 2: actual natural-scroll system setting ---
        let naturalText: String
        switch naturalScroll {
        case true:
            naturalText = "Natural scroll: On"
        case false:
            naturalText = "Natural scroll: Off"
        default:
            naturalText = "Natural scroll: Unknown"
        }
        if let naturalItem = statusItem.menu?.item(withTag: 2) {
            naturalItem.title = naturalText
        }
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

// --- Entry point ---

let app = NSApplication.shared
app.setActivationPolicy(.accessory)   // register as a menu-bar-only (accessory) app
let delegate = ScrollModeMenuBar()
app.delegate = delegate
app.run()
