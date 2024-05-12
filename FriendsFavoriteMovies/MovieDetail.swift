//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by changlin on 2024/5/10.
//

import SwiftUI

struct MovieDetail: View {
    @Bindable var movie: Movie
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let isNew: Bool

    init(movie: Movie, isNew: Bool = false) {
        self.movie = movie
        self.isNew = isNew
    }

    private var sortedFriends: [Friend] {
        movie.favoritedBy.sorted { $0.name < $1.name }
    }

    var body: some View {
        Form {
            TextField("Movie Titlep", text: $movie.title)
            DatePicker("Release Date", selection: $movie.releaseDate, displayedComponents: .date)

            if !movie.favoritedBy.isEmpty {
                Section("Favorited By") {
                    ForEach(sortedFriends) { friend in
                        Text(friend.name)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            movie.favoritedBy.remove(at: index)
                        }
                    })
                }
            }
        }
        .navigationTitle(isNew ? "New Movie" : "Movie")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(movie)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetail(movie: SampleData.shared.movie)
    }
    .modelContainer(SampleData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        MovieDetail(movie: SampleData.shared.movie, isNew: true)
    }
    .modelContainer(SampleData.shared.modelContainer)
}
