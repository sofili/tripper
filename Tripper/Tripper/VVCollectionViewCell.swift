//
//  VVCollectionViewCell.swift
//  Tripper
//
//  Created by Pinghsien Lin on 11/30/16.
//  Copyright © 2016 vudu. All rights reserved.
//

import UIKit

class VVCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var tomatoLabel: UILabel!
    @IBOutlet weak var tomatoIcon: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingIcon: UIImageView!
    
    static let reuseIdentifier = "DataItemCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func setImage(_ fileName: String) {
        self.imageView.image = UIImage(named: fileName)
    }
    

}
