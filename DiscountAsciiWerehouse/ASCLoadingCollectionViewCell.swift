//
//  ASCLoadingCollectionViewCell.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class ASCLoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startLoading()
        self.backgroundColor = UIColor.lightGrayColor()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func startLoading() {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.startAnimating()
        })
    }

}
