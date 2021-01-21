//
//  ImageExtension.swift
//  TipTop
//
//  Copyright © 2020 ArmiaSystems. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(_ url: String, placeholder: UIImage?) {
        let url = URL(string: url)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: ((placeholder != nil) ? placeholder : #imageLiteral(resourceName: "userTab")),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
