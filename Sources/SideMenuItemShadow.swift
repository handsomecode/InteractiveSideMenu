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

    public var color: UIColor? = UIColor.black
    public var opacity: CGFloat = 0.3
    public var offset: CGSize = CGSize(width: -5, height: 5)

    public init() { }

    public init(color: UIColor? = UIColor.black,
                opacity: CGFloat = 0.3,
                offset: CGSize = CGSize(width: -5, height: 5)) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
    }
}
