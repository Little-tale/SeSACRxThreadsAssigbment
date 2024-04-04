//
//  ShoppingDetailViewController.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingDetailViewController: UIViewController {
    
    let checkButton = CustomButton(frame: .zero, buttonType: .checkBox)
    
    let starButton = CustomButton(frame: .zero, buttonType: .star)
    
    let titleTextField = UITextField(frame: .zero)
    
    let saveButton = UIButton()
    
    var viewModel = ShoppingDetailViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
    }
    
    init(_ model: UserModel, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
       
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.backgroundColor = .black
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func settingView(){
        // view
        view.backgroundColor = .white
        view.addSubview(checkButton)
        view.addSubview(starButton)
        view.addSubview(titleTextField)
        view.addSubview(saveButton)
        
        checkButton.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(40)
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.top.equalTo(checkButton.snp.bottom).offset(10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalTo(titleTextField)
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.width.equalTo(150)
        }
    }
    
    // 뷰컨트롤러에서
    func bind(_ model: UserModel){
        //let begiberModel = BehaviorSubject(value: model)
        
        // 각 디테일 모델. 
        // Input의 ControlEvent<Void> X 3
        // Input의 ControlProperty<String?> 인데 ?는 뷰모델에서 벗겨주는것이
        // 맞다고 생각해서 옮김
        
        let input = ShoppingDetailViewModel.Input(
            checkButtonControl: checkButton.rx.tap,
            starButtonControl: starButton.rx.tap,
            titleTextFiedl: titleTextField.rx.text,
            SaveButton: saveButton.rx.tap,
            model: model )
        
        let output = viewModel.proceccing(input)
        
        output.checkButtonState.bind(to: checkButton.rx.isSelected).disposed(by: disposeBag)
        
        output.starButtonControl.bind(to: starButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.titleText.bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        saveButton.rx.tap

            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)

            }.disposed(by: disposeBag)
        
    }
    
    // 버튼 저장버튼을 누른후 뒤로갈때 Dispose를 이시점에 두는방법과
    // 저장 버튼을 누른후에 뒤로 갈때 disposeBag = .init() 하는 방법 이 있는데
    
}
