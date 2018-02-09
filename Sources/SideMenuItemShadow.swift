//
//  SideMenuItemShadow.swift
//  InteractiveSideMenu
//
//  Created by Eric Miller on 2/8/18.
//  Copyright © 2018 Handsome. All rights reserved.
//

import Foundation

/**
 Defines the parameters for the shadow that is shown under to content controller when the side menu is open.
*/
public struct SideMenuItemShadow {

    struct Defaults {
        static var defaultColor: UIColor = UIColor.black
        static var defaultOpacity: CGFloat = 0.3
        static var defaultSize: CGSize = CGSize(width: -5, height: 5)
    }

    public var color: UIColor? = Defaults.defaultColor
    public var opacity: CGFloat = Defaults.defaultOpacity
    public var offset: CGSize = Defaults.defaultSize

    public init() { }

    public init(color: UIColor? = Defaults.defaultColor,
                opacity: CGFloat = Defaults.defaultOpacity,
                offset: CGSize = Defaults.defaultSize) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
    }
}
