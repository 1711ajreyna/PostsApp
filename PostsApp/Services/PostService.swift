//
//  PostService.swift
//  PostsApp
//
//  Created by Andrew Reyna on 7/10/26.
//

import Foundation

// Possible errors that may occur during the API request.
enum PostServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .requestFailed(let statusCode):
            return "The request failed with status code \(statusCode)."

        case .decodingFailed:
            return "The post data could not be decoded."
        }
    }
}

// Handles communication with the JSONPlaceholder API.
struct PostService {

    private let endpoint =
        "https://jsonplaceholder.typicode.com/posts"

    // Fetches and decodes all posts from the API.
    func fetchPosts() async throws -> [Post] {

        guard let url = URL(string: endpoint) else {
            throw PostServiceError.invalidURL
        }

        // Perform the GET request.
        let (data, response) =
            try await URLSession.shared.data(from: url)

        // Make sure the response is an HTTP response.
        guard let httpResponse =
                response as? HTTPURLResponse else {
            throw PostServiceError.invalidResponse
        }

        // Confirm the HTTP request succeeded.
        guard (200...299).contains(httpResponse.statusCode) else {
            throw PostServiceError.requestFailed(
                statusCode: httpResponse.statusCode
            )
        }

        do {
            // The API returns an array, so decode [Post].
            return try JSONDecoder().decode(
                [Post].self,
                from: data
            )
        } catch {
            throw PostServiceError.decodingFailed
        }
    }
}
