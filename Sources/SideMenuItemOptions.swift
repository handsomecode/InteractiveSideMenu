//
//  SideMenuItemOptions.swift
//  InteractiveSideMenu
//
//  Created by Eric Miller on 2/8/18.
//  Copyright © 2018 Handsome. All rights reserved.
//

import Foundation

/**
 A struct used to define customization properties for the visible content controller.
 These properties are only applied to the current content controller when the side menu is open.
*/
public struct SideMenuItemOptions {

    /**
     Struct defining the drop shadow properties for the content controller
    */
    public struct Shadow {
        public var color: UIColor? = UIColor.black
        public var opacity: CGFloat = 0.3
        public var offset: CGSize = CGSize(width: -5, height: 5)
        public var radius: CGFloat = 3

        public init() { }

        public init(color: UIColor? = UIColor.black,
                    opacity: CGFloat = 0.3,
                    offset: CGSize = CGSize(width: -5, height: 5),
                    radius: CGFloat = 3) {
            self.color = color
            self.opacity = opacity
            self.offset = offset
            self.radius = radius
        }
    }

    public var shadow = Shadow()

    /**
     Defines the corner radius for the content controller.
     Defaults to 0.0
    */
    public var cornerRadius: CGFloat = 0.0 {
        willSet {
            if newValue < 0 {
                preconditionFailure("Invalid `cornerRadius` value: \(newValue). Must be non-negative")
            }
        }
    }

    public init() { }
}
