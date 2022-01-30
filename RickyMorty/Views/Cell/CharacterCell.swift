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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(character: Character) {
        nameLabel.text = character.name
        genderLabel.text = character.gender
        speciesLabel.text = character.species
        statusLabel.text = character.status
        episodesLabel.text = "Location: \(character.location.name)"
        
        if let imageURL = URL(string: character.image) {
            fetchImage(url: imageURL)
        }
    }
    
    func fetchImage(url: URL) {
        networkManager.request(fromURL: url) {  (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                self.characterPicture.image = UIImage(data: data)
            case .failure(let error):
                // add default image
                debugPrint("We got a failure trying to get the picture. The error we got was: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        characterPicture.image = nil
    }
    
}
