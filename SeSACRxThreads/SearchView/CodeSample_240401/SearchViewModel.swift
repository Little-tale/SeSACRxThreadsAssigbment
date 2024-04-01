//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    lazy var dataList = BehaviorSubject(value: data )
    
    struct Input {
        // 테이블 뷰 선택 -> 지우기
        let tableViewSelected: ControlEvent<IndexPath>
        
        // 설치바 텍스트 -> 필터
        let searchTextIn: ControlProperty<String?>
        
        // 설치바 클릭 -> 필터
        let searchTextEvent: ControlEvent<Void>
        
    }
    
    let disPoseBag: DisposeBag
    struct Output {
        // 셀을 그릴수있게 유도해야됨
        let validCellData: Observable<[String]>
        // let searchTextData: Observable<
    }
    
    init(_ disposeBag: DisposeBag){
        self.disPoseBag = disposeBag
        
    }
    
    func proceccing(_ input: Input) -> Output {
        
        // 삭제 로직
        input.tableViewSelected.subscribe(with: self) { owner, indexPath in
//            var data = owner.data
            owner.data.remove(at: indexPath.row)
            owner.dataList.onNext(owner.data)
            print(owner.dataList)
        }.disposed(by: disPoseBag)
        
        // MARK: 물어보기
        // 필터 로직
        let searchText = input.searchTextIn
            .orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
             
        let searchTab = input.searchTextEvent.withLatestFrom(input.searchTextIn.orEmpty.distinctUntilChanged())
        
        Observable.merge(searchText,searchTab)
            .subscribe(with: self) { owner, value in
            let result = value.isEmpty ? owner.data : owner.data.filter({ $0.contains(value) })
            owner.dataList.onNext(result)
            print(result)
        }.disposed(by: disPoseBag)
        
        let data = dataList
        return Output(validCellData: data)
    }
}


/*
 owner, value in
     let result = value.isEmpty ? owner.data : owner.data.filter({ $0.contains(value) })
     owner.dataList.onNext(result)
 */
//Observable.merge(searchText,serchTab)
//    .withUnretained(self)
//    .flatMapLatest({ (owner, value) in
//        let result = value.isEmpty ? owner.data : owner.data.filter({ $0.contains(value) })
//            print(result)
//        return Observable.just(result)
//    })
//    .distinctUntilChanged()
//    .bind(with: self) { owner, value in
//    owner.dataList.onNext(value)
//}.disposed(by: disPoseBag)


// ---------------------------------
//            let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
//                owner.items.onNext(result)
//        }.disposed(by: disposeBag)
//
//        searchBar
//            .rx
//            .searchButtonClicked
//            .withLatestFrom(searchBar.rx.text.orEmpty)
//            .distinctUntilChanged()
//            .subscribe(with: self) {
//                owner, string in
//                print("검색버튼 클릭 \(string)")
//            }.disposed(by: disposeBag)


//        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
//            .bind(with: self) { owner, value in
//                print(value.0, value.1)
//                owner.data.remove(at: value.0.row)
//                owner.items.onNext(owner.data)
//
//            }.disposed(by: disposeBag)
