//
//  ViewModel.swift
//  SimpleMVVM
//
//  Created by Alex on 2020/9/6.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel{
    
    let viewDidAppearSubject = PublishSubject<[Any]>()
    private(set) var datas: Driver<[DataModel]>
    
    struct Dependencies {
        let fetchListService: FetchListServiceProtocol
    }
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        datas = self.viewDidAppearSubject
            .asObservable()
            .flatMap { _ in
                dependencies.fetchListService.start(withLength: 10)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
}
