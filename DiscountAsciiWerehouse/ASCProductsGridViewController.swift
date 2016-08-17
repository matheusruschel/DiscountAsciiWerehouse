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
    var searchBar: UISearchBar!
    var searchBarBoundsY: CGFloat!
    var inStockLabel: UILabel!
    var inStockButton: UIButton!
    var onlyInStockSelectedChanged = false
    var viewError: ErrorView!
    var errorViewMovement: CGFloat = 30
    var errorViewIsAnimating = false
    var loadCellButtonEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        self.productsViewModel.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareUI()
    }
    
    // MARK: Button action
    func checkboxToggle() {
        self.inStockButton.selected = !self.inStockButton.selected
        loadProductsByChangingParameters()
        
    }
    
    // MARK: UI Configuration
    func prepareUI() {
        configureSearchController()
        configureInStockLabel()
        configureInStockButton()
        configureErrorView()
    }
    
    func configureErrorView() {
        
        if self.viewError == nil {
            let y = -errorViewMovement
            
            self.viewError = ErrorView(frame: CGRect(
                x: 0,
                y: y,
                width: UIScreen.mainScreen().bounds.size.width,
                height: errorViewMovement))
            self.view.addSubview(self.viewError)
        }
        
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
            self.inStockLabel.adjustsFontSizeToFitWidth = true
            
            self.view.addSubview(self.inStockLabel)
        }
    }
    
    func configureSearchController() {
        
        if self.searchBar == nil{
            searchBarBoundsY = 0
            
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
    
    // MARK: Show error view
    
    func showErrorView(msg: String) {
        
        if !self.errorViewIsAnimating {
            
            self.viewError.errorLabel.text = msg
            self.errorViewIsAnimating = true

            UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: { Void in
                self.viewError.transform = CGAffineTransformMakeTranslation(0, self.errorViewMovement)
                
                },completion: { _ in
                    
                    UIView.animateWithDuration(0.5, delay: 1.5, options: [.CurveEaseInOut], animations: { Void in
                        self.viewError.transform = CGAffineTransformMakeTranslation(0, 0)
                    
                        },completion: { bool in
                    
                            self.errorViewIsAnimating = false
                        })
            })
        }
    }

    //MARK: Observers
    
    func addObservers(){
        let context = UnsafeMutablePointer<UInt8>(bitPattern: 1)
        self.productsCollectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.New,.Old], context: context)
    }
    
    func removeObservers(){
        self.productsCollectionView?.removeObserver(self, forKeyPath: "contentOffset")
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
                    height: self.inStockLabel.frame.height
                )
                
                self.inStockButton?.frame = CGRect(
                    x: self.inStockButton.frame.origin.x,
                    y: self.searchBarBoundsY! + ( (-1 * collectionV.contentOffset.y)),
                    width: self.inStockButton.frame.width,
                    height: self.inStockButton.frame.height
                )
            }
            
            
        }
    }
    
    // MARK: Navigation
    
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
    func loadProductsByChangingParameters() {
        
        // cancels previous request if user is still typing
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        
        // validates search string
        if self.productsViewModel.validateSearchText(searchBar.text) {
            self.productsViewModel.clearProductsList()
            loadCellButtonEnabled = false
            dispatch_async(dispatch_get_main_queue(), {
                self.productsCollectionView.reloadData()
            })
        }

    }
    
    func loadMoreProducts() {
        productsViewModel.loadProducts(searchBar.text,onlyInStock: inStockButton.selected,forceRefresh: false)
    }
    
    //MARK: Dismiss Keyboard
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    //MARK: Deinitialization
    deinit{
        self.removeObservers()
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsViewModel.numberOfItemsInSection
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
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(loadingCellIdentifier, forIndexPath: indexPath) as! ASCLoadingCollectionViewCell
            (cell as! ASCLoadingCollectionViewCell).delegate = self
            
            if loadCellButtonEnabled {
                (cell as! ASCLoadingCollectionViewCell).switchMode(.LoadMore)
            } else {
                (cell as! ASCLoadingCollectionViewCell).switchMode(.Spinner)
            }
        }
        
        // if last row (loading cell) is visible then we load more products
        if indexPath.row == numberOfItemsInSection  {
            
            if let cellLoading = cell as? ASCLoadingCollectionViewCell {
                
                if cellLoading.mode == .Spinner {
                    self.performSelector(#selector(loadMoreProducts), withObject: nil, afterDelay: 0.3)
                }
            }
           
        }
        
        return cell!
        
    }
    
}
extension ASCProductsGridViewController : LoadingCellDelegate {
    
    func buttonLoadMoreClicked(cell:ASCLoadingCollectionViewCell) {
        productsViewModel.loadProducts(searchBar.text,onlyInStock: inStockButton.selected,forceRefresh: false)
        loadCellButtonEnabled = false
    }
}

extension ASCProductsGridViewController : ProductCoordinatorDelegate {
    
    func coordinatorDidFinishLoadingProducts(viewModel: ASCProductsViewModel, status: FetchStatus) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.productsCollectionView.reloadData()
            
            switch status {
            case .NoResultsFound:
                self.loadCellButtonEnabled = true
            case .Error(let msg):
                self.showErrorView(msg)
                self.loadCellButtonEnabled = true
            default: self.loadCellButtonEnabled = false
            }
    
        })
        
    }
    
    func coordinatorDidStartSearching(viewModel: ASCProductsViewModel) {
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
        loadProductsByChangingParameters()
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

