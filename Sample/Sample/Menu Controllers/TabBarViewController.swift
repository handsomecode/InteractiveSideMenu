//
// TabBarViewController.swift
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

/**
 TabBarViewController is a controller relevant one of the side menu items. To indicate this it adopts `SideMenuItemContent` protocol.
 */
class TabBarViewController: UITabBarController, SideMenuItemContent, Storyboardable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        showSideMenu()
    }

}

/**
 The first controller of tab bar.
 */
class FirstViewController: UIViewController { }

/**
 The second controller of tab bar.
 */
class SecondViewController: UIViewController { }
