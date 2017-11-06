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
        
        let width = UIScreen.main.bounds.width
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(\(width))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v1]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v2]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : scrollView]))
        
        
        let height = UIScreen.main.bounds.height/2
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(height))][v1(\(height))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v1,"v1" : v2]))
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MessageActivityIndicator.show(addToView: v1, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            MessageActivityIndicator.hide(from: v2)
            
        }
        
        //NMG TextField
        
        v2.addSubview(customTextFiled)
        v2.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : customTextFiled]))
        
        v2.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : customTextFiled]))
        
        
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

