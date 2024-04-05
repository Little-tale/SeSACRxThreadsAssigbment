//
//  Movie.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Decodable {
    let movieNm, openDt: String
    
    
    enum CodingKeys: CodingKey {
        case movieNm
        case openDt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.movieNm = try container.decode(String.self, forKey: .movieNm)
        self.openDt = try container.decode(String.self, forKey: .openDt)
    }
}
