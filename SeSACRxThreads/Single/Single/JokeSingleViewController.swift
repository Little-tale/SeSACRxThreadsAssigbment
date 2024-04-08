//
//  JokeSingleViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

/*
 뷰모델로 옮기면서 작업합니다.
 */
final class JokeSingleViewController: UIViewController {
    
    let addJokeButton: UIButton = {
       let button = UIButton()
        button.setTitle("농담 추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 22
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        return button
    }()
    
    let tableView: UITableView = {
       let tv = UITableView()
        tv.register(JokeTableViewCell.self, forCellReuseIdentifier: JokeTableViewCell.identifier)
        return tv
    }()
    
    let jokeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = JokeSingleViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bindRx()
    }
    
    func bindRx() {
        let inputAppear = rx.viewWillAppear
        let buttonTap = addJokeButton.rx.tap
        
        
        let input = JokeSingleViewModel.Input(viewWillAppear: inputAppear, addButtonTab: buttonTap)
        
        let output = viewModel.proceccing(input)
        
        // TableView
        output.dataItems
            .drive(tableView.rx.items(
                cellIdentifier: JokeTableViewCell.identifier,
                cellType: JokeTableViewCell.self
            )) {
                row, value, cell in
                cell.jokeLabel.text = value.joke
            }
            .disposed(by: disposeBag)

        
        output.outputCount
            .bind(to: jokeCountLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func configure() {
        view.backgroundColor = .white
        
        view.addSubview(jokeCountLabel)
        jokeCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(jokeCountLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(addJokeButton)
        addJokeButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}



