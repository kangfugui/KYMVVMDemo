//
//  ViewModel.swift
//  DemoMVVM
//
//  Created by admin on 17/3/14.
//  Copyright © 2017年 putao. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ViewModelType {
    
    // Input
    var viewDidDeinit: PublishSubject<Void> { get }
    var cardNumFieldDidChange: PublishSubject<String> { get }
    var expFieldDidChange: PublishSubject<String> { get }
    var cvvFieldDidChange: PublishSubject<String> { get }
    var payButtonDidTap: PublishSubject<Void> { get }
    
    // Output
    var cardNumType: Driver<String> { get }
    var payResult: Driver<String> { get }
    var checkInput: Driver<Bool> { get }
}

class ViewModel: ViewModelType {
    
    let viewDidDeinit: PublishSubject<Void> = .init()
    let cardNumFieldDidChange: PublishSubject<String> = .init()
    let expFieldDidChange: PublishSubject<String> = .init()
    let cvvFieldDidChange: PublishSubject<String> = .init()
    let payButtonDidTap: PublishSubject<Void> = .init()
    
    let cardNumType: Driver<String>
    let payResult: Driver<String>
    let checkInput: Driver<Bool>
    
    init(provider: ServiceProviderType) {
        
        cardNumType = cardNumFieldDidChange.map { (text) -> String in
            return CardType.fromString(string: text).title
        }.asDriver(onErrorJustReturn: CardType.Unknown.title)
        
        let resultDidReceive = payButtonDidTap
            .flatMap { provider.payService.pay() }
            .map { (result) -> String in result.text }
            .shareReplay(1)
        
        payResult = resultDidReceive.asDriver(onErrorJustReturn: "")
        
        let expValid = expFieldDidChange.map { (text) -> Bool in
            return text.characters.count > 0
        }
        
        let cvvValid = cvvFieldDidChange.map { (text) -> Bool in
            return text.characters.count > 0
        }
        
        let combine = Observable.combineLatest(expValid, cvvValid) {
            $0 && $1
        }
        
        checkInput = combine.asDriver(onErrorJustReturn: false).startWith(false)
    }
}
