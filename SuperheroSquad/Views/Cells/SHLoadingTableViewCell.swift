//
//  SHLoadingTableViewCell.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 07/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import UIKit

final class SHLoadingTableViewCell: UITableViewCell {

    // MARK: - UI Constants
    
    enum UIConstants {
        static let cellHeight: CGFloat = 44
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        spinner.color = .brandSecondary
    }
    
}
