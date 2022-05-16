//
//  UIViewController+Ext.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 16/05/22.
//

import UIKit

extension UIViewController {
    //MARK: UI Functions
    internal func toggleViewVisibility(component: UIView, isHidden: Bool) {
        component.isHidden = isHidden
    }
    
    
    internal func toggleBarItemState(component: UIBarItem, isEnabled: Bool) {
        component.isEnabled = isEnabled
    }
    
}
