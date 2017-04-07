//
//  ViewController.swift
//  DemoMVVM
//
//  Created by admin on 17/3/14.
//  Copyright © 2017年 putao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: BaseViewController {
    
    @IBOutlet weak var cardTypeLab: UILabel!
    @IBOutlet weak var cardNumField: UITextField!
    @IBOutlet weak var expField: UITextField!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    
    let viewModel: ViewModelType
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pay"
        self.configureRx()
    }
    
    private func configureRx() {
        
        self.rx.deallocated
            .bindTo(viewModel.viewDidDeinit)
            .addDisposableTo(self.disposeBag)
        
        payButton.rx
            .tap
            .bindTo(self.viewModel.payButtonDidTap)
            .addDisposableTo(self.disposeBag)
        
        cardNumField.rx
            .text
            .orEmpty
            .bindTo(self.viewModel.cardNumFieldDidChange)
            .addDisposableTo(self.disposeBag)
        
        expField.rx.text
            .orEmpty
            .bindTo(self.viewModel.expFieldDidChange)
            .addDisposableTo(self.disposeBag)
        
        verifyCodeField.rx.text
            .orEmpty
            .bindTo(self.viewModel.cvvFieldDidChange)
            .addDisposableTo(self.disposeBag)
        
        viewModel.cardNumType
            .drive(cardTypeLab.rx.text)
            .addDisposableTo(self.disposeBag)
        
        viewModel.checkInput.drive(onNext: { (flag) in
            self.payButton.isEnabled = flag
            self.payButton.alpha = flag ? 1 : 0.5
        }).addDisposableTo(self.disposeBag)
        
        viewModel.payResult
            .asObservable()
            .subscribe(onNext: { (result) in
                
                let alert = UIAlertController(title: result,
                                              message: result,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "yes", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
        })
            .addDisposableTo(self.disposeBag)
    }
}
