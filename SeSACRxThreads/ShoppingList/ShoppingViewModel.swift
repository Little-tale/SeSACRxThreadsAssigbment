//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel: ViewModelType {
    
    var data = ["무엇을 구매","나를 구해","너는 구해","구해줘요!"]
    
    let disposeBag: DisposeBag
    
    lazy var dummyData = BehaviorSubject(value: data)
    
    init(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    struct Input {
        let textField : ControlProperty<String?>
        let addButton: ControlEvent<Void>
        
    }
    
    struct Output {
     
        // 테이블뷰 셀 아앗풋
        let outputData: Observable<[String]>
    }
    
    func proceccing(_ input: Input) -> Output {
        print("proceccing")
        
        input.addButton.withLatestFrom(input.textField.orEmpty).bind(with: self) { owner, string in
            owner.data.append(string)
            input.textField.onNext("")
        }.disposed(by: disposeBag)
        
        // 텍스트 필터링
        input.textField
            .orEmpty
            .debounce(
                .milliseconds(300),
                scheduler: MainScheduler.instance
            )
            .distinctUntilChanged()
            .bind(with: self) { owner, string in
                let result = string.isEmpty ? owner.data : owner.data.filter { $0.contains(string) }
                owner.dummyData.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
        
        
        return Output(outputData: dummyData)
    }
}