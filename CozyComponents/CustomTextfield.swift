//
//  CustomTextfield.swift
//  NocturnalTextField
//
//  Created by Jatin Garg on 12/21/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

@objc protocol CustomTextFieldDelegate: class{
    @objc optional func textFieldDidBeginEditing(_ textfield: CustomTextfield)
    @objc optional func textFieldDidEndEditing(_ textField: CustomTextfield)
    @objc optional func textFieldShouldReturn(_ textField: CustomTextfield) -> Bool
}

class CustomTextfield: UIView, UITextFieldDelegate{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var leftImageview: UIImageView!
    @IBOutlet weak var rightImageBtn: UIButton!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeholderBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var rightImageBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfieldLeadingConstraintFromSuperview: NSLayoutConstraint!
    @IBOutlet weak var textfieldLeadingConstraintFromImage: NSLayoutConstraint!
    var text: String?{
        return textField.text
    }
    
    weak var delegate: CustomTextFieldDelegate?
    fileprivate var rightImageBtnWidth: CGFloat!
    
    @IBInspectable var leftImage: UIImage?{
        didSet{
            guard let newImage = leftImage else {
                //remove imageView
                hideleftImage()
                return
            }
            showLeftImage(usingImage: newImage)
        }
    }
    
    @IBInspectable var rightImage: UIImage?{
        didSet{
            guard let newImage = rightImage else{
                //hideBtn
                toggleRightBtn(shouldShow: false)
                return
            }
            
            toggleRightBtn(shouldShow: true)
            rightImageBtn.setImage(newImage, for: .normal)
        }
    }
    
    @IBInspectable var placeholderText: String? = "Placeholder"{
        didSet{
            placeholderLabel.text = placeholderText
        }
    }
    
    @IBInspectable var placeholderFont: UIFont = UIFont(name: "Avenir Next", size: 14)!{
        didSet{
            placeholderLabel.font = placeholderFont
        }
    }
    
    @IBInspectable var animationDuration: TimeInterval = 0.4
    @IBInspectable var placeholderSizePreEdit: CGFloat = 14{
        didSet{
            if editingMode == .notEditing{
                placeholderLabel.font = placeholderLabel.font.withSize(placeholderSizePreEdit)
            }
        }
    }
    @IBInspectable var placeholderSizeDuringEdit: CGFloat = 10{
        didSet{
            if editingMode == .editing{
                placeholderLabel.font = placeholderLabel.font.withSize(placeholderSizeDuringEdit)
            }
        }
    }
    @IBInspectable var placeholderColor: UIColor = .white{
        didSet{
            if editingMode == .notEditing{
                placeholderLabel.textColor = placeholderColor
            }
        }
    }
    @IBInspectable var placeholderColorDuringEdit: UIColor = .yellow{
        didSet{
            if editingMode == .editing{
                placeholderLabel.textColor = placeholderColorDuringEdit
            }
        }
    }
    @IBInspectable var font: UIFont = UIFont(name: "Avenir Next", size: 15)!{
        didSet{
            textField.font = font
        }
    }
    
    
    
    enum EditingMode{
        case editing, notEditing
    }
    
    var editingMode: EditingMode = .notEditing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup(){
        guard let nib = Bundle.main.loadNibNamed("CustomTextfield", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        addSubview(nib)
        nib.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        nib.frame = bounds
        
        switchFromEditingMode()
        
        if leftImage == nil {
            hideleftImage()
        }else{
            showLeftImage(usingImage: leftImage!)
        }
        
        rightImageBtnWidth = rightImageBtnWidthConstraint.constant
        
        if rightImage == nil{
            toggleRightBtn(shouldShow: false)
        }else{
            toggleRightBtn(shouldShow: true)
            rightImageBtn.setImage(rightImage!, for: .normal)
        }
        
        placeholderLabel.font = placeholderFont
        textField.font = font
    }
    
    
    
    private func switchToEditingMode(){
        if !placeholderBottomConstraint.isActive{
            placeholderBottomConstraint.isActive = true
        }
        placeholderBottomConstraint.priority = .defaultHigh
        centerConstraint.priority = .defaultLow
        
        
        placeholderLabel.font = placeholderLabel.font.withSize(placeholderSizeDuringEdit)
        
        UIView.animate(withDuration: animationDuration) {
            self.placeholderLabel.textColor = self.placeholderColorDuringEdit
        }
        animate()
        
        editingMode = .editing
    }
    
    private func switchFromEditingMode(){
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = placeholderLabel.font.withSize(placeholderSizePreEdit)
        placeholderBottomConstraint.priority = .defaultLow
        centerConstraint.priority = .defaultHigh
        animate()
        
        editingMode = .notEditing
    }
    
    private func hideleftImage(){
        leftImageview.isHidden = true
        textfieldLeadingConstraintFromImage.priority = .defaultLow
        textfieldLeadingConstraintFromSuperview.isActive = true
        addConstraint(textfieldLeadingConstraintFromSuperview)
        textfieldLeadingConstraintFromSuperview.priority = .defaultHigh
        animate()
    }
    
    private func showLeftImage(usingImage newImage: UIImage){
        leftImageview.isHidden = false
        textfieldLeadingConstraintFromSuperview.priority = .defaultLow
        textfieldLeadingConstraintFromImage.priority = .defaultHigh
        textfieldLeadingConstraintFromSuperview.isActive = false
        leftImageview.image = newImage
        
        animate()
    }
    
    private func toggleRightBtn(shouldShow: Bool){
        rightImageBtnWidthConstraint.constant = shouldShow ? rightImageBtnWidth : 0
    }
    
    private func animate(){
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switchToEditingMode()
        delegate?.textFieldDidBeginEditing?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(self)
        guard let text = textField.text,
        text.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 else {
            switchFromEditingMode()
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let value = delegate?.textFieldShouldReturn?(self) else {
            return false
        }
        
        return value
    }
}
