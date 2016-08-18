//
//  ViewError.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/16/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

enum KindOfAlert {
    case Negative, Positive, Neutral
}

class MessegeView: UIView {

    @IBInspectable var negativeColor: UIColor = UIColor(netHex:0xCC4025)
    @IBInspectable var positiveColor: UIColor = UIColor(netHex:0x2ECC71)
    @IBInspectable var neutralColor: UIColor = UIColor(netHex:0xF9BF3B)
    var alertViewMovement: CGFloat = 30
    private var alertViewIsAnimating = false
    
    var alertMessageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = neutralColor
        alertViewMovement = frame.size.height
        configLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configLabel()
    }
    
    func configLabel() {
        alertMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        alertMessageLabel.font = UIFont.appFontWithSize(18)
        alertMessageLabel.textColor = UIColor.whiteColor()
        alertMessageLabel.textAlignment = .Center
        alertMessageLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(alertMessageLabel)
    }

    func changeAlert(msg:String, kind:KindOfAlert) {
    
        
        switch kind {
        case .Negative: self.backgroundColor = negativeColor
        case .Neutral:  self.backgroundColor = neutralColor
        case .Positive: self.backgroundColor = positiveColor
        }
        self.alertMessageLabel.text = msg
    }

    func alertIsAnimating() -> Bool {
        return alertViewIsAnimating
    }
    
    func animate() {
        
        if !alertIsAnimating() {
            
            self.alertViewIsAnimating = true
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: { Void in
                self.transform = CGAffineTransformMakeTranslation(0, self.alertViewMovement)
                
                },completion: { _ in
                    
                    UIView.animateWithDuration(0.5, delay: 1.5, options: [.CurveEaseInOut], animations: { Void in
                        self.transform = CGAffineTransformMakeTranslation(0, 0)
                        
                        },completion: { bool in
                            
                            self.alertViewIsAnimating = false
                    })
            })
        }
        
    }

}
