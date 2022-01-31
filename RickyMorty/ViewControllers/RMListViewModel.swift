//
//  RMListViewModel.swift
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

class RMListViewModel {
    
    /*
     handlers to store the callbacks
     */
    typealias DataChangedHandler = (_ value: [Character]) -> Void
    typealias ReceivedErrorHandler = (_ value: Error) -> Void
    private var dataChangedHandler: DataChangedHandler
    private var receivedErrorHandler: ReceivedErrorHandler!
    
    private let networkManager: NetworkManager
    private var isFetching: Bool = false
    
    static let missingRowsToFetch = 5
    var isFiltering = false
    
    var charactersArray: [Character] = []
    var filtered: [Character] = []
    var favorites: [Character] = []

    init(networkManager: NetworkManager = NetworkManager(),
         dataChangedHandler: @escaping DataChangedHandler,
         receivedErrorHandler: @escaping ReceivedErrorHandler) {
        self.networkManager = networkManager
        self.dataChangedHandler = dataChangedHandler
        self.receivedErrorHandler = receivedErrorHandler
    }
    
    var currentPage: Info!
    static let inicialURL:URL = URL(string: "https://rickandmortyapi.com/api/character")!
    
    /// if no URL is provided, it uses the default one to start the fetch of data
    func fetchCharacters(url: URL = inicialURL) {
        networkManager.request(fromURL: url) { (result: Result<Characters, Error>) in
            defer {
                self.isFetching = false
            }
            
            switch result {
            case .success(let characters):
                self.charactersArray.append(contentsOf: characters.characterArray)
                self.currentPage = characters.info
                self.dataChangedHandler(self.charactersArray)
            case .failure(let error):
                self.receivedErrorHandler(error)
            }
        }
    }
    
    /// receives the current rendered row position and if it's matches the condition to fetch more data, will fetch more using the next url to fetch data
    func fetchMoreIfNeeded(currentRow: Int) {
        guard isFetching == false else {
            return
        }
        if charactersArray.count - currentRow == Self.missingRowsToFetch {
            if let nextFetchURL = URL(string: currentPage.next!) {
                isFetching = true
                fetchCharacters(url: nextFetchURL)
            }
        }
    }
    
    /// will handles the text typed in the searchbar. If its empty will clean the filter
    func filterResults(filter: String) {
        defer {
            isFiltering = filtered.count != charactersArray.count
            dataChangedHandler(filtered)
        }
        
        if !filter.isEmpty {
            filtered = charactersArray.filter { $0.location.name.contains(filter) }
        } else {
            filtered = charactersArray
        }
    }
    
    /// checks if a character is in the favourits
    func isFavourite(character: Character) -> Bool {
        return favorites.contains(character)
    }
    
    /// adds a character to favourits if it does not exist, and removes it if exists
    /// also returns the character so we can reload the cell
    /// it takes into consideration if there's an active filter
    func toggleFavorite(index: Int) -> Character {
        var itemArray: [Character] = []
        if isFiltering {
            itemArray = filtered
        } else {
            itemArray = charactersArray
        }
        
        let character = itemArray[index]
        if favorites.contains(character) {
            favorites = favorites.filter { $0 != character }
        } else {
            favorites.append(character)
        }
        return character
    }
}
