//
//  ViewController.swift
//  CozyComponents
//
//  Created by Jatin Garg on 05/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        let v1 = UIView()
        v1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v1)
        
        let v2 = UIView()
        v2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v2)
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v1]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v2]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : v1,"v1" : v2]))
        
        view.addConstraint(NSLayoutConstraint(item: v1, attribute: .height, relatedBy: .equal, toItem: v2, attribute: .height, multiplier: 1, constant: 0))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MessageActivityIndicator.show(addToView: v1, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                MessageActivityIndicator.show(addToView: v2, message: "message", .blue, speed: 0.8, animated: true)
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            MessageActivityIndicator.hide(from: v2)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MessageActivityIndicator.hide(from: v1)
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

