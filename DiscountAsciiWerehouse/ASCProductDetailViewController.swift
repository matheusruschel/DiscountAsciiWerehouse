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
        fillProductData()
    }
    
    func fillProductData() {
        
        productFaceLabel.text = product.face
        priceLabel.text = "$\(product.price / 100)"
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
        
        productFaceLabel.text = "( ﾟヮﾟ)"
        productFaceLabel.font = UIFont.appFontWithSize(50)
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
