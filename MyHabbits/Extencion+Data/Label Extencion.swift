//
//  Label Extencion.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 18.04.2022.
//

import UIKit

extension UILabel {
    static func titleFor(input title: String) -> UILabel {
        let label = UILabel()
        
        label.text = title.uppercased()
        label.font = StyleStuct.Font.footnoteCapitalized
        
        return label
    }
    
    func setText(_ text: String, animated: Bool) {
        if !animated {
            self.text = text
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in
            self.text = text
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
            }
        }
    }
}
