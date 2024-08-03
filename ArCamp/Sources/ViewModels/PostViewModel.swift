//
//  PostCardView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 08.07.24.
//

import Foundation

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        loadPosts()
    }
    
    func loadPosts() {
        guard let url = Bundle.main.url(forResource: "posts", withExtension: "json") else {
            print("Failed to locate posts.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let postsData = try decoder.decode(Posts.self, from: data)
            self.posts = postsData.posts
        } catch {
            print("Error loading JSON: \(error)")
        }
    }
}
