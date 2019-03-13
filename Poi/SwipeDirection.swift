//
//  SwipeDirection.swift
//  TinderCard
//
//  Created by HideakiTouhara on 2018/02/28.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import Foundation

public enum SwipeDirection: String {
    case left
    case right

    func rotationAngle(for frame: CGRect) -> CGFloat {
        let direction: CGFloat
        switch self {
        case .left:
            direction = 0.5
        case .right:
            direction = -0.5
        }
        return direction * (frame.width / 2)
    }
}
