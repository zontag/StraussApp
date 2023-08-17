//
//  UIImageView+Extensions.swift
//  StraussApp
//
//  Created by WK on 13/08/2023.
//

import Foundation
import UIKit

extension UIImageView {

    func load(url: URL) {
        Task(priority: .userInitiated) {
            let image = await ImageCache.shared.getImage(for: url)
            self.image = image
        }
    }
}
