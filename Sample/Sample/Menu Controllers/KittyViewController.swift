//
// KittyViewController.swift
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
import InteractiveSideMenu

class KittyViewController: UIViewController, Storyboardable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        InteractiveSideMenu.shared.delegate = self
    }

    // Show side menu on menu button click
    @IBAction func openMenu(_ sender: UIButton) {
        InteractiveSideMenu.shared.showSideMenu()
    }
}

extension KittyViewController: InteractiveSideMenuDelegate {
    func interactiveSideMenu(_ sideMenu: InteractiveSideMenu, didChangeMenuState menuState: MenuState) {
        print("Menu State did change: \(menuState.rawValue)")
    }
}
