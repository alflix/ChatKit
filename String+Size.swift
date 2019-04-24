//
//  String+Size.swift
//  Ganguo
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

// MARK: - 方便计算某个字体下的 String 在 UILabel 上的宽度或高度
public extension String {
    func heightForLabel(font: UIFont, width: CGFloat) -> CGFloat {
        return autoreleasepool { () -> CGFloat in
            let label: UILabel = UILabel()
            label.numberOfLines = 0
            label.font = font
            label.text = self
            return label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }

    func widthForLabel(font: UIFont, height: CGFloat, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        return autoreleasepool { () -> CGFloat in
            let label: UILabel = UILabel()
            label.numberOfLines = 1
            label.font = font
            label.text = self
            return label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
        }
    }
}
