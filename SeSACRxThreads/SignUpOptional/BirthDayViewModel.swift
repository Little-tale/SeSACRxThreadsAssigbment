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

    let disposeBag: DisposeBag
    
    let calendar = Calendar.current
   
    struct Input {
        let datePickerDate: ControlProperty<Date>
    }
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
        
        let vaildate: Driver<Bool>
        let vaildateText: Driver<String>
        
    }
    init(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    func proceccing(_ input: Input) -> Output {
        
        let userDate = input.datePickerDate
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0)}
            .map {
                ( year: "\($0.year!) 년",
                  month: "\($0.month!)월",
                  day: "\($0.day!) 일" )
            }
            .asDriver(onErrorJustReturn: (year: "", month: "", day: ""))
    
        let vaildate = input.datePickerDate.withUnretained(self) .map { owner, date in
            owner.checkForBirthDay(date)
        }
            .asDriver(onErrorJustReturn: false)
    
        let resultText = vaildate
            .map { $0 ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다."}
            .asDriver()
    
        return Output(
            year: userDate.map({ $0.year }),
            month: userDate.map({ $0.month }),
            day: userDate.map({ $0.day }),
            vaildate: vaildate,
            vaildateText: resultText
        )
    }
    
    
    private func checkForBirthDay(_ date: Date) -> Bool {
        let current = calendar.dateComponents([.year, .month, .day], from: Date())
        let user = calendar.dateComponents([.year, .month, .day], from: date)
        
        if current.year! - user.year! < 18 {
            return false
        } else if current.year! - user.year! == 18 {
            if current.month! < user.month! {
                return false
            } else if current.month == user.month && current.day! < user.day! {
                return false
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
/*
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
 */
