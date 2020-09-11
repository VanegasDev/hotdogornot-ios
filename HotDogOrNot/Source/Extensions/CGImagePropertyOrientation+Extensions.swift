//
//  CGImagePropertyOrientation+Extensions.swift
//  HotDogOrNot
//
//  Created by Mario Vanegas on 9/11/20.
//  Copyright © 2020 vanegasmario. All rights reserved.
//

import UIKit

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        default: self = .up
        }
    }
}
