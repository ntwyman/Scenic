//
//  ScenicApp.swift
//  Scenic
//
//  Created by Nick Twyman on 1/22/24.
//

import SwiftUI

@main
struct ScenicApp: App {
    let model = ScenicModel(rangeX: -10...10, rangeY: -10...10)

    var body: some Scene {
        WindowGroup {
            ContentView().environment(model)
        }
    }
}
