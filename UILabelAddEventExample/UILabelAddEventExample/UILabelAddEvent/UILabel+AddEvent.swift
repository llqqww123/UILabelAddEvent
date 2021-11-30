//
//  UILabel+AddEvent.swift
//  UILabelAddEventExample
//
//  Created by leiqiwei on 2021/11/24.
//

import UIKit

//MARK: 单击
extension UILabel {
    
    // 确认单机字符串
    private static var singleTapStringKey: String = "singleTapStringKey"
    private var singleTapString: String? {
        set {
            objc_setAssociatedObject(self, &UILabel.singleTapStringKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return (objc_getAssociatedObject(self, &UILabel.singleTapStringKey)) as? String
        }
    }
    
    // 响应事件
    private static var singleTapHandleKey: String = "singleTapHandleKey"
    private var singleTapHandle: (Bool)->Void? {
        set {
            objc_setAssociatedObject(self, &UILabel.singleTapHandleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return ((objc_getAssociatedObject(self, &UILabel.singleTapHandleKey)) as? (Bool)->Void)!
        }
    }
    
    // 添加单击事件
    public func addSingleTapEvent(tapString: String = "", handle: @escaping (Bool)->Void) {
        singleTapString = tapString
        singleTapHandle = handle
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleTap(_:))))
    }
    
    // 单机事件响应
    @objc func singleTap(_ sender: UITapGestureRecognizer) {
        let range: NSRange = NSString(string: text ?? "").range(of: singleTapString ?? "")
        let isMatch: Bool = didTapAttributedTextInLabel(label: self, tap: sender, inRange: range)
        singleTapHandle(isMatch)
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
