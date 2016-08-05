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

class ASCProductsGridViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            configureCollectionView()
        }
    }
    let productsViewModel = ASCProductsViewModel()
    let layout =  GridCollectionViewLayout()
    var customSearchController: ASCCustomSearchController!
    var isLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.productsViewModel.delegate = self
        loadMoreProducts(nil, onlyInStock: false)
    }
    
    func configureCollectionView() {
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        
        let cellNib = UINib(nibName: nibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        let loadingNib = UINib(nibName: loadingNibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(loadingNib, forCellWithReuseIdentifier: loadingCellIdentifier)
        let headerNib = UINib(nibName: headerNibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        
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
            
            if let destVC = segue.destinationViewController as? ASCProductDetailViewController {
                
                if let cell = sender as? ASCProductsCollectionViewCell {
                    destVC.product = cell.product
                }
            }
        }
    }
    
    func loadMoreProducts(searchText:String?,onlyInStock: Bool) {
        
        if productsViewModel.validateSearchText(searchText) {
            productsViewModel.loadProducts(searchText,onlyInStock: false)
        } else {
            productsViewModel.loadProducts(nil,onlyInStock: false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ASCProductsGridViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < collectionView.numberOfItemsInSection(indexPath.section) - 1 {
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            self.performSegueWithIdentifier(productDetailSegue, sender: cell)
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isLoaded {
            
            if productsViewModel.maxProductLimitReached {
                return productsViewModel.numberOfItemsInSection
            }
            return productsViewModel.numberOfItemsInSection + 1
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
        var numberOfItemsInSection = collectionView.numberOfItemsInSection(indexPath.section)
        
        // if we have not fetched all products there should be a loading cell
        if !productsViewModel.maxProductLimitReached {
            numberOfItemsInSection -= 1
        }
        
        // if we're not on the last cell, then we use product cell, otherwise loading cell
        if indexPath.row < numberOfItemsInSection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as?ASCProductsCollectionViewCell
            (cell as! ASCProductsCollectionViewCell).product = productsViewModel.itemForIndexPath(indexPath.row)
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(loadingCellIdentifier, forIndexPath: indexPath) as?ASCLoadingCollectionViewCell
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(UIColor.colorPalette().count)))
        cell?.backgroundColor = UIColor.colorPalette()[randomIndex]
        
        // if last row (loading cell) is visible then we load more products
        if indexPath.row == productsViewModel.numberOfItemsInSection {
            loadMoreProducts(customSearchController.customBar.text, onlyInStock: false)
        }
        
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
            customSearchController.customDelegate = self
            
            reusableView!.addSubview(customSearchController.customBar)
        }
        
        return reusableView!
    }
    
    
}

extension ASCProductsGridViewController : ProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductsViewModel, sucess: Bool, errorMsg: String?) {
        
        if sucess {
            isLoaded = true
            self.productsCollectionView.reloadData()
        } else {
            isLoaded = false
            // present error
        }
        
    }
}
extension ASCProductsGridViewController : CustomSearchControllerDelegate {
    
    func didStartSearching() {
        
    }
    
    func didTapOnSearchButton() {
        
    }
    
    func didTapOnCancelButton() {
        
    }
    
    func didChangeSearchText(searchText: String) {
        
        loadMoreProducts(customSearchController.customBar.text, onlyInStock: false)
    }
    
}

