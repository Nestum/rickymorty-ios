//
//  RMListViewController.swift
//  RickyMorty
//
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

class RMListViewController: UIViewController {
    
    // MARK: - Enums
    
    private enum Section {
        case main
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: RMListViewModel = {
        return RMListViewModel(
            receivedDataHandler: { data in
                self.configureSnapshot()
            }, receivedErrorHandler: { error in
                print("got error")
            })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureSnapshot()
        viewModel.fetchCharacters()
    }
    
    func configureSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Character>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.characters, toSection: .main)
        
        tableViewDataSource.apply(snapShot, animatingDifferences: true)
    }
    
    private func setupUI() {
        tableView.register(UINib.init(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: "CharacterCell")
    }
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<Section, Character> = {
        let dataSource = UITableViewDiffableDataSource<Section, Character>(tableView: tableView) { tableView, indexPath, character in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as? CharacterCell else {
                return UITableViewCell()
            }
            cell.configure(character: character)
            self.viewModel.fetchMoreIfNeeded(currentRow: indexPath.row)
            return cell
        }
        return dataSource
    }()
    

}
