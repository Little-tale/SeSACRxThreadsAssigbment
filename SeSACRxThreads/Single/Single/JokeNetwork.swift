//
//  JokeNetwork.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import Foundation
import Alamofire
import RxSwift


protocol NeworkService {
    // fetch : 무조건 가능
    // request : 실패 사유 존재
    
    // MARK: 1. Observable 방식
    func requestJoke() -> Observable<Joke>
    
    // MARK: 2. Single 방식
    func requestSingleJoke() -> Single<Joke>
    
    // MARK: 3. Observable <Result<T>> 방식
    func requestResultJoke() -> Observable<Result<Joke,APIError>>
    
    // MARK: 4. Single <Result<T>> 방식
    func requsetResultSingleJoke() -> Single<Result<Joke,APIError>>
}

final class Network: NeworkService {
   
    //static let baseUrl = "https://v2.jokeapi.dev/joke/Programming?type=single"
    static let shared = Network()
    private init() {}
    
    enum BaseUrl {
        case joke
        
        var getUrl: URL {
            switch self {
                
            case .joke:
                URL(string: "https://v2.jokeapi.dev/joke/Programming?type=single")!
            }
        }
    }
    
    // MARK: 1. Observable 방식
    /// 일반적인 옵저버블 방식입니다.
    func requestJoke() -> RxSwift.Observable<Joke> {
        return Observable
            .create { [weak self] observable in
                guard let self else {
                    observable.onError(APIError.unknownResponse)
                    return Disposables.create()
                }
            requestOfJoke { response in
                switch response.result {
                case .success(let joke) :
                    observable.onNext(joke)
                    observable.onCompleted()
                case .failure(let failer) :
                    observable.onError(APIError.invalidURL)
                }
            }
            return Disposables.create()
        }
    }
    // MARK: 2. Single 방식
    func requestSingleJoke() -> RxSwift.Single<Joke> {
        return Single
            .create { [weak self] observable in
                guard let self else {
                    observable(.failure(APIError.unknownResponse))
                    return Disposables.create()
                }
            requestOfJoke { response in
                switch response.result {
                case .success(let joke) :
                    observable(.success(joke))
                case .failure(let failer) :
                    observable(.failure(APIError.unknownResponse))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: 3. Observable <Result<T>> 방식
    /// 해당 메서드는 상위 스트림의 구독을 해제 하지 않습니다. 에러 처리는 필수입니다.
    func requestResultJoke() -> RxSwift.Observable<Result<Joke, APIError>> {
        return Observable
            .create { [weak self] observable in
                guard let self else {
                    //observable.onError(APIError.unknownResponse)
                    observable.onNext(.failure(.unknownResponse))
                    return Disposables.create()
                }
            requestOfJoke { response in
                switch response.result {
                case .success(let joke) :
                    // observable.onNext(joke)
                    observable.onNext(.success(joke))
                    observable.onCompleted()
                case .failure(let failer) :
                    // observable.onError(APIError.invalidURL)
                    observable.onNext(.failure(.failDecode))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: 4. Single <Result<T>> 방식
    /// 해당 메서드는 Single Result 방식으로 상위 스트림을 무너뜨리지 않습니다.
    func requsetResultSingleJoke() -> RxSwift.Single<Result<Joke, APIError>> {
        return Single
            .create { [weak self] observable in
                guard let self else {
                    // observable(.failure(APIError.unknownResponse))
                    observable(.success(.failure(.unknownResponse)))
                    return Disposables.create()
                }
            requestOfJoke { response in
                switch response.result {
                case .success(let joke) :
                    // observable(.success(joke))
                    observable(.success(.success(joke)))
                case .failure(let failer) :
                    // observable(.failure(APIError.unknownResponse))
                    observable(.success(.failure(.unknownResponse)))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: 코드 남발 방지
    private func requestOfJoke( handler: @escaping ((DataResponse<Joke, AFError>) -> Void) ){
        
        AF.request(BaseUrl.joke.getUrl)
            .validate(statusCode: 200...299)
            .responseDecodable(of: Joke.self) { responce in
                handler(responce)
            }
    }
    
}
