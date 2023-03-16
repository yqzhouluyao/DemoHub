//
//  CGImagePropertyOrientation.swift
//  DemoHub
//
//  Created by zhouluyao on 3/17/23.
//

import UIKit

extension CGImagePropertyOrientation {
    init(_ orientation : UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
          fatalError()
        }
    }
}
