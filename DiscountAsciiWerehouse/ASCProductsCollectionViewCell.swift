//
//  ASCProductsCollectionViewCell.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class ASCProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    var product: ASCProduct? {
        willSet {
            textLabel.text = ""
        }
        didSet {
            textLabel.text = product?.face
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.lightGrayColor()
        
    }

}
