//
//  Joke.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import Foundation

struct Joke: Codable {
    let error: Bool
    let category, type, joke: String
    let id: Int
    let safe: Bool
    let lang: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(Bool.self, forKey: .error)
        self.category = try container.decode(String.self, forKey: .category)
        self.type = try container.decode(String.self, forKey: .type)
        self.joke = try container.decode(String.self, forKey: .joke)
        self.id = try container.decode(Int.self, forKey: .id)
        self.safe = try container.decode(Bool.self, forKey: .safe)
        self.lang = try container.decode(String.self, forKey: .lang)
    }
}
