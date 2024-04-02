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
    let tableView = UITableView()
    
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
        
        // 뷰모델에선 직접 접근이 불가하여 OnNext로 하였었으나 효과가 없었음
        // 여기서 직접 접근해서 "" 를 주어도 효과는 또 없었음
        // 뷰모델에서도 여기서도 결국엔 "" 를 주었지만 여전히 전체가 나오지 않음
        // orEmpty 라서? 그것도 아니다
        // 위치가 문제인가? 그것도 아니다 맨 위로 올려도 호출 위치 문제는 아니다.
        //
//        searchView.addButton.rx.tap.withLatestFrom(searchView.textField.rx.text).bind(with: self) { owner, string in
//            if let string {
//                owner.viewModel.data.append(string)
//            }
//            owner.searchView.textField.rx.text.onNext("")
//            owner.searchView.textField.text = ""
//        }.disposed(by: disPoseBag)
        
        // Test
        let input = ShoppingViewModel.Input(
            textField: searchView.textField.rx.text,
            addButton: searchView.addButton.rx.tap
        )

        let output = viewModel.proceccing(input)
        
        print("subscibe")
        
        output.outputData.bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { row, value, cell in
            
            print(cell)
            cell.setUI(title: value)
            
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
