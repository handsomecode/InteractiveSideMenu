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

/**
 HostViewController is container view controller, contains menu controller and the list of relevant view controllers.

 Responsible for creating and selecting menu items content controlers.
 Has opportunity to show/hide side menu.
 */
class HostViewController: MenuContainerViewController {

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)

        // Instantiate menu view controller by identifier
        self.menuViewController = SampleMenuViewController.storyboardViewController()

        // Gather content items controllers
        self.contentViewControllers = contentControllers()

        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(contentViewControllers.first!)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Options to customize menu transition animation.
        var options = TransitionOptions()

        // Animation duration
        options.duration = size.width < size.height ? 0.4 : 0.6

        // Part of item content remaining visible on right when menu is shown
        options.visibleContentWidth = size.width / 6
        self.transitionOptions = options
    }

    private func contentControllers() -> [UIViewController] {
        let kittyController = KittyViewController.storyboardViewController()
        let tabController = TabBarViewController.storyboardNavigationController()
        let tweakController = TweakViewController.storyboardNavigationController()

        return [kittyController, tabController, tweakController]
    }
}
