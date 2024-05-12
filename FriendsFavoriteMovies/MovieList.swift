//
//  MovieList.swift
//  FriendsFavoriteMovies
//
//  Created by changlin on 2024/5/9.
//

import SwiftData
import SwiftUI

struct MovieList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var movies: [Movie]
    @State private var newMovie: Movie?

    init(titleFilter: String = "", sortDesc: SortDescriptor<Movie> = .init(\Movie.title)) {
        let predicate = #Predicate<Movie> { movie in
            titleFilter.isEmpty || movie.title.localizedStandardContains(titleFilter)
        }
        _movies = Query(filter: predicate, sort: [sortDesc])
    }

    var body: some View {
        Group {
            if movies.isEmpty {
                ContentUnavailableView {
                    Label("No Movies", systemImage: "film.stack")
                }
            } else {
                List {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetail(movie: movie)
                        } label: {
                            Text(movie.title)
                        }
                    }
                    .onDelete(perform: deleteMovies)
                }
            }
        }
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addMovie) {
                    Label("Add Movie", systemImage: "plus")
                }
            }
        }
        .sheet(item: $newMovie) { movie in
            NavigationStack {
                MovieDetail(movie: movie, isNew: true)
            }
            .interactiveDismissDisabled()
        }
    }

    private func addMovie() {
        withAnimation {
            let newItem = Movie(title: "", releaseDate: .now)
            modelContext.insert(newItem)
            newMovie = newItem
        }
    }

    private func deleteMovies(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(movies[index])
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieList()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("No Movies") {
    NavigationStack {
        MovieList()
            .modelContainer(for: Movie.self, inMemory: true)
    }
}

#Preview("Filtered") {
    NavigationStack {
        MovieList(titleFilter: "")
            .modelContainer(SampleData.shared.modelContainer)
    }
}
