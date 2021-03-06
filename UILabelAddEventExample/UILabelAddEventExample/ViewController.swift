//
//  ViewController.swift
//  UILabelAddEventExample
//
//  Created by leiqiwei on 2021/11/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let servicePhoneNum: String = "400-921-5767"
    let string1 = "string1string1string1string1string1string1"
    let string2 = "string2"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        
        // attributedText
        let attString1 = NSAttributedString(string: string1, attributes: [.foregroundColor: UIColor.green, .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        let attString2 = NSAttributedString(string: string2, attributes: [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 40, weight: .regular)])
        let attText = NSMutableAttributedString(attributedString: attString1)
        attText.append(NSAttributedString(string: servicePhoneNum, attributes: [.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 20, weight: .regular), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.blue]))
        attText.append(attString2)
        label.attributedText = attText
        
        // text
//        label.text = string1 + servicePhoneNum + string2
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        initial()
    }

    func setupUI() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(10)
        }
    }
    
    func initial() {
        label.addSingleTapEvent(string: servicePhoneNum) {
            print("点击了servicePhoneNum")
        }
        
        label.addSingleTapEvent(string: string1) {
            print("点击了string1")
        }
        
        label.addSingleTapEvent(string: string2) {
            print("点击了string2")
        }
        
        label.addLongPressEvent(string: servicePhoneNum) {
            print("长按了servicePhoneNum")
        }
        
        label.addLongPressEvent(string: string1) {
            print("长按了string1")
        }
        
        label.addLongPressEvent(string: string2) {
            print("长按了string2")
        }
    }
}

