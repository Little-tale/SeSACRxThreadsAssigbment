//
//  ShoppinListViewController.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class ShoppinListViewController: UIViewController {
    
    let searchView = CustomSearchBar()
    let tableView =  UITableView(frame: .zero, style: .insetGrouped)
    
    let disPoseBag = DisposeBag()
    lazy var viewModel = ShoppingViewModel(disPoseBag)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        setting()
        subscibe()
    }
    
    
    // ShoppingTableViewCell
    private func subscibe() {
        
        let tableSelected = tableView
            .rx
            .modelSelected(
                ShoppingViewModel.self
            )
        
        let input = ShoppingViewModel.Input(
            textField: searchView.textField.rx.text,
            addButton: searchView.addButton.rx.tap
        )

        let output = viewModel.proceccing(input)
        
        print("subscibe")
        // 뷰컨틀로러 에서
        output.outputData.bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { [weak self] row, value, cell in
            guard let self else { return }
            print(cell)
            let input = cell.setUI(value)
            cell.viewModel.proceccing(input)
                .ObserVelModel.bind { userModel in
                    if let index = self.viewModel.data.firstIndex(where: { $0.uuid == userModel.uuid }) {
                        self.viewModel.data[index] = userModel
                    }
                    //self.viewModel.dummyData.accept(self.viewModel.data)
                }.disposed(by: disPoseBag)
           
        }.disposed(by: disPoseBag)
    }

    private func setting(){
        view.backgroundColor = .white
        view.addSubview(searchView)
        view.addSubview(tableView)
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(80)
        }
        
        searchView.layer.cornerRadius = 10
        searchView.backgroundColor = .systemGray3
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


//1. 오늘의 회고록
/*
 // 뷰모델에선 직접 접근이 불가하여 OnNext로 하였었으나 효과가 없었음
 // 여기서 직접 접근해서 "" 를 주어도 효과는 또 없었음
 // 뷰모델에서도 여기서도 결국엔 "" 를 주었지만 여전히 전체가 나오지 않음
 // orEmpty 라서? 그것도 아니다
 // 위치가 문제인가? 그것도 아니다 맨 위로 올려도 호출 위치 문제는 아니다.
 // 정리해서 올리기
 
 // Test
 */


/*
 print("별 업데이트 ",updataModel.starBool)
 if let index = self.viewModel.data.firstIndex(where: { $0.uuid == updataModel.uuid }) {
     self.viewModel.data[index] = updataModel
     let re = self.viewModel.data
     
     self.viewModel.dummyData.accept(re)
     
     print("업데이트 된 ",self.viewModel.data[index].starBool)
 
 
 cell.viewModel.proceccing(input)
     .ObserVelModel
     .subscribe(onNext: {updataModel in
     
         
     }).disposed(by: disPoseBag)
 }
 */
