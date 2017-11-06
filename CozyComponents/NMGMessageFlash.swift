//
//  NMGMessageFlash.swift
//  NMGEssentials
//
//  Created by Jatin Garg on 11/3/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

enum NMGFlashMode{
    case error,plain,success
}

class NMGFlashMessage{
    var flashDialog = NMGMessageFlash()
    static let shared = NMGFlashMessage()
    
    typealias handler = ()->Void
    var actionHandler: handler?
    
    func configureDialog(titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17),
                         messageFont: UIFont = UIFont.systemFont(ofSize: 15),
                         titleFontColor: UIColor = .black,
                         messageFontColor: UIColor = .gray,
                         errorImage: UIImage? = nil,
                         successImage: UIImage? = nil,
                         neutralImage: UIImage? = nil,
                         headerColor: UIColor = .cyan,
                         backgroundColor: UIColor? = .white,
                         actionBackgroundColor: UIColor = .white,
                         actionFont: UIFont = .boldSystemFont(ofSize: 15),
                         actionColor: UIColor = .black,
                         actionHandler: handler? = nil){
        
        flashDialog.titleFont = titleFont
        flashDialog.messageFont = messageFont
        flashDialog.titleFontColor = titleFontColor
        flashDialog.messageFontColor = messageFontColor
        flashDialog.successImage = successImage
        flashDialog.errorImage = errorImage
        flashDialog.neutralImage = neutralImage
        flashDialog.headerColor = headerColor
        flashDialog.backgroundColor = backgroundColor
        flashDialog.actionFont = actionFont
        flashDialog.actionFontColor = actionColor
        flashDialog.actionBackgroundColor = actionBackgroundColor
        flashDialog.delegate = self
        self.actionHandler = actionHandler
    }
    
    func show(withTitle title: String, usingMessage message: String?, havingAction action: String, andActionMode mode: NMGFlashMode? = .plain){
        flashDialog.title = title
        flashDialog.message = message
        flashDialog.actionText = action
        
        switch mode{
        case .some(let m):
            switch m{
            case .error:
                flashDialog.headingImageView.image = flashDialog.errorImage
            case .success:
                flashDialog.headingImageView.image = flashDialog.successImage
            case .plain:
                flashDialog.headingImageView.image = flashDialog.neutralImage
            }
        default:
            flashDialog.headingImageView.image = flashDialog.neutralImage
        }
        
        flashDialog.show()
    }
    
}
class NMGMessageFlash: UIView {
    //MARK: public API
    
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17){
        didSet{
            headerLabel.font = titleFont
        }
    }
    var messageFont: UIFont = UIFont.systemFont(ofSize: 15){
        didSet{
            messageLabel.font = messageFont
        }
    }
    
    var titleFontColor: UIColor = .black{
        didSet{
            headerLabel.textColor = titleFontColor
        }
    }
    
    var messageFontColor: UIColor = .gray{
        didSet{
            messageLabel.textColor = messageFontColor
        }
    }
    
    var errorImage: UIImage?
    var successImage: UIImage?
    var neutralImage: UIImage?
    var headerColor: UIColor = .cyan{
        didSet{
            headingImageView.backgroundColor = headerColor
        }
    }
    
    var title: String?{
        didSet{
            headerLabel.text = title
        }
    }
    
    var message: String?{
        didSet{
            messageLabel.text = message
        }
    }
    
    var actionText: String?{
        didSet{
            actionBtn.setTitle(actionText, for: .normal)
        }
    }
    
    var actionFont: UIFont = UIFont.boldSystemFont(ofSize: 15){
        didSet{
            actionBtn.titleLabel?.font = actionFont
        }
    }
    
    
    var actionFontColor: UIColor = .black{
        didSet{
            actionBtn.tintColor = actionFontColor
        }
    }
    
    var actionBackgroundColor: UIColor = .white{
        didSet{
            actionBtn.backgroundColor = actionBackgroundColor
        }
    }
    
    var imageSize: CGFloat = 50{
        didSet{
            imageWidthConstraint.constant = imageSize
            imageHeightConstraint.constant = imageSize
            headingImageView.layer.cornerRadius = imageSize/2
            layoutIfNeeded()
        }
    }
    
    private var totalHeight: CGFloat{
        var height: CGFloat = 0
        height += imageSize/2
        height += title?.height(withConstrainedWidth: expectedWidth, font: headerLabel.font) ?? 5
        height += message?.height(withConstrainedWidth: expectedWidth, font: messageLabel.font) ?? 5
        height += actionBtnSize
        //add paddings
        height += 3*padding
        return height
    }
    
    weak var delegate: NMGFlashMessage?
    
    private let actionBtnSize: CGFloat = 40
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: expectedWidth, height: totalHeight)
    }
    
    private var expectedWidth: CGFloat {
        return UIScreen.main.bounds.width - 30
    }
    
    lazy var headingImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.layer.masksToBounds = true
        i.layer.cornerRadius = self.imageSize/2
        i.contentMode = .scaleAspectFit
        i.image = self.neutralImage
        i.backgroundColor = .white
        return i
    }()
    
    fileprivate lazy var headerLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 5
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = self.titleFontColor
        l.font = self.titleFont
        l.text = self.title
        return l
    }()
    
    
    fileprivate lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 5
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = self.messageFontColor
        l.font = self.messageFont
        l.text = self.message
        return l
    }()
    
    fileprivate lazy var actionBtn: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(self.actionText ?? "Okay!", for: .normal)
        b.titleLabel?.font = self.actionFont
        b.tintColor = self.actionFontColor
        b.backgroundColor = self.actionBackgroundColor
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 2
        b.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return b
    }()
    
    
    private let padding: CGFloat = 10
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
    var imageHeightConstraint: NSLayoutConstraint!
    var imageWidthConstraint: NSLayoutConstraint!
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(headingImageView)
        addSubview(headerLabel)
        addSubview(messageLabel)
        addSubview(actionBtn)
        
        addConstraintsWithFormat("V:[v0]-\(padding)-[v1]-\(padding)-[v2]-\(padding)-[v3(\(actionBtnSize))]|", views: headingImageView,headerLabel,messageLabel,actionBtn)
        
        //horizontal placements
        let imageCenter = NSLayoutConstraint(item: headingImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let imageYCenter = NSLayoutConstraint(item: headingImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        addConstraints([imageCenter,imageYCenter])
        
        addConstraintsWithFormat("H:|-\(padding)-[v0]-\(padding)-|", views: headerLabel)
        addConstraintsWithFormat("H:|-\(padding)-[v0]-\(padding)-|", views: messageLabel)
        imageWidthConstraint = NSLayoutConstraint(item: headingImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageSize)
        imageHeightConstraint = NSLayoutConstraint(item: headingImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageSize)
        addConstraintsWithFormat("H:|[v0]|", views: actionBtn)
        addConstraints([imageHeightConstraint,imageWidthConstraint])
        
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        
    }
    
    var overlay: UIView?
    var centerY: NSLayoutConstraint!
    func show(){
        if let keywindow = UIApplication.shared.keyWindow{
            overlay = UIView()
            centerY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: overlay!, attribute: .centerY, multiplier: 1, constant: 1000)
            let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: overlay!, attribute: .centerX, multiplier: 1, constant: 0)
            overlay?.addSubview(self)
            overlay?.addConstraintsWithFormat("H:[v0(\(expectedWidth))]", views: self)
            overlay?.addConstraintsWithFormat("V:[v0(\(totalHeight))]", views: self)
            overlay?.addConstraints([centerY,centerX])
            keywindow.addSubview(overlay!)
            keywindow.addConstraintsWithFormat("H:|[v0]|", views: overlay!)
            keywindow.addConstraintsWithFormat("V:|[v0]|", views: overlay!)
            self.center = keywindow.center
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.centerY.constant = 0
                self.overlay?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                self.overlay?.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func hide(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.centerY.constant = UIScreen.main.bounds.height/2 + self.totalHeight/2 + self.imageSize/2
            self.overlay?.backgroundColor = .clear
            self.overlay?.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            self.overlay?.removeFromSuperview()
            self.overlay = nil
        })
        
        
    }
    
    func actionTapped(_ sender: UIButton){
        delegate?.actionHandler?()
        self.hide()
    }
    
}


