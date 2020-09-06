//
//  SimpleMVVMTests.swift
//  SimpleMVVMTests
//
//  Created by Alex on 2020/9/6.
//  Copyright © 2020 Alex. All rights reserved.
//

import XCTest
import RxSwift

@testable import SimpleMVVM

private let MOCK_DATA = Array(repeating:DataModel(data: "1") , count: 10)

class MockFetchListService: FetchListServiceProtocol {
    func start(withLength length: UInt) -> Observable<[DataModel]> {
        Observable.create { observer -> Disposable in
            DispatchQueue.init(label: "MockFetchListService").asyncAfter(deadline: .now() + 1.0) {
                observer.onNext(MOCK_DATA)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}


class Mvvm_UnitTestTests: XCTestCase {
    private(set) var viewModel: ViewModel!
    let disposeBag = DisposeBag()
    
    override func setUp() {

    }

    override func tearDown() {
        viewModel = nil
    }
    
    func testViewModel() {
        let fetchListService = MockFetchListService()
        let dependencies = ViewModel.Dependencies(fetchListService: fetchListService)
        viewModel = ViewModel(dependencies: dependencies)
        
        let expectation = XCTestExpectation(description: "Receive data")
        let viewDidAppear = PublishSubject<[Any]>()

        viewDidAppear
            .asObservable()
            .bind(to: viewModel.viewDidAppearSubject)
            .disposed(by: disposeBag)

        viewModel.datas
            .asObservable()
            .subscribe(onNext: {
                XCTAssertEqual(MOCK_DATA, $0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewDidAppear.onNext([])

        wait(for: [expectation], timeout: 5.0)
        
    }
}
