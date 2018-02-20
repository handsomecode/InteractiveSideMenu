//
// SideMenuItemContent.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

/**
 A struct representing a side menu item.
 The `classType`'s object gets instantiated when the user selects the content from the MenuViewController.
 */
public struct SideMenuItemContent {
    public let menuTitle: String
    public let classType: UIViewController.Type
    public let menuImage: UIImage?

    public init(menuTitle: String, menuImage: UIImage? = nil, classType: UIViewController.Type) {
        self.menuTitle = menuTitle
        self.menuImage = menuImage
        self.classType = classType
    }
}
