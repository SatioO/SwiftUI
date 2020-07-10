//
//  ContentView.swift
//  Wonders
//
//  Created by Brain on 7/9/20.
//  Copyright © 2020 Brain. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true;
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webview = WKWebView(frame: CGRect.zero, configuration: configuration)
        webview.allowsBackForwardNavigationGestures = true
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct Post: Codable, Identifiable {
    let id = UUID()
    var title: String
    var body: String
}

class PostActions {
    func getPosts(callback: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            
            DispatchQueue.main.async {
                callback(posts)
            }
        }.resume()
    }
}

struct ContentView: View {
    @State private var posts: [Post] = []
    
    var body: some View {
        List {
            ForEach(posts, id: \.id) { post in
                Text(post.title)
            }
        }
        .onAppear {
            PostActions().getPosts { (posts) in
                self.posts = posts
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
