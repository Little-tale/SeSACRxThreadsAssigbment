//
//  OfAsyncSubject.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class OfAsyncSubject: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let asyncSubject = AsyncSubject<Int> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asyncSubject.onNext(100)
        asyncSubject.onNext(200)
        asyncSubject.onNext(300)
        asyncSubject.onNext(400)
        asyncSubject.onNext(500)
        
        
        asyncSubject
            .bind { int in
                print(int)
            }.disposed(by: disposeBag)
        
        asyncSubject.onNext(600)
        asyncSubject.onNext(700)
        asyncSubject.onNext(800) // 이것만...?
        
        asyncSubject.onCompleted()
        asyncSubject.onNext(900)
        asyncSubject.onNext(1000)
        asyncSubject.onNext(11111100)
        
        /*
         800
         */
        
    }
    
    
    
    
    
}
