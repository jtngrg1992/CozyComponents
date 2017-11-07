//
//  NMGCheckBox.swift
//  NmgCheckBox
//
//  Created by Jatin Garg on 11/7/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

class NMGCheckBox: UIControl{
    
    //MARK: Public API
    var checkColor: UIColor = .white{
        didSet{
            checkLayer.strokeColor = checkColor.cgColor
        }
    }
    
    var padding: CGFloat = 4{
        didSet{
            layoutSubviews()
        }
    }
    
    var fillColor: UIColor = .green{
        didSet{
            backgroundColor = fillColor
        }
    }
    
    var borderWidth: CGFloat = 1{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    var borderColor: UIColor = UIColor.gray.withAlphaComponent(0.7){
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    private(set) var isOn: Bool = false
    
    lazy var checkedPath: UIBezierPath = {
        let checkPath = UIBezierPath()
        let startingPoint = CGPoint(x: (self.bounds.width * 0.15) + self.padding, y: (self.bounds.height * 0.65))
        checkPath.move(to: startingPoint)
        let bottomPoint = CGPoint(x: self.bounds.width * 0.45 , y: (self.bounds.height-(self.bounds.height*0.1)) - self.padding)
        checkPath.addLine(to: bottomPoint)
        let endPoint = CGPoint(x: self.bounds.width-(self.bounds.width*0.15) - self.padding, y: self.bounds.height * 0.3)
        checkPath.addLine(to: endPoint)
        return checkPath
    }()
    
    
    func set(On: Bool, animated: Bool){
        if isOn == On{
            return
        }
        checkLayer.strokeColor = On ? checkColor.cgColor : UIColor.clear.cgColor
        
        let duration = animated ? 0.4 : 0
        
        UIView.animate(withDuration: duration) {
            self.backgroundColor = self.isOn ? .clear : self.fillColor
        
        }
        let fromVal = isOn ? 1.0 : 0.0
        let toVal = (fromVal == 1.0) ? 0.0 : 1.0
        
        animateCheck(from: CGFloat(fromVal), to: CGFloat(toVal))
        isOn = !isOn
    }
    
    private func animateCheck(from value: CGFloat, to toVal: CGFloat){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = value
        animation.toValue = toVal
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        checkLayer.add(animation, forKey: "strokeEnd")
    }
    
    convenience init(checked: Bool, fillColor: UIColor, checkColor: UIColor) {
        self.init(frame: .zero)
        self.fillColor = fillColor
        self.checkColor = checkColor
        
        set(On: checked, animated: true)
    }
    
    private var checkLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 30, height: 30)
    }
    
    private func setup(){
        layer.addSublayer(checkLayer)
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.lineWidth = 4
        checkLayer.lineCap = kCALineCapRound
        checkLayer.lineJoin = kCALineJoinRound
        checkLayer.fillColor = UIColor.clear.cgColor
        isUserInteractionEnabled = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkLayer.frame =  bounds
        checkLayer.path = checkedPath.cgPath
        
        if !isOn{
            checkLayer.strokeColor = UIColor.clear.cgColor
        }else{
            checkLayer.strokeColor = checkColor.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:  [.curveEaseInOut, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
        
        set(On: !isOn, animated: true)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
}
