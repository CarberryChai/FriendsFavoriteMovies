//
//  FriendList.swift
//  FriendsFavoriteMovies
//
//  Created by changlin on 2024/5/10.
//

import SwiftData
import SwiftUI

struct FriendList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var friends: [Friend]
    @State private var newFriend: Friend?

    init(nameFilter: String = "") {
        let predicate = #Predicate<Friend> { friend in
            nameFilter.isEmpty || friend.name.localizedStandardContains(nameFilter)
        }
        _friends = Query(filter: predicate, sort: \.name)
    }

    var body: some View {
        Group {
            if friends.isEmpty {
                ContentUnavailableView {
                    Label("No Friends", systemImage: "person.and.person")
                }
            } else {
                List {
                    ForEach(friends) { friend in
                        NavigationLink {
                            FriendDetail(friend: friend)
                        } label: {
                            Text(friend.name)
                        }
                    }
                    .onDelete(perform: deleteFriends)
                }
            }
        }
        .navigationTitle("Friends")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }

            ToolbarItem {
                Button(action: addFriend) {
                    Label("Add Friend", systemImage: "plus")
                }
            }
        }
        .sheet(item: $newFriend) { friend in
            NavigationStack {
                FriendDetail(friend: friend, isNew: true)
            }
            .interactiveDismissDisabled()
        }
    }

    private func addFriend() {
        withAnimation {
            let item = Friend (name: "")
            modelContext.insert(item)
            newFriend = item
        }
    }

    private func deleteFriends(offsets: IndexSet) {
        withAnimation {
            for offset in offsets {
                modelContext.delete(friends[offset])
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendList()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Filtered") {
    NavigationStack {
        FriendList(nameFilter: "")
            .modelContainer(SampleData.shared.modelContainer)
    }
}
