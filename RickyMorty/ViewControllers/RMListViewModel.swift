//
//  RMListViewModel.swift
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

class RMListViewModel {
    
    typealias DataChangedHandler = (_ value: [Character]) -> Void
    typealias ReceivedErrorHandler = (_ value: Error) -> Void

    private var dataChangedHandler: DataChangedHandler
    private var receivedErrorHandler: ReceivedErrorHandler!
    private let networkManager: NetworkManager
    private var isFetching: Bool = false
    
    var charactersArray: [Character] = []
    var filtered: [Character] = []

    init(networkManager: NetworkManager = NetworkManager(),
         dataChangedHandler: @escaping DataChangedHandler,
         receivedErrorHandler: @escaping ReceivedErrorHandler) {
        self.networkManager = networkManager
        self.dataChangedHandler = dataChangedHandler
        self.receivedErrorHandler = receivedErrorHandler
    }
    
    var currentPage: Info!
    static let inicialURL:URL = URL(string: "https://rickandmortyapi.com/api/character")!
    
    func fetchCharacters(url: URL = inicialURL) {
        networkManager.request(fromURL: url) { (result: Result<Characters, Error>) in
            defer {
                self.isFetching = false
            }
            
            switch result {
            case .success(let characters):
                self.charactersArray.append(contentsOf: characters.results)
                self.currentPage = characters.info
                self.dataChangedHandler(self.charactersArray)
            case .failure(let error):
                self.receivedErrorHandler(error)
            }
        }
    }
    
    func fetchMoreIfNeeded(currentRow: Int) {
        guard isFetching == false else {
            return
        }
        if charactersArray.count - currentRow == 5 {
            if let nextFetchURL = URL(string: currentPage.next!) {
                isFetching = true
                fetchCharacters(url: nextFetchURL)
            }
        }
    }
    
    func filterResults(filter: String) {
        if filter != "" {
            filtered = charactersArray.filter { $0.location.name.contains(filter) }
        } else {
            filtered = charactersArray
        }
        
        dataChangedHandler(filtered)
    }
}
