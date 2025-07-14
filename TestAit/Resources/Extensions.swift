//
//  Extensions.swift
//  TestAit
//
//  Created by PEDRO MENDEZ on 14/07/25.
//

import UIKit

extension UIView {
    func addSubview(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice  {
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
}
