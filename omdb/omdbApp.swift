//
//  omdbApp.swift
//  omdb
//
//  Created by Osvaldo Mercado on 28/11/24.
//

import SwiftUI

@main
struct omdbApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MovieList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
