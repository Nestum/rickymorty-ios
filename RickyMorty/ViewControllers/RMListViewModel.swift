//
//  RMListViewModel.swift
//  RickyMorty
//
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

protocol RMListViewModelProtocol {
    func fetchCharacter()
}

class RMListViewModel {
    
    let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchEpisodeList() {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        
        networkManager.request(fromURL: url) { (result: Result<Characters, Error>) in
            switch result {
            case .success(let characters):
                debugPrint("the string: \(characters)")
            case .failure(let error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
        }
        

    }
    
}

