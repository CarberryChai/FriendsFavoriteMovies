//
//  FilteredMovieList.swift
//  FriendsFavoriteMovies
//
//  Created by changlin on 2024/5/11.
//

import SwiftData
import SwiftUI

struct FilteredMovieList: View {
    @State private var searchText = ""
    @State private var isSortedByTitle = true

    var movieSortDesc: SortDescriptor<Movie> {
        isSortedByTitle ? SortDescriptor(\Movie.title) : SortDescriptor(\Movie.releaseDate)
    }
    var body: some View {
        NavigationSplitView {
            Toggle("Sort By \(isSortedByTitle ? "Title" : "Release Date")", isOn: $isSortedByTitle)
                .padding(.horizontal)
            MovieList(titleFilter: searchText, sortDesc: movieSortDesc)
                .searchable(text: $searchText)
        } detail: {
            Text("Select a movie")
                .navigationTitle("Movie")
        }
    }
}

#Preview {
    FilteredMovieList()
        .modelContainer(SampleData.shared.modelContainer)
}
