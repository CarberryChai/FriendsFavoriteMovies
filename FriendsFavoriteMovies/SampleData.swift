//
//  SampleData.swift
//  FriendsFavoriteMovies
//
//  Created by changlin on 2024/5/9.
//

import Foundation
import SwiftData

@MainActor
final class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    var movie: Movie {
        Movie.sampleData.randomElement()!
    }

    var friend: Friend {
        Friend.sampleData.randomElement()!
    }

    private init() {
        let schema = Schema([
            Movie.self,
            Friend.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertSampleData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    func insertSampleData(){
        for movie in Movie.sampleData {
            context.insert(movie)
        }

        for friend in Friend.sampleData {
            context.insert(friend)
        }

        Friend.sampleData[0].favoriteMovie = Movie.sampleData[1]
        Friend.sampleData[2].favoriteMovie = Movie.sampleData[0]
        Friend.sampleData[3].favoriteMovie = Movie.sampleData[4]
        Friend.sampleData[4].favoriteMovie = Movie.sampleData[0]

        do {
            try context.save()
        } catch {
            print("Sample Data context failed to save: \(error.localizedDescription)")
        }
    }
}
