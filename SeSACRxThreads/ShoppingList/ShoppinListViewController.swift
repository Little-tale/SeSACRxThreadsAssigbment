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
        
        let input = ShoppingViewModel.Input(
            textField: searchView.searchBar.rx.text,
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
