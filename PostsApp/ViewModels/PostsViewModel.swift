//
//  PostsViewModel.swift
//  PostsApp
//
//  Created by Andrew Reyna on 7/18/26.
//

import Foundation
import Combine

// Stores the app's data and controls the screen state.
@MainActor
final class PostsViewModel: ObservableObject {

    // Posts returned by the API.
    @Published private(set) var posts: [Post] = []

    // Controls the loading indicator.
    @Published private(set) var isLoading = false

    // Stores an error message when something fails.
    @Published private(set) var errorMessage = ""

    private let postService = PostService()

    // Asks PostService to fetch all posts.
    func fetchPosts() async {

        // Prevent multiple requests from running at the same time.
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = ""

        // Always stop the loading indicator when this function ends.
        defer {
            isLoading = false
        }

        do {
            posts = try await postService.fetchPosts()
        } catch {
            posts = []
            errorMessage = error.localizedDescription
        }
    }
}
