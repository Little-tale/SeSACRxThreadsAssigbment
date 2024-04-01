//
//  CustomSearchBar.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import UIKit
import SnapKit


class CustomSearchBar: UIView {
    
    let searchBar = UITextField()
    let addButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchBar)
        addSubview(addButton)
        design()
    }

    private func design(){
        
        searchBar.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(addButton.snp.leading)
        }
        addButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(searchBar.snp.trailing)
        }

        searchBar.placeholder = "추가하세요"
        addButton.setTitle("추가", for: .normal)
        addButton.backgroundColor = .systemGray
        addButton.tintColor = .black
        
        addButton.layer.cornerRadius = 12
        addButton.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit: CustomSearchBar")
    }
}
