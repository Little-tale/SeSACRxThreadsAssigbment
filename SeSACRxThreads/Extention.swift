//
//  extention.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 4/8/24.
//
import UIKit
import RxSwift
import RxCocoa


// ViewWillAppear Rx Setting
extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
