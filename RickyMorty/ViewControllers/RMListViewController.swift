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
            dataChangedHandler: { data in
                self.configureSnapshot(characters: data)
            }, receivedErrorHandler: { error in
                self.showErrorAlert(message: error.localizedDescription)
            })
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        viewModel.fetchCharacters()
    }
    
    private func setupController() {
        tableView.register(UINib.init(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: "CharacterCell")
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for location"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// setup daffable datasources for table view, it replaces the tradicional
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
    
    /// configures the state of the data n the tableview, and applies it
    private func configureSnapshot(characters: [Character]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapShot.appendSections([.main])
        snapShot.appendItems(characters, toSection: .main)
        
        tableViewDataSource.apply(snapShot, animatingDifferences: true)
    }
    
    /// shows an error message in a alert controller
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: "Something happened: \(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension RMListViewController: UISearchResultsUpdating {
    
    /// delegate method that returns whats is types in the search box
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        viewModel.filterResults(filter: text)
    }
}

