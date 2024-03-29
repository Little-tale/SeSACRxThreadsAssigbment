//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        // label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        // label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        // label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        // label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    
    lazy var  viewModel = BirthDayViewModel(disposeBag)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        subscribe()
    }

    
    
    private func subscribe(){
        let input = BirthDayViewModel.Input(datePickerDate: birthDayPicker.rx.date)
        
        let output = viewModel.proceccing(input)
        
        output.year.bind(to: yearLabel.rx.text).disposed(by: disposeBag)
        output.month.bind(to: monthLabel.rx.text).disposed(by: disposeBag)
        output.day.bind(to: dayLabel.rx.text).disposed(by: disposeBag)
        
        output.vaildate.bind(with: self) { owner, bool in
            owner.infoLabel.text = bool ? "가입가능한 나이입니다." : "만 17세 이상만 가입 가능합니다."
            owner.infoLabel.textColor = bool ? .blue : .red
            
            owner.nextButton.isEnabled = bool
            
            owner.nextButton.backgroundColor = bool ? .blue : .lightGray
            
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            if let windowSceen = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowSceen.windows.first {
                    window.rootViewController = SampleViewController()
                    window.makeKeyAndVisible()
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
