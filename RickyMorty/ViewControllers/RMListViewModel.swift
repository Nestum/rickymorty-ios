//
//  RMListViewModel.swift
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

class RMListViewModel {
    
    typealias ReceivedDataHandler = (_ value: Characters) -> Void
    typealias ReceivedErrorHandler = (_ value: NetworkManager.ManagerErrors) -> Void

    private var receivedDataHandler: ReceivedDataHandler
    private var receivedErrorHandler: ReceivedErrorHandler!
    private let networkManager: NetworkManager
    private var isFetching: Bool = false
    
    var characters: [Character] = []

    init(networkManager: NetworkManager = NetworkManager(),
         receivedDataHandler: @escaping ReceivedDataHandler,
         receivedErrorHandler: @escaping ReceivedErrorHandler) {
        self.networkManager = networkManager
        self.receivedDataHandler = receivedDataHandler
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
                self.characters.append(contentsOf: characters.results)
                self.currentPage = characters.info
                self.receivedDataHandler(characters)
            case .failure(let error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMoreIfNeeded(currentRow: Int) {
        guard isFetching == false else {
            return
        }
        if characters.count - currentRow == 5 {
            if let nextFetchURL = URL(string: currentPage.next!) {
                isFetching = true
                fetchCharacters(url: nextFetchURL)
            }
        }
    }
}
