//
//  CharacterCell.swift
//  Created by Marco Castanheira on 30/01/2022.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    // MARK: - outlets
    
    @IBOutlet weak var characterPicture: UIImageView!
    @IBOutlet weak var episodesLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    let networkManager: NetworkManager = NetworkManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(character: Character, isFavourite: Bool = false) {
        nameLabel.text = character.name
        genderLabel.text = character.gender
        speciesLabel.text = character.species
        statusLabel.text = character.status
        episodesLabel.text = "Location: \(character.location.name)"
        
        if let imageURL = URL(string: character.image) {
            fetchImage(url: imageURL)
        }
        
        if isFavourite {
            backgroundColor = .red
        } else {
            backgroundColor = .white
        }
    }
    
    /// fetches an imagem given an URL
    func fetchImage(url: URL) {
        networkManager.request(fromURL: url) {  (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                self.characterPicture.image = UIImage(data: data)
            case .failure:
                self.characterPicture.image = UIImage(named: "noImage")
            }
        }
    }
    
    /// when the cell is reused, will clean the character picture
    override func prepareForReuse() {
        characterPicture.image = nil
    }
    
}
