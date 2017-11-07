//
//  ViewController.swift
//  CozyComponents
//
//  Created by Jatin Garg on 05/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController , NMGTextFieldDelegate{

   lazy var customTextFiled: NMGTextField = {
        let t = NMGTextField()
        t.placeHolderText = "Enter text here"
        t.placeholderColor = UIColor.black.withAlphaComponent(0.5)
        t.textInputBorderColor = UIColor.gray
        t.placeHolderFont = UIFont(name: "Avenir", size: 15)!
        t.textInputFont = UIFont(name: "Avenir", size: 18)!
        t.rightImage = #imageLiteral(resourceName: "error")
        t.delegate = self
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    lazy var customCheckBox: NMGCheckBox = {
        let check = NMGCheckBox(checked: false, fillColor: UIColor.init(red: 246.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1), checkColor: .white)
        check.translatesAutoresizingMaskIntoConstraints = false
        return check
    }()
    
    var scrollView: TPKeyboardAvoidingScrollView = {
        let s = TPKeyboardAvoidingScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        let v1 = UIView()
        v1.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(v1)
        
        let v2 = UIView()
        v2.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(v2)
        
        let v3 = UIView()
        v3.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(v3)
        
        let width = UIScreen.main.bounds.width
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(\(width))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v1]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v2]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v3]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : scrollView]))
        
        
        let height = UIScreen.main.bounds.height/3
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(height))][v1(\(height))][v2(\(height))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v1,"v1" : v2, "v2" : v3]))
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MessageActivityIndicator.show(addToView: v1, animated: true)
            MessageActivityIndicator.show(addToView: v1, message: "Custom Message", .blue, speed: 1, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            MessageActivityIndicator.hide(from: v2)
            
        }
        
        
        v2.addSubview(customTextFiled)
        v2.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : customTextFiled]))
        
        v2.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : customTextFiled]))
        
        v3.addSubview(customCheckBox)
        v3.addConstraint(NSLayoutConstraint(item: v3, attribute: .centerX, relatedBy: .equal, toItem: customCheckBox, attribute: .centerX, multiplier: 1, constant: 0))
        v3.addConstraint(NSLayoutConstraint(item: v3, attribute: .centerY, relatedBy: .equal, toItem: customCheckBox, attribute: .centerY, multiplier: 1, constant: 0))
        
        
    }

    
    //MARK: NMG TextField delegates
    func rightImageTapped(forInput input: NMGTextField) {
        NMGFlashMessage.shared.show(withTitle: "Test", usingMessage: "This is a test", havingAction: "Okay!", andActionMode: .success)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

