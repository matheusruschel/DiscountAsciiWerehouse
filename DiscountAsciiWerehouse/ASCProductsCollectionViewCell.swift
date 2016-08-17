//
//  ASCProductsCollectionViewCell.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class ASCProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var product: ASCProduct? {
        willSet {
            textLabel.text = ""
            priceLabel.text = ""
        }
        didSet {
            textLabel.text = "\(product!.face)\u{0000FE0E}"
            priceLabel.text = "$\(product!.price / 100)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
        self.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    func configure() {
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.font = UIFont.appFontWithSize(30)
        priceLabel.font = UIFont.appFontWithSize(17)
    }

}
