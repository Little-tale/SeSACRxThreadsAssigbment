//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
/*
 passwordTextField: passwordTextField.rx.text
 */

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let descroptionLabel = UILabel()
    
    let validText = Observable.just("8자 이상 입력해 주세욧")
    let disposeBag = DisposeBag()
    
    let viewModel = PasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        subsrcibe()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        validText.bind(to: descroptionLabel.rx.text).disposed(by: disposeBag)
    }
    
    
    private func subsrcibe(){
        let input = PasswordViewModel.Input(passwordTextField: passwordTextField.rx.text)
        
        let output = viewModel.proceccing(input)
        
        output.vaildTrigger.bind(with: self) { owner, bool in
            owner.nextButton.backgroundColor = bool ? .systemPink : .lightGray
            owner.nextButton.isEnabled = bool
            owner.descroptionLabel.isHidden = bool
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner
                .navigationController?.pushViewController(PhoneViewController(), animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    
    
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(descroptionLabel)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descroptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
