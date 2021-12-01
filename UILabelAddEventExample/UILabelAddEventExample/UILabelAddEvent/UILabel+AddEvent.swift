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
        let textStorage: NSTextStorage = NSTextStorage()
        let layoutManager: NSLayoutManager = NSLayoutManager()
        let textContainer: NSTextContainer = NSTextContainer()
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = label.textAlignment

        let attributedText = NSMutableAttributedString(attributedString: label.attributedText ?? NSAttributedString())
        attributedText.enumerateAttributes(in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (attributes, range, _) in
            if attributes[.font] == nil {
                attributedText.addAttribute(.font, value: label.font as Any, range: range)
            }
            if attributes[.paragraphStyle] == nil {
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }
        }
        textStorage.setAttributedString(attributedText)

        let textSize = layoutManager.usedRect(for: textContainer)
        var location = tap.location(in: tap.view)
        location.y -= (label.frame.height - textSize.size.height) / 2

        let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
        let fontPointSize = label.font.pointSize
        layoutManager.setAttachmentSize(CGSize(width: fontPointSize, height: fontPointSize), forGlyphRange: NSMakeRange((label.text?.count ?? 0) - 1, 1))
//        let attributedString = label.attributedText?.attributedSubstring(from: NSMakeRange(glyphIndex, 1))
//        print(attributedString?.string as Any)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSMakeRange(glyphIndex, 1), in: textContainer)
        
        
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textSize.size.width) * 0.5 - textSize.origin.x,
            y: (labelSize.height - textSize.size.height) * 0.5 - textSize.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: location.x - textContainerOffset.x,
            y: location.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return glyphRect.contains(location) && NSLocationInRange(indexOfCharacter, targetRange)
    }
}
