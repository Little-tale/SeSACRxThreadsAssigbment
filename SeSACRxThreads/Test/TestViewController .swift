//
//  TestViewController .swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TestViewController: UIViewController {
    
    let textFiled = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textFiled)
        textFiled.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    
        textFiled.addAction(UIAction(handler: { _ in
            print("이것 보게? \n")
        }), for: .allEvents)
        
        textFiled.backgroundColor = .lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            self.textFiled.text = ""
        }
    }
}



struct Items<Element> {
    // 아이템을 담아놓을 공간
    var items : [Element] = []
    
    // 푸시
    mutating func push(_ item: Element) {
        items.append(item)
    }
    // 팝
    mutating func pop() -> Element {
        return items.removeLast()
    }
}



extension TestViewController {
    private func justTest(){
        
        var items = Items<String> ()
        
        items.items
        items.push("test")
        items.pop()
        
    }
}

protocol ItemsProtocol {
    associatedtype Element
    
    func push(_ element: Element)
    
    func pop () -> Element
    
}
