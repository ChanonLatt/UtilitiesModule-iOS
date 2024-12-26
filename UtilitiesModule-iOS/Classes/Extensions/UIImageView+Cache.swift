//
//  UIImageView+Cache.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation
import Kingfisher

public extension UIImageView {
    
    func imageCache(url: String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
    }
}
