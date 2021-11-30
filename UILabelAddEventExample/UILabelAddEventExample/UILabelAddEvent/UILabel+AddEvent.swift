//
//  UILabel+AddEvent.swift
//  UILabelAddEventExample
//
//  Created by leiqiwei on 2021/11/24.
//

import UIKit

//MARK: 单击
extension UILabel {
    
    // 是否是第一次添加事件
    private static var hasTapEventKey: String = "hasTapEventKey"
    private var hasTap: Bool? {
        set {
            objc_setAssociatedObject(self, &UILabel.hasTapEventKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return (objc_getAssociatedObject(self, &UILabel.hasTapEventKey)) as? Bool
        }
    }
    
    // 单机事件集合(存储所有添加的点击事件)
    private static var singleTapEventsDicKey: String = "singleTapEventsDicKey"
    private var singleTapEventsDic: [String: ()->Void]? {
        set {
            objc_setAssociatedObject(self, &UILabel.singleTapEventsDicKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return (objc_getAssociatedObject(self, &UILabel.singleTapEventsDicKey)) as? [String: ()->Void]
        }
    }
    
    // 添加单击事件
    public func addSingleTapEvent(tapString: String = "", handle: @escaping ()->Void) {
        
        if let _ = singleTapEventsDic {
            singleTapEventsDic![tapString] = handle
        }else {
            singleTapEventsDic = [String: ()->Void]()
            singleTapEventsDic![tapString] = handle
        }
        
        // 判断是否已经添加过单机事件
        if !(hasTap ?? false) {
            hasTap = true
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleTap(_:))))
        }
    }
    
    // 单机事件响应
    @objc func singleTap(_ sender: UITapGestureRecognizer) {
        for key in singleTapEventsDic!.keys {
            let range: NSRange = NSString(string: text ?? "").range(of: key)
            let isMatch: Bool = didTapAttributedTextInLabel(label: self, tap: sender, inRange: range)
            if isMatch {
                singleTapEventsDic![key]!()
            }
        }
    }
    
    // 判断点击位置
    private func didTapAttributedTextInLabel(label: UILabel, tap: UITapGestureRecognizer, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = tap.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
