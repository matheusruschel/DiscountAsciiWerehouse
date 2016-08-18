//
//  ASCLoadingCollectionViewCell.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

protocol LoadingCellDelegate : class {
    func buttonLoadMoreClicked(cell:ASCLoadingCollectionViewCell)
}

enum LoadingMode {
    case LoadMore, Spinner
}

class ASCLoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!
    weak var delegate:LoadingCellDelegate?
    var mode:LoadingMode = .Spinner
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(netHex:0xCC4025)
        configureSpinner()
        configureButtonLoadMore()
        self.switchMode(mode)
    }
    
    private func configureSpinner() {
        activityIndicator.hidesWhenStopped = true
    }
    
    func configureButtonLoadMore() {
        
        loadMoreButton.setTitle("LOAD MORE", forState: .Normal)
        loadMoreButton.hidden = true
        loadMoreButton.addTarget(self, action: #selector(loadMoreButtonClicked), forControlEvents: .TouchUpInside)
        loadMoreButton.titleLabel!.font = UIFont.appFontWithSize(30)
        loadMoreButton.titleLabel!.adjustsFontSizeToFitWidth = true
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func switchMode(mode:LoadingMode) {
        
        self.mode = mode
        switch mode {
        case .LoadMore:
            self.backgroundColor = UIColor(netHex:0xCC4025)
            loadMoreButton?.hidden = false
            stopLoading()
        case .Spinner:
            //self.backgroundColor = UIColor.lightGrayColor()
            loadMoreButton?.hidden = true
            startLoading()
        }
        

    }
    
    func loadMoreButtonClicked() {
        delegate?.buttonLoadMoreClicked(self)
        self.switchMode(.Spinner)
    }
    
    func isOnLoadMoreMode() -> Bool {
        
        return !loadMoreButton!.hidden
    }

}
