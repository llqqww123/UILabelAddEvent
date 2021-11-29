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
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        let string1 = "string1"
        let string2 = "string2"
        let attString1 = NSAttributedString(string: string1, attributes: [.foregroundColor: UIColor.green, .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        let attString2 = NSAttributedString(string: string2, attributes: [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        let attText = NSMutableAttributedString(attributedString: attString1)
        attText.append(NSAttributedString(string: servicePhoneNum, attributes: [.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 20, weight: .regular), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.blue]))
        attText.append(attString2)
        label.attributedText = attText
        
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
        label.addSingleTapEvent(tapString: servicePhoneNum)
    }
}
