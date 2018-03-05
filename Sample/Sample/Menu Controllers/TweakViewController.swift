//
//  TweakViewController.swift
//  Sample
//
//  Created by Eric Miller on 2/9/18.
//  Copyright © 2018 Handsome. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class TweakViewController: UIViewController, Storyboardable {

    @IBOutlet private weak var animationDurationValueLabel: UILabel!
    @IBOutlet private weak var contentScaleValueLabel: UILabel!
    @IBOutlet private weak var visibilityValueLabel: UILabel!
    @IBOutlet private weak var visibilitySlider: UISlider!
    @IBOutlet private weak var rightToLeftSwitch: UISwitch!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        visibilitySlider.maximumValue = Float(UIScreen.main.bounds.width)
        visibilitySlider.value = Float(InteractiveSideMenu.shared.transitionOptions.visibleContentWidth)
        visibilityValueLabel.text = "\(InteractiveSideMenu.shared.transitionOptions.visibleContentWidth)"
        rightToLeftSwitch.isOn = InteractiveSideMenu.shared.transitionOptions.rightToLeft
    }

    deinit {
        print(String(format: "%@ did deinit", String(describing: self)))
    }

    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        InteractiveSideMenu.shared.showSideMenu()
    }

    @IBAction func animationDurationDidChange(_ slider: UISlider) {
        animationDurationValueLabel.text = "\(TimeInterval(slider.value))"
        InteractiveSideMenu.shared.transitionOptions.duration = TimeInterval(slider.value)
    }

    @IBAction func contentScaleDidChange(_ slider: UISlider) {
        contentScaleValueLabel.text = "\(CGFloat(slider.value))"
        InteractiveSideMenu.shared.transitionOptions.contentScale = CGFloat(slider.value)
    }

    @IBAction func visibilityDidChange(_ slider: UISlider) {
        visibilityValueLabel.text = "\(CGFloat(slider.value))"
        InteractiveSideMenu.shared.transitionOptions.visibleContentWidth = CGFloat(slider.value)
    }

    @IBAction func rightToLeftDidChange(_ control: UISwitch) {
        InteractiveSideMenu.shared.transitionOptions.rightToLeft = control.isOn
    }
}
