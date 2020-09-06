//
//  FetchListService.swift
//  SimpleMVVM
//
//  Created by Alex on 2020/9/6.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import RxSwift

protocol FetchListServiceProtocol {
    func start(withLength length: UInt) -> Observable<[DataModel]>
}

class FetchListService {
    
}

extension FetchListService: FetchListServiceProtocol {
    func start(withLength length: UInt) -> Observable<[DataModel]> {
        Observable.create { observer -> Disposable in
            DispatchQueue.init(label: "AsyncRandom").asyncAfter(deadline: .now() + 1.0) {
                var list = [DataModel]()
                for _ in 1...length {
                    let model = DataModel(data: String(Int.random(in: 1...20)))
                    list.append(model)
                }
                observer.onNext(list)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
