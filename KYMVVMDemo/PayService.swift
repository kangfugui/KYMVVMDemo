//
//  PayService.swift
//  DemoMVVM
//
//  Created by admin on 17/3/15.
//  Copyright © 2017年 putao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum PayResult {
    case success(String)
    case failure(String)
    
    var text: String {
        switch self {
        case .success(let msg):
            return msg
        case .failure(let msg):
            return msg
        }
    }
}

protocol PayServiceType {
    func pay() -> Observable<PayResult>
}

final class PayService: BaseService, PayServiceType {
    
    let disposeBag = DisposeBag()
    
    func pay() -> Observable<PayResult> {
        
        let urlString = URL(string: "https://www.baidu.com")!
        
        return Observable.create({ (element) -> Disposable in
            
            URLSession.shared.rx
                .data(request: URLRequest(url: urlString))
                .map { (data) -> PayResult in
                    return .success("pay success")
                }
                .subscribe(element)
                .addDisposableTo(self.disposeBag)
            
            return Disposables.create {
                
            }
        })
    }
}
