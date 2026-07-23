//
//  Post.swift
//  PostsApp
//
//  Created by Andrew Reyna on 7/18/26.
//

import Foundation

// Represents one post returned by the JSONPlaceholder API.
struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
