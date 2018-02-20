//
// MenuAnimator.swift
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
 The side menu interactive transitioning implementation.
 */
final class MenuInteractiveTransition: NSObject {

    typealias Action = () -> ()

    var present = false
    var interactionInProgress = false
    var currentItemOptions: SideMenuItemOptions

    var options = TransitionOptions()
    fileprivate let presentAction: Action
    fileprivate let dismissAction: Action

    fileprivate var transitionShouldStarted = false
    fileprivate var transitionStarted = false
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    fileprivate var contentSnapshotView: UIView?

    fileprivate var tapRecognizer: UITapGestureRecognizer?
    fileprivate var panRecognizer: UIPanGestureRecognizer?

    required init(currentItemOptions: SideMenuItemOptions, presentAction: @escaping Action, dismissAction: @escaping Action) {
        self.currentItemOptions = currentItemOptions
        self.presentAction = presentAction
        self.dismissAction = dismissAction
        super.init()
    }

    @objc func handlePanPresentation(recognizer: UIPanGestureRecognizer) {
        present = true
        handlePan(recognizer: recognizer)
    }

    @objc func handlePanDismission(recognizer: UIPanGestureRecognizer) {
        present = false
        handlePan(recognizer: recognizer)
    }
}

//MARK: - UIViewControllerInteractiveTransitioning
extension MenuInteractiveTransition: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        startTransition(transitionContext: transitionContext)
    }
}

//MARK: - UIViewControllerAnimatedTransitioning
extension MenuInteractiveTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return options.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startTransition(transitionContext: transitionContext)
        finishTransition(currentPercentComplete: 0)
    }
}

//MARK: - Private methods
private extension MenuInteractiveTransition {
    func startTransition(transitionContext: UIViewControllerContextTransitioning) {
        transitionStarted = true

        self.transitionContext = transitionContext

        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            fatalError("Invalid fromViewController key. Can't start transition")
        }
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            fatalError("Invalid toViewController key. Can't start transition")
        }
        let containerView = transitionContext.containerView
        let screenWidth = containerView.frame.size.width

        if present {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            if tapRecognizer == nil {

                guard toViewController is MenuViewController else {
                    fatalError("Invalid toViewController type. It must be MenuViewController")
                }
                tapRecognizer = UITapGestureRecognizer(target: toViewController,
                                                       action: #selector(MenuViewController.handleTap(recognizer:)))
                panRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(MenuInteractiveTransition.handlePanDismission(recognizer:)))
            }

            contentSnapshotView = createSnapshotView(from: fromViewController.view)

            guard let contentSnapshotView = self.contentSnapshotView else {
                fatalError("Invalid `contentSnapshotView` value. This property should not be nil")
            }

            containerView.addSubview(contentSnapshotView)

            fromViewController.view.isHidden = true
        } else {
            containerView.addSubview(toViewController.view)

            toViewController.view.transform = CGAffineTransform(scaleX: options.contentScale, y: options.contentScale)
            addShadow(to: toViewController.view)

            let newOrigin = CGPoint(x: screenWidth - options.visibleContentWidth, y: toViewController.view.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: toViewController.view.frame.size)

            toViewController.view.frame = rect
        }

        toViewController.view.isUserInteractionEnabled = false
        fromViewController.view.isUserInteractionEnabled = false
    }

    func finishTransition(currentPercentComplete : CGFloat) {
        transitionStarted = false

        let animation: () -> Void = { [unowned self] in self.updateTransition(percentComplete: 1.0) }
        let completion : (Bool) -> Void = { [unowned self] _ in
            guard let transitionContext = self.transitionContext else {
                fatalError("Invalid `transition.transitionContext` value. This property should not be nil")
            }
            guard let contentSnapshotView = self.contentSnapshotView else {
                fatalError("Invalid `transition.contentSnapshotView` value. This property should not be nil")
            }
            guard let fromViewController = transitionContext.viewController(forKey: .from) else {
                fatalError("Invalid fromViewController key. Can't finish transition")
            }
            guard let toViewController = transitionContext.viewController(forKey: .to) else {
                fatalError("Invalid toViewController key. Can't finish transition")
            }

            if self.present {
                fromViewController.view.isHidden = false
                contentSnapshotView.removeFromSuperview()

                if let panRecognizer = self.panRecognizer {
                    contentSnapshotView.addGestureRecognizer(panRecognizer)
                }
                if let tapRecognizer = self.tapRecognizer {
                    contentSnapshotView.addGestureRecognizer(tapRecognizer)
                }

                toViewController.view.addSubview(contentSnapshotView)
            } else {
                toViewController.view.isHidden = false
                self.removeShadow(from: toViewController.view)
            }

            toViewController.view.isUserInteractionEnabled = true
            fromViewController.view.isUserInteractionEnabled = true

            transitionContext.completeTransition(true)
        }

        if options.useFinishingSpringSettings {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           usingSpringWithDamping: present ? options.finishingSpringSettings.presentSpringParams.dampingRatio : options.finishingSpringSettings.dismissSpringParams.dampingRatio,
                           initialSpringVelocity: present ? options.finishingSpringSettings.presentSpringParams.velocity : options.finishingSpringSettings.dismissSpringParams.velocity,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        } else {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        }
    }

    func createSnapshotView(from: UIView) -> UIView {
        guard let snapshotView = from.snapshotView(afterScreenUpdates: true) else {
            print("Invalid snapshot view. Default color will be used")
            let placeholderView = UIView(frame: from.frame)
            placeholderView.backgroundColor = from.backgroundColor
            addShadow(to: placeholderView)
            return placeholderView
        }

        snapshotView.layer.cornerRadius = currentItemOptions.cornerRadius
        snapshotView.layer.masksToBounds = true

        let baseView = UIView(frame: from.bounds)
        baseView.addSubview(snapshotView)
        addShadow(to: baseView)
        return baseView
    }

    func addShadow(to view: UIView) {
        view.layer.shadowColor = currentItemOptions.shadow.color?.cgColor
        view.layer.shadowOpacity = Float(currentItemOptions.shadow.opacity)
        view.layer.shadowOffset = currentItemOptions.shadow.offset
        view.layer.shadowRadius = currentItemOptions.shadow.radius
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: currentItemOptions.cornerRadius).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }

    func removeShadow(from view: UIView) {
        view.layer.shadowColor = nil
        view.layer.shadowOpacity = 0.0
        view.layer.shadowOffset = .zero
    }

    func cancelTransition(currentPercentComplete : CGFloat) {
        transitionStarted = false

        let animation : () -> Void = { [unowned self] in self.updateTransition(percentComplete: 0) }
        let completion : (Bool) -> Void = { [unowned self] _ in
            guard let transitionContext = self.transitionContext else {
                fatalError("Invalid `transition.transitionContext` value. This property should not be nil")
            }
            guard let contentSnapshotView = self.contentSnapshotView else {
                fatalError("Invalid `transition.contentSnapshotView` value. This property should not be nil")
            }
            guard let fromViewController = transitionContext.viewController(forKey: .from) else {
                fatalError("Invalid fromViewController key. Can't cancel transition")
            }
            guard let toViewController = transitionContext.viewController(forKey: .to) else {
                fatalError("Invalid toViewController key. Can't cancel transition")
            }

            if self.present {
                fromViewController.view.isHidden = false
            } else {
                toViewController.view.removeFromSuperview()
                contentSnapshotView.isHidden = false
                fromViewController.view.isUserInteractionEnabled = true
            }

            toViewController.view.isUserInteractionEnabled = true
            fromViewController.view.isUserInteractionEnabled = true

            transitionContext.completeTransition(false)
        }

        if options.useCancellingSpringSettings {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           usingSpringWithDamping: present ? options.cancellingSpringSettings.presentSpringParams.dampingRatio : options.cancellingSpringSettings.dismissSpringParams.dampingRatio,
                           initialSpringVelocity: present ? options.cancellingSpringSettings.presentSpringParams.velocity : options.cancellingSpringSettings.dismissSpringParams.velocity,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        } else {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        }
    }

    func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            fatalError("Invalid recognizer view value")
        }
        let translation = recognizer.translation(in: recognizerView)
        let dx = translation.x / recognizerView.bounds.width
        let progress: CGFloat = abs(dx)
        var velocity = recognizer.velocity(in: recognizerView).x

        if !present {
            velocity = -velocity
        }

        switch recognizer.state {
        case .began:
            interactionInProgress = true

            if velocity >= 0 {
                transitionShouldStarted = true
                if present {
                    presentAction()
                } else {
                    dismissAction()
                }
            }

        case .changed:
            if transitionStarted && (present && dx > 0 || !present && dx < 0) {
                guard let transitionContext = transitionContext else {
                    fatalError("Invalid `transitionContext` value. This property should not be nil")
                }
                updateTransition(percentComplete: progress)
                transitionContext.updateInteractiveTransition(progress)
            }

        case .cancelled, .ended:
            if transitionStarted {
                guard let transitionContext = transitionContext else {
                    fatalError("Invalid `transitionContext` value. This property should not be nil")
                }
                if progress > 0.4, velocity >= 0 || progress > 0.01, velocity > 100 {
                    finishTransition(currentPercentComplete: progress)
                    transitionContext.finishInteractiveTransition()
                } else {
                    cancelTransition(currentPercentComplete: progress)
                    transitionContext.cancelInteractiveTransition()
                }

            } else if transitionShouldStarted, !transitionStarted {
                if transitionStarted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        guard let transitionContext = self.transitionContext else {
                            fatalError("Invalid `transitionContext` value. This property should not be nil")
                        }
                        if self.transitionStarted {
                            self.cancelTransition(currentPercentComplete: progress)
                            transitionContext.cancelInteractiveTransition()
                        }
                    }
                }
            }

            transitionShouldStarted = false
            interactionInProgress = false

        default:
            break
        }
    }

    func updateTransition(percentComplete: CGFloat) {
        guard let transitionContext = self.transitionContext else {
            fatalError("Invalid `transitionContext` value. This property should not be nil")
        }
        let containerView = transitionContext.containerView
        let screenWidth = containerView.frame.size.width

        let totalWidth = screenWidth - options.visibleContentWidth

        guard let contentSnapshotView = self.contentSnapshotView else {
            fatalError("Invalid `contentSnapshotView` value. This property should not be nil")
        }

        if present {
            let newScale = 1 - (1 - options.contentScale) * percentComplete
            let newX = totalWidth * percentComplete

            contentSnapshotView.transform = CGAffineTransform(scaleX: newScale, y: newScale)

            let newOrigin = CGPoint(x: newX, y: contentSnapshotView.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: contentSnapshotView.frame.size)

            contentSnapshotView.frame = rect
        } else {
            contentSnapshotView.isHidden = true

            guard let toViewController = transitionContext.viewController(forKey: .to) else {
                fatalError("Invalid toViewController key. Can't update transition")
            }
            let newX = totalWidth * (1 - percentComplete)

            let newScale = options.contentScale + (1 - options.contentScale) * percentComplete
            toViewController.view.transform = CGAffineTransform(scaleX: newScale, y: newScale)

            let newOrigin = CGPoint(x: newX, y: toViewController.view.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: toViewController.view.frame.size)

            toViewController.view.frame = rect
        }
    }
}
