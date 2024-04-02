//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa



class ShoppingTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingTableViewCell"
    
    let checkButton = CustomButton(frame: .zero, buttonType: .checkBox)
    
    let textsLabel = UILabel()
    
    let starButton = CustomButton(frame: .zero, buttonType: .star)
    
    var disposeBag = DisposeBag()
    
    var viewModel = ShoppingTableCellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    func setUI(_ model: UserModel) -> ShoppingTableCellViewModel.Input {
        starButton.isSelected = model.starBool
        checkButton.isSelected = model.selectedBool
        textsLabel.text = model.title
        
        let input = ShoppingTableCellViewModel
            .Input(
                inputcheckButton: checkButton.rx.tap,
                inputStarButton: starButton.rx.tap,
                model: model
            )
        
        return input
    }
    

    private func configure(){
        contentView.addSubview(checkButton)
        contentView.addSubview(textsLabel)
        contentView.addSubview(starButton)
        
        checkButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        textsLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(4)
            make.centerY.equalTo(checkButton)
            make.trailing.equalTo(starButton.snp.leading).inset(10)
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing
                .equalTo(
                    contentView
                        .safeAreaLayoutGuide
                ).inset(4)
            make.centerY.equalTo(textsLabel)
            make.size.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        viewModel.disposeBag = .init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



/*
 let input = ShoppingTableCellViewModel
     .Input(inputModel: model)
 
 let output = viewModel.proceccing(input)
 
 output.checkButton.bind(
     to: checkButton.rx.isSelected
 ).disposed(
     by: disposeBag
 )
 
 output.starButton.bind(
     to: starButton.rx.isSelected
 ).disposed(
     by: disposeBag
 )
 
 output.title.bind(
     to: textsLabel.rx.text
 ).disposed(
     by: disposeBag
 )
 */
