//
//  ASCCustomSearchControllerViewController.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class ASCCustomSearchController: UISearchController {

    var customBar: ASCCustomSearchBar!
    var customDelegate: CustomSearchControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        customBar = ASCCustomSearchBar(frame: frame, font: font , textColor: textColor)
        
        customBar.barTintColor = bgColor
        customBar.tintColor = textColor
        customBar.showsBookmarkButton = false
        customBar.showsCancelButton = true
        customBar.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
extension ASCCustomSearchController:  UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        customDelegate?.didStartSearching()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        customBar.resignFirstResponder()
        customDelegate?.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        customBar.resignFirstResponder()
        customDelegate?.didTapOnCancelButton()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate?.didChangeSearchText(searchText)
    }
    
}