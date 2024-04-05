//
//  Network.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case noneData
    case failDecode
    case noneUrlRequest
}

protocol BoxOfficeNetworkType {
    // 박스 오피스 데이터를 방출합니다.
    associatedtype movie = Movie
    
    static func fetchBoxOfficeData(date: String) -> Observable<movie>
}
/*
 API 호출
 "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=\(date)"
 
 */

class BoxOfficeNetwork: BoxOfficeNetworkType {
    
    private static let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt="
    
    private static let urlSession = URLSession.shared
    
    static func fetchBoxOfficeData(date: String) -> RxSwift.Observable<Movie> {
       
        // 1. Movie를 방출하는 Observable 을 생성하여 Return 하여야 함
        /*
         Observable.create { <#AnyObserver<_>#> in
             <#code#>
         }
         이때 어떠한 Observable이라는 의미의 AnyObserver 이 보이게 되는데
         */
        Observable.create { observable in
            
            // 1.1 url 생성
            guard let url = URL(string: urlString + date) else {
                observable.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            // 1.2 url 검사 를 동반한 요청
            urlSession.dataTask(with: url) {
                data, urlRequst, error in
                
                // 1.2.1 에러 가 존재? 그럼 에러지
                if error != nil {
                    observable.onError(APIError.unknownResponse)
                    return
                }
                // 1.2.2 데이터가 없어? 에러지
                guard let data else {
                    observable.onError(APIError.noneData)
                    return
                }
                // 1.2.3 요청Url 없다고? Error
                guard let urlRequst else {
                    observable.onError(APIError.noneUrlRequest)
                    return
                }
                // 1.2.4 200...299 에 포함되지 않아? Error
                guard let urlReqeust = urlRequst as? HTTPURLResponse,
                      (200...299)
                    .contains(urlReqeust.statusCode) else {
                    observable.onError(APIError.statusError)
                    return
                }
                // 1.2.5 Decode 실패? 에러야~
                do {
                    let result = try JSONDecoder().decode(Movie.self, from: data)
                    observable.onNext(result)
                    observable.onCompleted()
                } catch {
                    observable.onError(APIError.failDecode)
                    return
                }
            }.resume()
            // 1.3 까먹지 말고 디스포서블 반환
            return Disposables.create()
        }.debug().debug("API: State\n")
        
    }
    
    
}
