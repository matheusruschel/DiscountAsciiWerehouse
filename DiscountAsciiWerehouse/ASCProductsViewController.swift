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
let loadingCellIdentifier = "loadingCell"
let loadingNibIdentifier = "ASCLoadingCollectionViewCell"
let headerIdentifier = "headerView"
let headerNibIdentifier = "ASCHeaderCollectionReusableView"
let productDetailSegue = "ProductDetailSegue"

class ASCProductsViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    let layout =  GridCollectionViewLayout()
    let productsViewModel = ASCProductViewModel()
    var customSearchController: ASCCustomSearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        productsViewModel.loadProducts()
    }
    
    func configure() {
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        let cellNib = UINib(nibName: nibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        let loadingNib = UINib(nibName: loadingNibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(loadingNib, forCellWithReuseIdentifier: loadingCellIdentifier)
        let headerNib = UINib(nibName: headerNibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        configureCollectionView()
        self.productsViewModel.delegate = self
    }
    
    func configureCollectionView() {
        //[UIApplication sharedApplication].statusBarFrame.size.height
        let topInsets = -self.navigationController!.navigationBar.frame.height -
            UIApplication.sharedApplication().statusBarFrame.size.height
        self.productsCollectionView.contentInset = UIEdgeInsets(
            top: topInsets,
            left: 0,
            bottom: 0,
            right: 0)
        self.productsCollectionView!.backgroundColor = UIColor.clearColor()
        self.productsCollectionView!.collectionViewLayout = layout
        self.productsCollectionView!.setNeedsLayout()
        self.productsCollectionView!.setNeedsDisplay()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == productDetailSegue {
            // do stuff
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ASCProductsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < collectionView.numberOfItemsInSection(indexPath.section) - 1 {
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            self.performSegueWithIdentifier(productDetailSegue, sender: cell)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
        
        if indexPath.row < collectionView.numberOfItemsInSection(indexPath.section) - 1 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as?ASCProductsCollectionViewCell
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(loadingCellIdentifier, forIndexPath: indexPath) as?ASCLoadingCollectionViewCell
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(UIColor.colorPalette().count)))
        cell?.backgroundColor = UIColor.colorPalette()[randomIndex]
        
        return cell!
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView?
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath)

            
            customSearchController = ASCCustomSearchController(searchResultsController: self, searchBarFrame: CGRect(
                x: 0.0,
                y: 0.0,
                width: reusableView!.frame.size.width,
                height: reusableView!.frame.size.height),
                searchBarFont: UIFont.appFontWithSize(16),
                searchBarTextColor: UIColor.orangeColor(),
                searchBarTintColor: UIColor.blackColor())
            
            customSearchController.customBar.placeholder = "Search..."
            
            reusableView!.addSubview(customSearchController.customBar)
        }
        
        return reusableView!
    }
    
    
}

extension ASCProductsViewController : ProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductViewModel, sucess: Bool, errorMsg: String?) {
        
    }
}
