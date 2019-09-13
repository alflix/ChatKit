//
//  UIViewController+.swift
//  GGUI
//
//  Created by John on 2018/12/29.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIViewController {
    /// 获取当前的 controller，这个方法不应该滥用
    static var current: UIViewController? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        var tempView: UIView?
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tempView = subview
                break
            }
        }

        if tempView == nil {
            tempView = window.subviews.last
        }

        var nextResponder = tempView?.next
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }

        while next {
            tempView = tempView?.subviews.first
            if tempView == nil {
                return nil
            }
            nextResponder = tempView!.next
        }
        return nextResponder as? UIViewController
    }

    /// 获取当前的 controller (前提是 UITabBarController 是 window.rootViewController )
    static var currentTabBarController: UITabBarController? {
        guard let window = UIApplication.shared.windows.first,
            let tabBarController = window.rootViewController as? UITabBarController
            else { return nil }
        return tabBarController
    }

    /// 检查是否是 present 出来的
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    /// dismiss/popToRootViewController 取决于是否是 present 出来的
    func popToRootOrDismiss() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }

    /// dismiss/popToRootViewController 取决于是否是 present 出来的
    @objc func popBackOrDismiss() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    /// 寻找目标控制器（需要从前往后找，rootViewController 或 navigationController）
    ///
    /// - Parameter name: 控制器名称
    /// - Returns: 控制器
    func findTargerController(byName name: String) -> UIViewController? {
        let targetClass: AnyClass? = NSObject.swiftClassFromString(name)
        var targetViewController: UIViewController?
        children.forEach { (childController) in
            if object_getClass(childController) == targetClass {
                targetViewController = childController
            } else if let presentedController = childController.presentedNavigationController {
                targetViewController = presentedController.findTargerController(byName: name)
            }
        }
        return targetViewController
    }

    /// 全屏 present 方法（以兼容 iOS 13）
    func fullPresent(_ viewControllerToPresent: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

extension UIViewController {
    /// 寻找当前 presented 的 UINavigationController 控制器
    var presentedNavigationController: UINavigationController? {
        let target = presentedViewController
        if target == nil {
            return nil
        } else if let target = target as? UINavigationController {
            return target
        } else {
            return target!.presentedNavigationController
        }
    }
}
