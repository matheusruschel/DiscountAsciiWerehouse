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
    var loadMoreButton: UIButton?
    weak var delegate:LoadingCellDelegate?
    var mode:LoadingMode = .Spinner
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSpinner()
        self.switchMode(mode)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtonLoadMore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addButtonLoadMore()
    }
    
    private func configureSpinner() {
        activityIndicator.hidesWhenStopped = true
    }
    
    func addButtonLoadMore() {
        
         loadMoreButton = UIButton(frame:
            CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height))
        loadMoreButton!.setTitle("Load More", forState: .Normal)
        loadMoreButton!.hidden = true
        loadMoreButton!.addTarget(self, action: #selector(loadMoreButtonClicked), forControlEvents: .TouchUpInside)
        self.addSubview(loadMoreButton!)
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
            self.backgroundColor = UIColor.lightGrayColor()
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
