//
// HostViewController.swift
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

class HostViewController: MenuContainerViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
        
        contentViewControllers = contentControllers()

        selectContentViewController(contentViewControllers.first!)
    }
    
    override func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
        return TransitionOptionsBuilder() { builder in
            builder.duration = 0.6
            builder.contentScale = 0.9
        }
    }
    
    private func contentControllers() -> [UIViewController] {
        let controllersIdentifiers = ["Kitty", "TabBar"]
        var contentList = [UIViewController]()
        for identifier in controllersIdentifiers {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
                contentList.append(viewController)
            }
        }
        return contentList
    }
}
