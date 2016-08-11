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
let productDetailSegue = "ProductDetailSegue"

class ASCProductsGridViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            configureCollectionView()
        }
    }
    let productsViewModel = ASCProductsViewModel()
    var isLoaded = false
    var searchBar: UISearchBar!
    var searchBarBoundsY: CGFloat!
    var activityIndicator: UIActivityIndicatorView!
    var inStockLabel: UILabel!
    var inStockButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.productsViewModel.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareUI()
        
        if !isLoaded {
            self.activityIndicator.startAnimating()
            productsViewModel.loadProducts(nil,onlyInStock: false,forceRefresh: false)
        }
    }
    
    
    // MARK: UI Configuration
    func prepareUI() {
        configureSearchController()
        configureInStockLabel()
        configureInStockButton()
        configureActivityIndicator()
    }
    
    
    // MARK: Button action
    func checkboxToggle() {
        self.inStockButton.selected = !self.inStockButton.selected
        
    }
    
    func configureInStockButton() {
     
        if self.inStockButton == nil && self.inStockLabel != nil {
            
            self.inStockButton = UIButton(frame: CGRect(
                x: self.inStockLabel.frame.width + self.inStockLabel.frame.origin.x,
                y: searchBarBoundsY,
                width: UIScreen.mainScreen().bounds.size.width * 0.10,
                height: self.inStockLabel.frame.height))
            
            self.inStockButton.setImage(UIImage(named:"unchecked_checkbox"), forState: .Normal)
            self.inStockButton.setImage(UIImage(named:"checked_checkbox"), forState: .Selected)
            
            self.inStockButton.addTarget(self, action: #selector(checkboxToggle), forControlEvents: .TouchUpInside)
            
            self.view.addSubview(self.inStockButton)
        }
    }
    
    func configureInStockLabel() {
        
        if self.inStockLabel == nil && self.searchBar != nil {
            
            self.inStockLabel = UILabel(frame: CGRect(
                x: self.searchBar.frame.width,
                y: searchBarBoundsY,
                width: UIScreen.mainScreen().bounds.size.width * 0.15,
                height: self.searchBar.frame.height))
            self.inStockLabel.font = UIFont.appFontWithSize(14)
            self.inStockLabel.textColor = UIColor.whiteColor()
            self.inStockLabel.text = "In stock"
            
            self.view.addSubview(self.inStockLabel)
        }
    }
    
    func configureActivityIndicator() {
        
        if self.activityIndicator == nil {
            
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.center = self.view.center
        }
        if !self.activityIndicator!.isDescendantOfView(self.productsCollectionView){
            self.productsCollectionView.addSubview(self.activityIndicator!)
        }

    }
    
    func configureSearchController() {
        
        if self.searchBar == nil{
            searchBarBoundsY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height
            
            self.searchBar = UISearchBar(frame: CGRectMake(0,searchBarBoundsY, UIScreen.mainScreen().bounds.size.width * 0.75, 44))
            self.searchBar!.searchBarStyle       = UISearchBarStyle.Minimal
            self.searchBar!.tintColor            = UIColor.whiteColor()
            self.searchBar!.barTintColor         = UIColor.whiteColor()
            self.searchBar!.delegate             = self;
            self.searchBar!.placeholder          = "Search";
            
            self.addObservers()
        }
        
        if !self.searchBar!.isDescendantOfView(self.view){
            self.view.addSubview(self.searchBar!)
        }

    }
    
    func configureCollectionView() {
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        
        let cellNib = UINib(nibName: nibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        let loadingNib = UINib(nibName: loadingNibIdentifier, bundle: nil)
        self.productsCollectionView.registerNib(loadingNib, forCellWithReuseIdentifier: loadingCellIdentifier)
        self.productsCollectionView!.backgroundColor = UIColor.clearColor()
    }

    
    func addObservers(){
        let context = UnsafeMutablePointer<UInt8>(bitPattern: 1)
        self.productsCollectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.New,.Old], context: context)
    }
    
    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>){
        if keyPath! == "contentOffset" {
            if let collectionV:UICollectionView = object as? UICollectionView {
                self.searchBar?.frame = CGRectMake(
                    self.searchBar!.frame.origin.x,
                    self.searchBarBoundsY! + ( (-1 * collectionV.contentOffset.y)),
                    self.searchBar!.frame.size.width,
                    self.searchBar!.frame.size.height
                )
                
                self.inStockLabel?.frame = CGRect(
                    x: self.inStockLabel.frame.origin.x,
                    y: self.searchBarBoundsY! + ( (-1 * collectionV.contentOffset.y)),
                    width: self.inStockLabel.frame.width,
                    height: self.inStockLabel.frame.height)
            }
        }
    }
    
    //MARK: Deinitialization
    deinit{
        self.removeObservers()
    }
    
    func removeObservers(){
        self.productsCollectionView?.removeObserver(self, forKeyPath: "contentOffset")
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
    
    // MARK: Load products
    func loadMoreProducts(searchText:String?,onlyInStock: Bool) {
        
        if productsViewModel.validateSearchText(searchText) {
            
            if !self.activityIndicator.isAnimating() {
                self.activityIndicator.startAnimating()
            }
            productsViewModel.clearProductsList()
            productsViewModel.loadProducts(searchText,onlyInStock: false,forceRefresh: false)
            self.productsCollectionView.reloadData()
        } 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ASCProductsGridViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var numberOfItemsInSection = productsViewModel.numberOfItemsInSection
        
        if productsViewModel.showLoadingCell {
            numberOfItemsInSection -= 1
        }
        
        if indexPath.row < numberOfItemsInSection {
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            self.performSegueWithIdentifier(productDetailSegue, sender: cell)
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isLoaded {
            return productsViewModel.numberOfItemsInSection
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
        var numberOfItemsInSection = productsViewModel.numberOfItemsInSection
        
        if productsViewModel.showLoadingCell {
            numberOfItemsInSection -= 1
        }
        
        // if we're not on the last cell, then we use product cell, otherwise loading cell
        if indexPath.row < numberOfItemsInSection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as?ASCProductsCollectionViewCell
            (cell as! ASCProductsCollectionViewCell).product = productsViewModel.itemForIndexPath(indexPath.row)
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(loadingCellIdentifier, forIndexPath: indexPath) as?ASCLoadingCollectionViewCell
        }
        
        
        // if last row (loading cell) is visible then we load more products
        if indexPath.row == numberOfItemsInSection  {
            productsViewModel.loadProducts(searchBar.text,onlyInStock: inStockButton.selected,forceRefresh: false)
        }
        
        return cell!
        
    }
    
}

extension ASCProductsGridViewController : UICollectionViewDelegateFlowLayout {
    
    // MARK: <UICollectionViewDelegateFlowLayout>
    func collectionView( collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                                insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(self.searchBar!.frame.size.height, 0, 0, 0);
    }
    func collectionView (collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let cellLeg = (collectionView.frame.size.width/2) - 5;
        return CGSizeMake(cellLeg,cellLeg);
    }

}

extension ASCProductsGridViewController : ProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductsViewModel, sucess: Bool, errorMsg: String?) {
        
        if self.activityIndicator.isAnimating() {
            self.activityIndicator.stopAnimating()
        }
        isLoaded = true
        self.productsCollectionView.reloadData()
        
        if sucess {
            
        } else {
            // present error
        }
        
    }
}
extension ASCProductsGridViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if productsViewModel.validateSearchText(searchText) {
            loadMoreProducts(searchText, onlyInStock: inStockButton.selected)
        }
    }
    
}

