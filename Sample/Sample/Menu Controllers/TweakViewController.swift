//
//  TweakViewController.swift
//  Sample
//
//  Created by Eric Miller on 2/9/18.
//  Copyright © 2018 Handsome. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class TweakViewController: UIViewController, SideMenuItemContent, Storyboardable {

    @IBOutlet private weak var animationDurationValueLabel: UILabel!
    @IBOutlet private weak var contentScaleValueLabel: UILabel!
    @IBOutlet private weak var visibilityValueLabel: UILabel!
    @IBOutlet private weak var visibilitySlider: UISlider!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        visibilitySlider.maximumValue = Float(UIScreen.main.bounds.width)
        if let navController = parent as? UINavigationController,
            let menuContainerController = navController.parent as? MenuContainerViewController {
            visibilitySlider.value = Float(menuContainerController.transitionOptions.visibleContentWidth)
            visibilityValueLabel.text = "\(menuContainerController.transitionOptions.visibleContentWidth)"
        }
    }

    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        showSideMenu()
    }

    @IBAction func animationDurationDidChange(_ slider: UISlider) {
        animationDurationValueLabel.text = "\(TimeInterval(slider.value))"
        if let navController = parent as? UINavigationController,
            let menuContainerController = navController.parent as? MenuContainerViewController {
            menuContainerController.transitionOptions.duration = TimeInterval(slider.value)
        }
    }

    @IBAction func contentScaleDidChange(_ slider: UISlider) {
        contentScaleValueLabel.text = "\(CGFloat(slider.value))"
        if let navController = parent as? UINavigationController,
            let menuContainerController = navController.parent as? MenuContainerViewController {
            menuContainerController.transitionOptions.contentScale = CGFloat(slider.value)
        }
    }

    @IBAction func visibilityDidChange(_ slider: UISlider) {
        visibilityValueLabel.text = "\(CGFloat(slider.value))"
        if let navController = parent as? UINavigationController,
            let menuContainerController = navController.parent as? MenuContainerViewController {
            menuContainerController.transitionOptions.visibleContentWidth = CGFloat(slider.value)
        }
    }
}
