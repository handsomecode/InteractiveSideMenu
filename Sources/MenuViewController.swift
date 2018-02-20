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

open class MenuViewController: UIViewController {

    public var contentControllerTypes = [SideMenuItemContent]()

    weak var delegate: MenuViewControllerDelegate?
}

extension MenuViewController {
    /**
     Be default, closes the side drawer menu.  Override to perform any additional logic.
     Be sure to call super at the end of your override to ensure the menu closes properly.
    */
    open func selectSideItemContent(_ contentController: UIViewController) {
        delegate?.menuController(self, showContentController: contentController)
    }
}
