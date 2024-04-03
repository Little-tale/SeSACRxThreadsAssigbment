//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa


struct UserModel: Equatable {
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
            title: "안녕하세요1",
            selectedBool: true
        ),
        UserModel(
            title: "반갑습니다.1",
            selectedBool: false
        ),
        UserModel(
            title: "안녕하세요2",
            selectedBool: true
        ),
        UserModel(
            title: "반갑습니다.2",
            selectedBool: false
        ),
    ]
    
    let disposeBag: DisposeBag
    
    lazy var dummyData = BehaviorSubject(value: data)
    
    // 이게 좋은 구조인지는 모르겠으나 이렇게 한번 접근
    
    
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


extension ShoppingViewModel: ShoppingTableCellViewModelDelegate {
    
    func modelChaged(_ model: UserModel) {
        print(model.selectedBool)
//        if let findmodel = data.filter({ $0.uuid == model.uuid }).first {
//            dump(findmodel)
//        }
        if let findIndex = data.firstIndex(where: { $0.uuid == model.uuid }) {
            print(findIndex)
            if data[findIndex] != model {
                data[findIndex] = model
                // dump(data[findIndex]) // 여기까진 매우 순조롭다.
                dummyData.onNext(data)
            }
        }
    }
}

// 1. 문제는 해결 이제 다른 버튼이 켜저 보이는 현상을 확인해야해
// 문제는 해당하는 코드에서 발생하는 문제
// test 메서드를 통해 문제의 원인과
// 어떻게 해야 이같은 상황을 해결해 나갈수 있을지 연구해보자
// 1. take 1 을 해준다 -> 실패
// 2. 스로틀을 준다 -> 실패
// 3. 스로틀이 실패니 당연히 디바운스도 안될것 같아 패스\
// 4.
