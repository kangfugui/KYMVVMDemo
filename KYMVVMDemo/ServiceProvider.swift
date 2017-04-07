//
//  ServiceProvider.swift
//  DemoMVVM
//
//  Created by admin on 17/3/15.
//  Copyright © 2017年 putao. All rights reserved.
//

protocol ServiceProviderType: class {
    var payService: PayServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var payService: PayServiceType = PayService(provider: self)
}
