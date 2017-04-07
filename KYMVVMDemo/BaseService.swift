//
//  BaseService.swift
//  DemoMVVM
//
//  Created by admin on 17/3/15.
//  Copyright © 2017年 putao. All rights reserved.
//

class BaseService {
    unowned let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}
