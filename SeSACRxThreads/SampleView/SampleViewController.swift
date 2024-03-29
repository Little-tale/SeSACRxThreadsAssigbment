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

/*
 과제에 대한 회고....
 1. 나에게 있어 MVVM 패턴의 명확한선과
    Input Output 패턴의 대해서 좀더 명확한 구분의 기준을 세워야 겠다는
    생각이 들었다. 나에게 있어 기준이 생긴점이 있는데,
    예를 들자면)
    VC 은 내가 셀을 눌렀을때 어디까지 아는게 좋을까 ? 에 대한 질문에는
    눌렀구나. 까지 알아야 하겠다 라는 기준이 생겼고,
    VM 에서는 아 저걸 누르면 지워야 겠다 같은 액션이 들어가야 겠다 라는
    명확한 구분점이 생긴것 같다.
    그 목표를 이루기 위해 위와 같이 최대한 View 가 VM에 알려야할 정보들만
    넘겨 주었고 그것을 가공( 프로세싱 ) 하여 보여주는 로직을 구현 하였다.
 
2. Rx에 대한
    상당히 어렵다.
    커스텀 옵저버블일때는 뭔가 자유도가 상당히 높아( 개인적 생각 ) 다양한
    시도를 해볼 수 있었는데, Rx는 물론 사람에 따라 다르겠지만
    뭐랄까... Rx: 내가 구현한게 있는데..? 그걸 안써? 라는 어조가 느껴지는
    친구라 사귀긴 힘든 친구지만 익숙해지면 편해질것 같다는 생각은 든다.
 */
