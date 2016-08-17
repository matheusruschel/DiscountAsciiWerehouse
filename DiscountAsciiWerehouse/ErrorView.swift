//
//  ViewError.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/16/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    @IBInspectable var errorColor: UIColor = UIColor(netHex:0xCC4025)
    var errorLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = errorColor
        configLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.backgroundColor = errorColor
        configLabel()
    }
    
    func configLabel() {
        errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        errorLabel.font = UIFont.appFontWithSize(18)
        errorLabel.textColor = UIColor.whiteColor()
        errorLabel.textAlignment = .Center
        errorLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(errorLabel)
    }

 

}
