//
//  StoryDetails.swift
//  SwipeStories
//
//  Created by Mayur Susare on 02/06/21.
//

import Foundation

struct StoryDetails {
    var name: String = ""
    var imageUrl: String = ""
    var content: [Content] = []
    
    init(userDetails: [String: Any]) {
        name = userDetails["name"] as? String ?? ""
        imageUrl = userDetails["imageUrl"] as? String ?? ""
        let aContent = userDetails["content"] as? [[String : Any]] ?? []
        for element in aContent {
            content += [Content(element: element)]
        }
    }
}

struct Content {
    var type: String
    var url: String
    init(element: [String: Any]) {
        type = element["type"] as? String ?? ""
        url = element["url"] as? String ?? ""
    }
}
