//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    
    lazy var viewModel = PhoneViewModel(disposeBag)
    
    let descroptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        subscribe()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    func subscribe(){
        let input = PhoneViewModel.Input(
            phoneTextField: phoneTextField.rx.text,
            nextButton: nextButton.rx.tap
        )
        
        let output = viewModel.proceccing(input)
        
        output.validfirsText.bind(to: phoneTextField.rx.text).disposed(by: disposeBag)
        
        output.validation.bind(to: phoneTextField.rx.text).disposed(by: disposeBag)
        
        output.testText.bind(to: descroptionLabel.rx.text).disposed(by: disposeBag)
        
        
        output.validationBool.bind(with: self) { owner, bool in
            owner.nextButton.isEnabled = bool
            owner.nextButton.backgroundColor = bool ? .systemPink : .systemGray
        }.disposed(by: disposeBag)
        
        
        
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descroptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descroptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
