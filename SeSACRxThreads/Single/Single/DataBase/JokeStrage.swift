//
//  File.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/8/24.
//

import Foundation
import RxSwift

protocol JokeStorageType {
    
    @discardableResult
    func insert(_ data: Joke) -> Observable<Joke>
    
    @discardableResult
    func read() -> Observable<[Joke]>
    
}

final class JokeStorage: JokeStorageType {
    
    var jokes: [Joke] = []
    
    @discardableResult
    func insert(_ data: Joke) -> RxSwift.Observable<Joke> {
        jokes.append(data)
        return Observable.just(data)
    }
    
    @discardableResult
    func read() -> RxSwift.Observable<[Joke]> {
        return Observable.just(jokes)
    }
    
}
