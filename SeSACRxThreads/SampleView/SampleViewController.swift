//
//  File.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol ViewControllerLayout {
    
    func configureHierarchy()
        
    
    func configureLayout()
        
    
    func designView()
}

class SampleViewController: UIViewController {
    
    let textField = SignTextField(placeholderText: "")
    let checkButton = PointButton(title: "추가")
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    lazy var viewModel = SampleViewModel(disposeBag)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register() 
        configureHierarchy()
        configureLayout()
        designView()
        subscribe()
    }
}


extension SampleViewController {
    private func subscribe(){
        let input = SampleViewModel.Input(
            textControl: textField.rx.text,
            tapControl: checkButton.rx.tap,
            itemseleted: tableView.rx.itemSelected
        )
        let output = viewModel.proceccing(input)
        
        output.outputValues.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
            (index, element, cell) in
            cell.textLabel?.text = element
        }.disposed(by: disposeBag)
        
    }
}


// MARK: Layout:
extension SampleViewController: ViewControllerLayout {
    
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(checkButton)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(checkButton.snp.leading).offset(18)
            make.height.equalTo(checkButton)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(checkButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    func designView() {
        view.backgroundColor = .white
    }
    
    private func register(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}


