//
//  HomeNavigationTabBar.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


protocol NavigationTabBarDelegate:class {
    func changeToIndex(index:Int)
    
}

class NavigationTabBar: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    public var selectorView: UIView!
    var actionButton: (()->Void)?
    
    
    var textColor:UIColor = .gray
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red
    var heightLineSelect : CGFloat = 2.0
    
    weak var delegate:NavigationTabBarDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    public var positionInX : CGFloat = 0.0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.clear
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    @objc func setIndex(index:Int) {
        self.layoutIfNeeded()
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        selectedIndex = index
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        positionInX = selectorPosition
        delegate?.changeToIndex(index: selectedIndex)
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.changeToIndex(index: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
                btn.titleLabel?.font =  UIFont(name: "Helvetica", size: 15.0)
            }
        }
    }
}

//Configuration View
extension NavigationTabBar {
    
    func updateView() {
        createButton()
        configStackView()
        configSelectorView()
        
    }
    
    private func configStackView() {
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 1.0
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
    }
    
    func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: positionInX, y: self.frame.height-4, width: selectorWidth, height: 5.0))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
        
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.backgroundColor = .clear
            button.addTarget(self, action:#selector(NavigationTabBar.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font =  UIFont(name: "Helvetica", size: 15.0)
            buttons.append(button)
        }
        buttons[selectedIndex].setTitleColor(selectorTextColor, for: .normal)
        buttons[selectedIndex].titleLabel?.font =  UIFont(name: "Helvetica", size: 15.0)
    }
    
    
}
