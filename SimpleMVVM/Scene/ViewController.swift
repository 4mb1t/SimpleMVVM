//
//  ViewController.swift
//  SimpleMVVM
//
//  Created by Alex on 2020/9/6.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    
    private let viewModel: ViewModel = {
        let fetchListService = FetchListService()
        let dependencies = ViewModel.Dependencies(fetchListService: fetchListService)
        return ViewModel(dependencies: dependencies)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        binder()
    }
    
    private func initSubView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func binder(){
        self.rx
            .methodInvoked(#selector(ViewController.viewDidAppear(_:)))
            .bind(to: viewModel.viewDidAppearSubject)
            .disposed(by: disposeBag)
        
        viewModel.datas
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, model, cell) in
                cell.textLabel?.text = "\(model.data)"
            }
            .disposed(by: disposeBag)
    }

}
