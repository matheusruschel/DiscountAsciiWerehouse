//
//  ASCProductDetailViewController.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/3/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class ASCProductDetailViewController: UIViewController {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var productFaceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var product: ASCProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        modifyViewContentForProduct()
    }
    
    func modifyViewContentForProduct() {
        
        productFaceLabel.text = "\(product.face)\u{0000FE0E}"
        priceLabel.text = "$\(product.price / 100)"

        if product.stock == 1 {
            
            let labelButtonBuyTitle = UILabel(frame:
                CGRect(
                    x: 0,
                    y: 0,
                    width: UIScreen.mainScreen().bounds.size.width,
                    height: buyButton.frame.height))
            labelButtonBuyTitle.font = UIFont.appFontWithSize(30)
            labelButtonBuyTitle.textColor = UIColor.whiteColor()
            labelButtonBuyTitle.textAlignment = .Center
            
            let labelButtonBuySubTitle = UILabel(frame:
                CGRect(
                    x: 0,
                    y: buyButton.frame.height * 0.7,
                    width: UIScreen.mainScreen().bounds.size.width,
                    height: buyButton.frame.height * 0.2))
            labelButtonBuySubTitle.font = UIFont.appFontWithSize(20)
            labelButtonBuySubTitle.textAlignment = .Center
            
            labelButtonBuyTitle.text = "BUY NOW!"
            labelButtonBuySubTitle.text = "(Only 1 more in stock!)"
            labelButtonBuySubTitle.textColor = UIColor.whiteColor()
            buyButton.setTitle("", forState: .Normal)
            
            buyButton.addSubview(labelButtonBuyTitle)
            buyButton.addSubview(labelButtonBuySubTitle)

        } else if product.stock == 0 {
            buyButton.setTitle("OUT OF STOCK ;/", forState: .Normal)
        }
        self.view.setNeedsLayout()
        
        
    }
    
    func configure() {
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        let cancelButtonImage = cancelButton.currentImage
        let tintedImage = cancelButtonImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cancelButton.setImage(tintedImage, forState: .Normal)
        cancelButton.tintColor = UIColor.whiteColor()
        
        
        buyButton.backgroundColor = UIColor.grayColor()
        buyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buyButton.titleLabel!.font = UIFont.appFontWithSize(30)
        
        buyButton.addTarget(self, action: #selector(buttonHighlight), forControlEvents: .TouchDown)
        priceLabel.font = UIFont.appFontWithSize(20)
        
        productFaceLabel.font = UIFont.appFontWithSize(50)
        productFaceLabel.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonHighlight(sender: UIButton) {
        sender.backgroundColor = UIColor(netHex:0xCC4025)
        
    }
    
    @IBAction func buyButtonClicked(sender: UIButton) {
        self.buyButton.backgroundColor = UIColor.grayColor()
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
