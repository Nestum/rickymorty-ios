//
//  RMListViewController.swift
//  RickyMorty
//
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

class RMListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: RMListViewModel = {
        return RMListViewModel(
            receivedDataHandler: { data in
                print("receivedData: \(data)")
            }, receivedErrorHandler: { error in
                print("got error")
            })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.fetchCharacters()
    }
    
    private func setupUI() {
        
        
        
    }
    
    
    
}
