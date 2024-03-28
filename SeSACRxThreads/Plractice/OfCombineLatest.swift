//
//  ofCombineLatest.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class OfCombineLatest: UIViewController {
    let disposedBag = DisposeBag()
    let numberObservable = PublishSubject<Int> ()
    let stringObservable = PublishSubject<String> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CombineLatest
        let combine = Observable.combineLatest(numberObservable, stringObservable) { number, string  -> String in
            return ( "\(number) + \(string)")
        }
        
        combine.subscribe { string in
            print (string)
        }.disposed(by: disposedBag)
        
        numberObservable.onNext(1)
        numberObservable.onNext(2)
        numberObservable.onNext(3)
        numberObservable.onNext(4)
        
        stringObservable.onNext("1")
        numberObservable.onNext(5)
        stringObservable.onNext("2")
        /*
         next(4 + 1)
         next(5 + 1)
         next(5 + 2)
         */
    }
    
    
    
}
