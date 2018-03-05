//
// MenuViewController.swift
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

protocol MenuViewControllerDelegate: class {
    func menuController(_ menuController: MenuViewController, showContentController contentController: UIViewController)
}

/**
 The base class for the Side Menu.
*/
open class MenuViewController: UIViewController {

    public var itemContentControllers: [SideMenuItemContent]?
    public var sectionItemContentControllers: [[SideMenuItemContent]]?

    weak var delegate: MenuViewControllerDelegate?
}

public extension MenuViewController {
    /**
     Notifies the system to select the initial content controller to display.
     */
    func selectInitialContentController(_ contentController: UIViewController) {
        delegate?.menuController(self, showContentController: contentController)
    }

    /**
     Notifies the system that a new controller has been select and the layout should update accordingly.
     If overriding, remember to call super at the end of your implementation.
    */
    func selectSideItemContent(_ contentController: UIViewController) {
        delegate?.menuController(self, showContentController: contentController)
        InteractiveSideMenu.shared.closeSideMenu()
    }
}
