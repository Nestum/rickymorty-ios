//
//  RMListViewController.swift
//  RickyMorty
//
//  Created by Marco Castanheira on 29/01/2022.
//

import UIKit

class RMListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let viewModel = RMListViewModel()
        viewModel.fetchEpisodeList()
    }
}
