//
//  Reactive-extension.swift
//  ShopList
//
//  Created by Louis on 2022/11/25.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base : UIViewController {
    var viewWillAppear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
    }
    var viewWillDisappear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
    }
    var viewDidLoad: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
    }
    var viewDidAppear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
    }
    var viewDidDisappear: Observable<[Any]> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
    }
}
