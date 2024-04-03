//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa


struct UserModel {
    var title: String
    var starBool : Bool
    var selectedBool : Bool
    var uuid = UUID()
    
    init(title: String, selectedBool: Bool, starBool: Bool? = false) {
        self.title = title
        self.starBool = starBool ?? false
        self.selectedBool = selectedBool
    }
}

class ShoppingViewModel: ViewModelType {
    
    var data = [
        UserModel(
            title: "안녕하세요",
            selectedBool: false
        ),
        UserModel(
            title: "반갑습니다.",
            selectedBool: false
        ),
        UserModel(
            title: "안녕하세요",
            selectedBool: false
        ),
        UserModel(
            title: "반갑습니다.",
            selectedBool: false
        ),
    ]
    
    let disposeBag: DisposeBag
    
    lazy var dummyData = BehaviorSubject(value: data)

    
    init(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    struct Input {
        let textField : ControlProperty<String?>
        let addButton: ControlEvent<Void>
        
        //  let TableViewCellClicked: ControlProperty
        
    }
    
    struct Output {
     
        // 테이블뷰 셀 아앗풋
        let outputData: Observable<[UserModel]>
        
    }
    
    func proceccing(_ input: Input) -> Output {
        print("proceccing")
        
        // 텍스트 필터링
        input.textField
            .orEmpty
            .debounce(
                .milliseconds(300),
                scheduler: MainScheduler.instance
            )
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, string in
                print("textField 바인딩")
                let result = string.isEmpty ? owner.data : owner.data.filter { $0.title.contains(string) }
                print("textField 바인딩 \(result)")
                owner.dummyData.onNext(result)
            }, onCompleted: { _ in
                print("complite : ")
            })
            .disposed(by: disposeBag)
        
        input.addButton.withLatestFrom(
            input.textField.orEmpty
        )
        .bind(with: self) {
            owner, string in
            print(owner.data)
        
            owner.data.append(UserModel(title: string, selectedBool: false))
            
            input.textField.onNext("")
            owner.dummyData.onNext(owner.data)
            
        }.disposed(by: disposeBag)
        
        return Output(outputData: dummyData.asObservable())
    }
    
}
