//
//  UISearchBar+.swift
//  GGUI
//
//  Created by John on 2019/5/17.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

/// UISearchBar 的快速设置
public extension UISearchBar {
    /// 输入框
    var searchField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }

    /// 占位文字 Label
    var placeholderLabel: UILabel? {
        return textField?.value(forKey: "placeholderLabel") as? UILabel
    }

    /// 🔍
    var icon: UIImageView? {
        return textField?.leftView as? UIImageView
    }

    /// 🔍 和 占位文字 Label 和之间的间距的总宽度
    var placeholderWidth: CGFloat {
        let space = searchTextPositionAdjustment.horizontal
        var placeholderLabelWidth = placeholderLabel!.width
        if placeholderLabelWidth <= 0 {
            placeholderLabelWidth = placeholderLabel!.text?.widthForLabel(font: placeholderLabel!.font, height: 32) ?? 0
        }
        return placeholderLabelWidth + icon!.width + space
    }

    /// 🔍 颜色
    var iconColor: UIColor? {
        get {
            return icon?.tintColor
        }
        set {
            icon?.image = icon?.image?.withRenderingMode(.alwaysTemplate)
            icon?.tintColor = newValue
        }
    }

    /// UISearchBar在ios11上的placeHolder和icon默认居左, 可以通过这个方法使之居中
    ///
    /// - Parameter serchBarWidth: 通过计算得出的 serchBar width
    func setPositionAtCenter(serchBarWidth: CGFloat) {
        if #available(iOS 11.0, *) {
            let originalIconX: CGFloat = 14.0
            let offset = (serchBarWidth - placeholderWidth)/2 - originalIconX
            setPositionAdjustment(UIOffset(horizontal: offset, vertical: 0), for: .search)
        }
    }

    /// 使placeHolder和icon的位置恢复
    func setPositionAtLeft() {
        setPositionAdjustment(.zero, for: .search)
    }
}
