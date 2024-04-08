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
    
    static let shared = JokeStorage()
    
    private init() {}
    
    var jokes: [Joke] = []
    lazy var behiver =  BehaviorSubject<[Joke]> (value: jokes)
    
    @discardableResult
    func insert(_ data: Joke) -> RxSwift.Observable<Joke> {
        jokes.append(data)
        behiver.onNext(jokes)
        return Observable.just(data)
    }
    
    @discardableResult
    func read() -> RxSwift.Observable<[Joke]> {
        return behiver
    }
    
}
