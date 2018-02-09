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
 The protocol to indicate item of side menu. Every menu item should adopt this protocol.
 */
public protocol SideMenuItemContent {

    /**
     Shows left side menu.
     */
    func showSideMenu()
}

/**
 The extension of SideMenuItemContent protocol implementing `showSideMenu()` method for UIViewController class.
 */
extension SideMenuItemContent where Self: UIViewController {

    public func showSideMenu() {
        if let menuContainerViewController = parent as? MenuContainerViewController {
            menuContainerViewController.showSideMenu()
        } else if let navController = parent as? UINavigationController,
            let menuContainerViewController = navController.parent as? MenuContainerViewController {
            menuContainerViewController.showSideMenu()
        }
    }
}
