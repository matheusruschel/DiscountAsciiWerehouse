//
//  ASCProductsViewController.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

let cellIdentifier = "productCell"
let nibIdentifier = "ASCProductsCollectionViewCell"

class ASCProductsViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    let layout =  GridCollectionViewLayout()
    let productsViewModel = ASCAsciiProductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    func configure() {
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        let cellNib = UINib(nibName: nibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        configureCollectionView()
        
        self.productsViewModel.delegate = self
    }
    
    
    func configureCollectionView() {
        self.productsCollectionView?.backgroundColor = UIColor.clearColor()
        self.productsCollectionView!.collectionViewLayout = layout
        self.productsCollectionView!.setNeedsLayout()
        self.productsCollectionView!.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ASCProductsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as?ASCProductsCollectionViewCell
        
        if cell == nil {
            cell = ASCProductsCollectionViewCell()
        }
        let randomIndex = Int(arc4random_uniform(UInt32(UIColor.colorPalette().count)))
        cell?.backgroundColor = UIColor.colorPalette()[randomIndex]
        
        return cell!
        
    }
    
}

extension ASCProductsViewController : AsciiProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCAsciiProductViewModel, sucess: Bool, errorMsg: String?) {
        
    }
}
