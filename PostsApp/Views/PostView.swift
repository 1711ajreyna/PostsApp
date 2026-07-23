//
//  PostView.swift
//  PostsApp
//
//  Created by Andrew Reyna on 7/20/26.
//

import SwiftUI

struct PostsView: View {

    @StateObject private var viewModel = PostsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView

                } else if !viewModel.errorMessage.isEmpty {
                    errorView

                } else {
                    postsList
                }
            }
            .navigationTitle("Posts")
            .task {
                await viewModel.fetchPosts()
            }
        }
    }

    // Displays a progress indicator during the request.
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()

            Text("Loading posts...")
                .foregroundStyle(.secondary)
        }
    }

    // Displays the posts returned by the API.
    private var postsList: some View {
        List(viewModel.posts) { post in
            VStack(alignment: .leading, spacing: 10) {

                Text(post.title.capitalized)
                    .font(.headline)

                Text(post.body)
                    .font(.body)
                    .foregroundStyle(.secondary)

                Divider()

                HStack {
                    Label(
                        "Post \(post.id)",
                        systemImage: "doc.text"
                    )

                    Spacer()

                    Label(
                        "User \(post.userId)",
                        systemImage: "person"
                    )
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchPosts()
        }
    }

    // Displays an error and allows the user to retry.
    private var errorView: some View {
        VStack(spacing: 16) {

            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)

            Text("Unable to Load Posts")
                .font(.title2)
                .bold()

            Text(viewModel.errorMessage)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task {
                    await viewModel.fetchPosts()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    PostsView()
}
