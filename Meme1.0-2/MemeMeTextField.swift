//
//  MemeMeTextField.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 12/05/22.
//

import UIKit

public class MemeMeTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        defaultTextAttributes = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -3.0
        ]
       textAlignment = .center
       adjustsFontSizeToFitWidth = true
       clearsOnBeginEditing = false
    }
    
    public func set(text: String) {
        self.text = text
    }
}
