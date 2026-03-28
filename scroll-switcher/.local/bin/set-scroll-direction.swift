#!/usr/bin/env swift
// set-scroll-direction.swift
// Usage: swift set-scroll-direction.swift true|false
// Calls the private CGSSetSwipeScrollDirection to immediately change scroll direction,
// updates the preference, and posts the notification.

import Foundation

// Private CoreGraphics functions
@_silgen_name("_CGSDefaultConnection")
func _CGSDefaultConnection() -> Int32

@_silgen_name("CGSSetSwipeScrollDirection")
func CGSSetSwipeScrollDirection(_ cid: Int32, _ dir: Bool)

guard CommandLine.arguments.count == 2 else {
    fputs("Usage: set-scroll-direction true|false\n", stderr)
    exit(1)
}

let natural = CommandLine.arguments[1] == "true"

// 1. Actually change scroll direction in the window server (takes effect immediately)
let conn = _CGSDefaultConnection()
CGSSetSwipeScrollDirection(conn, natural)

// 2. Update the preference file so it persists across reboots
CFPreferencesSetAppValue(
    "com.apple.swipescrolldirection" as CFString,
    natural as CFBoolean,
    kCFPreferencesAnyApplication
)
CFPreferencesAppSynchronize(kCFPreferencesAnyApplication)

// 3. Post notification so System Settings UI updates if open
DistributedNotificationCenter.default().postNotificationName(
    NSNotification.Name("SwipeScrollDirectionDidChangeNotification"),
    object: nil
)
