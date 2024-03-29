//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let descroptionLabel = UILabel()
    
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        subscribe()

    }
    private func subscribe(){
        let input = SignUpViewModel.Input(emailTextField: emailTextField.rx.text)
        
        viewModel.proceccing(input).valitation.bind(with: self) { owner, result in
            owner.nextButton.isEnabled = result.isValid
            owner.descroptionLabel.text = result.message
            owner.nextButton.backgroundColor = result.isValid ? .systemRed : .systemGray
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.nextButtonClicked()
        }.disposed(by: disposeBag)
    }
    
    func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(descroptionLabel)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        descroptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalTo(emailTextField.snp.top).inset( -4 )
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
