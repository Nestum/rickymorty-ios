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

    init(networkManager: NetworkManager = NetworkManager(),
         receivedDataHandler: @escaping ReceivedDataHandler,
         receivedErrorHandler: @escaping ReceivedErrorHandler) {
        self.networkManager = networkManager
        self.receivedDataHandler = receivedDataHandler
        self.receivedErrorHandler = receivedErrorHandler
    }
    
    func fetchCharacters() {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        
        networkManager.request(fromURL: url) { (result: Result<Characters, Error>) in
            switch result {
            case .success(let characters):
                self.receivedDataHandler(characters)
            case .failure(let error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
        

    }
}
