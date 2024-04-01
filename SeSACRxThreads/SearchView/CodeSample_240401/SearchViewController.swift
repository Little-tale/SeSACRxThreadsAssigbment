//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: 설치뷰컨
// 미션! 분리해서 작동하게 해보자 -> 뷰모델로 전환햐여 성공해 보자
class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()

     
    let disposeBag = DisposeBag()
    
    lazy var viewModel = SearchViewModel(disposeBag)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func bind(){
//        items.bind(
//            to: tableView
//                .rx
//                .items(
//                    cellIdentifier: SearchTableViewCell.identifier,
//                    cellType: SearchTableViewCell.self
//                )
//        ) { row , element, cell in
//            
//            cell.appNameLabel.text = "테스트 \(element)"
//            
//            cell.appIconImageView.backgroundColor = .systemBlue
//            
//            cell.downloadButton.rx.tap.bind(with: self) { owner, _ in
//                print("tap : \(owner)\n")
//                
//                owner.navigationController?.pushViewController(
//                    BirthdayViewController(),
//                    animated: true
//                )
//            
//            }.disposed(by: cell.disposeBag)
//            
//        }.disposed(by: disposeBag)
        
    // ------------------------------------------
        
//        tableView.rx.itemSelected.bind(with: self) { owner, indexI in
//            owner.data.remove(at: indexI.row)
//            owner.items.onNext(owner.data)
//        }.disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(String.self).withUnretained(self)
//            .bind { owner, model in
//                
//            }.disposed(by: disposeBag)
        
  // ---------------------------------------------
        

        
//        
//        searchBar.rx.text.orEmpty.debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
//            .distinctUntilChanged() // 값변화 감지
//            .subscribe(with: self) { owner, value in
//            print(value)
//        

        
        // -------------------------------
        let input = SearchViewModel.Input(
            // 테이블뷰 셀렉티드
            tableViewSelected: tableView.rx.itemSelected,
            searchTextIn: searchBar.rx.text,
            searchTextEvent: searchBar.rx.searchButtonClicked
        )
        // searchBar.rx.searc
        let output = viewModel.proceccing(input)
        
        output.validCellData
            // .withUnretained(self) 이걸 써먹고 싶은데 말이지
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) {row , item, cell in
                cell.appNameLabel.text = item
            }
            .disposed(by: disposeBag)
        
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
//    @objc func plusButtonClicked() {
//        let sample = ["A", "B", "C", "D", "E"]
//        
//        data.append(sample.randomElement()!)
//        items.onNext(data)
//        
//       // data.append(sample.randomElement()!)
//    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
