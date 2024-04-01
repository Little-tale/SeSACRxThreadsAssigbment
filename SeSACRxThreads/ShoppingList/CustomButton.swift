//
//  CustomButton.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/1/24.
//

import UIKit
import SnapKit

class CustomButton: UIButton {
    
    enum ButtonType {
        case checkBox
        case star
    }
    var buttonTypes: ButtonType
    
    init(frame: CGRect, buttonType: ButtonType) {
        self.buttonTypes = buttonType
        super.init(frame: frame)
        settingImage()
        
        addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            toggleButton()
        }), for: .touchUpInside)
        
    }
    private func toggleButton(){
        isSelected.toggle()
    }
    
    override var isSelected: Bool {
        didSet{
            print("isSelected : \(isSelected)")
            settingImage()
        }
    }
    
    private func settingImage(){
        switch buttonTypes {
        case .checkBox:
            let image = isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
            setImage(image, for: .normal)
        case .star:
            let image = isSelected ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            setImage(image, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit : CustomButton")
    }
}
