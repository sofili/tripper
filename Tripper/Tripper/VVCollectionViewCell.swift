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
    
    static let reuseIdentifier = "DataItemCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setImage(_ fileName: String) {
        self.imageView.image = UIImage(named: fileName)
    }
}
