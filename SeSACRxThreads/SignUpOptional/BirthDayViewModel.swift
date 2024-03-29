//
//  BirthDayViewModel.swift
//  SeSACRxThreads
//
//  Created by Jae hyung Kim on 3/29/24.
//

import Foundation
import RxCocoa
import RxSwift


class BirthDayViewModel: ViewModelType {
    // "만 17세 이상만 가입 가능합니다."
    let disposeBag: DisposeBag
   
    struct Input {
        let datePickerDate: ControlProperty<Date>
    }
    struct Output {
        let year: Observable<String>
        let month: Observable<String>
        let day: Observable<String>
        
        let vaildate: Observable<Bool>
    }
    init(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    func proceccing(_ input: Input) -> Output {
        
        let year = input.datePickerDate.map {
            let date = Calendar.current.component(.year, from: $0)
            return "\(date)년"
        }
        
        let month = input.datePickerDate.map {
            let date = Calendar.current.component(.month, from: $0)
            return "\(date)월"
        }
        
        let day = input.datePickerDate.map {
            let date = Calendar.current.component(.day, from: $0)
            return "\(date)일"
        }
        
        let vaildate = input.datePickerDate.map {[weak self] date in
            self?.proceccingForBirthDay(date) ?? false
        }
        
       
        return Output(year: year, month: month, day: day, vaildate: vaildate)
    }
    
    
    private func proceccingForBirthDay(_ date: Date) -> Bool {
        
        let calender = Calendar.current
        
        let current = calender.dateComponents([.year, .month, .day], from: Date())
        
        let user = calender.dateComponents([.year,.month,.day], from: date)
        
        if case let (year?, month?, day?) = (current.year, current.month, current.day) {
            
            guard case let (userY?, userM?, userD?) = (
                user.year,user.month, user.day
            ) else { return false }
            
            
             // 2024 - 2008
            if year - userY < 18 {
                // 만 18세 미만
                return false
            } else if year - userY == 18 {
                // 만 18세인 경우, 월과 일을 확인해야 함
                if month < userM {
                    // 생일이 아직 안 지남
                    return false
                } else if month == userM && day < userD {
                    // 같은 달이지만 생일이 지나지 않음
                    return false
                }
            }
        }
        return true
    }
}

/*
 let date1 = Date()
 let date2 = Date()
 let a = date1 - date2
 
 let currrent = Date().timeIntervalSince1970
 let user = date.timeIntervalSince1970
 
 
 let date = Date().timeIntervalSince1970
 let calender = Calendar.current
 print(calender.dateComponents([.year, .month, .day], from: Date()))
 
 print(date)
 */
