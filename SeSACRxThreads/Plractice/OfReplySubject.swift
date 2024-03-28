//
//  OfReplySubject.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class OfReplySubject: UIViewController {
    let disposeBag = DisposeBag()
    let replay = ReplaySubject<Int>.create(bufferSize: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay.bind { int in
            print(int)
        }.disposed(by: disposeBag)
        /*
         400
         500
         */
        
        replay.onNext(1)
        replay.onNext(2)
        replay.on(.next(3))
        replay.on(.next(4))
        replay.on(.next(5))
    
        /*
         1
         2
         3
         4
         5
         */
//        
        replay.onNext(10)
        replay.onNext(20)
        replay.onNext(30)
        replay.onNext(40)
        
        replay.onCompleted()
        
        replay.onNext(50)
        
        /*
         10
         20
         30
         40

         */
        
    }
    
    
}
