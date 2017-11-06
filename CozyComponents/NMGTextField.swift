
import UIKit

@objc protocol NMGTextFieldDelegate: class{
    @objc optional func rightImageTapped(forInput input: NMGTextField)
    @objc optional func textFieldDidBeginEditing(textField: NMGTextField)
    @objc optional func textFieldDidEndEditing(textField: NMGTextField)
    @objc optional func textFieldDidChange(textField: NMGTextField,charactersTo text: String)
    @objc optional func textFieldShouldReturn(textField: NMGTextField) -> Bool
}

@IBDesignable class NMGTextField: UIView{
    
    //MARK: Props
    @IBInspectable var textInputBorderColor: UIColor = .gray{
        didSet{
            bottomBorder.backgroundColor = textInputBorderColor
        }
    }
    @IBInspectable var textInputFont: UIFont = .systemFont(ofSize: 15){
        didSet{
            textInput.font = textInputFont
        }
    }
    
    @IBInspectable var placeHolderFont: UIFont = .systemFont(ofSize: 12){
        didSet{
            placeHolder.font = placeHolderFont
        }
    }
    
    @IBInspectable var rightImage: UIImage?{
        didSet{
            rightImageView.image = rightImage
            self.layoutSubviews()
        }
    }
    
    @IBInspectable var keyboardType: UIKeyboardType  = .default{
        didSet{
            textInput.keyboardType = keyboardType
            secureTextEntryView.keyboardType = keyboardType
        }
    }
    
    @IBInspectable var secureTextEntry: Bool = false{
        didSet{
            if secureTextEntry{
                self.switchToTF()
            }else{
                self.switchToTV()
            }
        }
    }
    
    @IBInspectable var interactionEnabled: Bool = true{
        didSet{
            textInput.isUserInteractionEnabled = interactionEnabled
            secureTextEntryView.isUserInteractionEnabled = interactionEnabled
        }
    }
    
    func switchToTF(){
        textInputHeight.constant = 0
        secureTextEntryHeight.constant = 30
        placeHolderCenter.priority = 998
        placeHolderCenter2.priority = 999
        placeholderBottom2.priority = 999
        layoutSubviews()
    }
    
    func switchToTV(){
        textInputHeight.constant = getHeightConstant(forControl: textInput, usingText: "test")!
        secureTextEntryHeight.constant = 0
        placeHolderCenter2.priority = 998
        placeHolderCenter.priority = 999
        layoutSubviews()
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.gray.withAlphaComponent(0.8){
        didSet{
            self.placeHolder.textColor = placeholderColor
        }
    }
    
    @IBInspectable var textInputColor: UIColor = .black{
        didSet{
            textInput.textColor = textInputColor
        }
    }
    
    @IBInspectable var animationDuration: CGFloat = 0.4
    
    @IBInspectable var placeHolderText: String = "Placeholder here"{
        didSet{
            placeHolder.text = placeHolderText
        }
    }
    weak var delegate: NMGTextFieldDelegate?
    
    //MARK: Private props
    fileprivate var topPadding: CGFloat = 15
    fileprivate var placeHolderCenter: NSLayoutConstraint!
    fileprivate var placeHolderBottom: NSLayoutConstraint!
    fileprivate var currentTextHeight: CGFloat?
    fileprivate var textInputAspectRatio: NSLayoutConstraint!
    fileprivate var textInputHeight: NSLayoutConstraint!
    fileprivate var placeHolderHeight: NSLayoutConstraint!
    fileprivate var heightConstraint: NSLayoutConstraint!
    fileprivate var rightImageWidthConstraint: NSLayoutConstraint!
    fileprivate var secureTextEntryHeight: NSLayoutConstraint!
    fileprivate var placeHolderCenter2: NSLayoutConstraint!
    fileprivate var placeholderBottom2: NSLayoutConstraint!
    fileprivate var indicatingError: Bool = false
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 100, height: totalHeight)
    }
    
    //MARK: Getters
    private var totalHeight: CGFloat{
        return topPadding + textInputHeight.constant + secureTextEntryHeight.constant + 1 + 2 + 2 + 2
    }
    
    private var rightImageWidth: CGFloat {
        return self.rightImage == nil ? 0 : 25
    }
    
    var text: String?{
        get{
            return secureTextEntry ? secureTextEntryView.text : textInput.text
        }set{
            if secureTextEntry{
                secureTextEntryView.text = newValue
                placeHolderCenter2.priority = 998
                placeholderBottom2.priority = 999
                addConstraint(placeholderBottom2)
                
            }else{
                textInput.text = newValue
                placeHolderCenter.priority = 998
                placeHolderBottom.priority = 999
                addConstraint(placeHolderBottom)
            }
            layoutIfNeeded()
        }
    }
    
    //MARK: Control sub-components
    fileprivate lazy var textInput: UITextView = {
        let t = UITextView()
        t.delegate = self
        t.isScrollEnabled = false
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = self.textInputFont
        t.textColor = self.textInputColor
        return t
    }()
    
    fileprivate lazy var secureTextEntryView: UITextField = {
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.isSecureTextEntry = true
        t.font = self.textInputFont
        t.textColor = self.textInputColor
        return t
    }()
    
    fileprivate lazy var rightImageView: UIImageView = {
        let i = UIImageView()
        i.clipsToBounds = true
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = self.rightImage
        return i
    }()
    
    fileprivate lazy var bottomBorder: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        v.backgroundColor = self.textInputBorderColor
        return v
    }()
    
    fileprivate lazy var placeHolder: UILabel = {
        let l = UILabel()
        l.text = self.placeHolderText
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = self.placeHolderFont
        l.textColor = self.placeholderColor
        return l
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup(){
        //translatesAutoresizingMaskIntoConstraints = false
        addSubview(textInput)
        addSubview(secureTextEntryView)
        addSubview(bottomBorder)
        addSubview(placeHolder)
        addSubview(rightImageView)
        
        
        addConstraintsWithFormat("H:|[v0][v1]|", views: textInput, rightImageView)
        addConstraintsWithFormat("H:|[v0][v1]|", views: secureTextEntryView,rightImageView)
        addConstraintsWithFormat("V:[v0][v1]-2-[v2(1)]-2-|", views: textInput,secureTextEntryView,bottomBorder)
        addConstraintsWithFormat("H:|[v0]|", views: bottomBorder)
        
        
        //initially the placeholder label will be aligned with bottom left of the text input
        let leftConstraint = NSLayoutConstraint(item: placeHolder, attribute: .left, relatedBy: .equal, toItem: textInput, attribute: .left, multiplier: 1, constant: 2)
        placeHolderCenter = NSLayoutConstraint(item: placeHolder, attribute: .centerY, relatedBy: .equal, toItem: textInput, attribute: .centerY, multiplier: 1, constant: 0)
        placeHolderCenter.priority = 999
        placeHolderCenter2 = NSLayoutConstraint(item: placeHolder, attribute: .centerY, relatedBy: .equal, toItem: secureTextEntryView, attribute: .centerY, multiplier: 1, constant: 0)
        placeHolderCenter2.priority = 998
        placeHolderBottom = NSLayoutConstraint(item: placeHolder, attribute: .bottom, relatedBy: .equal, toItem: textInput, attribute: .top, multiplier: 1, constant: -2)
        placeholderBottom2 = NSLayoutConstraint(item: placeHolder, attribute: .bottom, relatedBy: .equal, toItem: secureTextEntryView, attribute: .top, multiplier: 1, constant: -2)
        placeHolderBottom.priority = 999
        placeholderBottom2.priority = 998
        addConstraints([leftConstraint,placeHolderCenter, placeHolderCenter2])
        
        //setting up heights as per font sizes
        let th = getHeightConstant(forControl: textInput, usingText: "Test")! + 7
        let ph = getHeightConstant(forControl: placeHolder, usingText: "Test")
        
        textInputHeight = NSLayoutConstraint(item: textInput, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: th)
        placeHolderHeight = NSLayoutConstraint(item: placeHolder, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ph!)
        topPadding = placeHolderHeight.constant
        
        
        //set y
        addConstraints([textInputHeight,placeHolderHeight])
        
        //set right Image
        rightImageWidthConstraint = NSLayoutConstraint(item: rightImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: rightImageWidth)
        addConstraints([rightImageWidthConstraint])
        addConstraintsWithFormat("V:[v0(25)]-5-|", views: rightImageView)
        
        //setup secure text entry
        secureTextEntryHeight = NSLayoutConstraint(item: secureTextEntryView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: secureTextEntry ? 30 : 0)
        
        addConstraint(secureTextEntryHeight)
        //add gestures
        rightImageView.isUserInteractionEnabled = true
        rightImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightImageTapped)))
        
    }
    
    
    func rightImageTapped(tap: UITapGestureRecognizer){
        delegate?.rightImageTapped?(forInput: self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rightImageWidthConstraint.constant = rightImageWidth
        invalidateIntrinsicContentSize()
    }
    
    private func getHeightConstant(forControl control: AnyObject, usingText text: String) -> CGFloat?{
        switch control as? UIView{
        case .some(let view):
            switch view{
            case textInput:
                let font = textInput.font
                
                let height = (text.height(withConstrainedWidth: textInput.bounds.width, font: font!)) + 5
                return height
            case placeHolder:
                let font = textInput.font
                let height = (text
                    .height(withConstrainedWidth: textInput.bounds.width, font: font!)) + 5
                return height
                
            default:
                break
            }
            
        default:
            break
        }
        
        return nil
    }
    
    fileprivate func animate(withDuration duration: CGFloat, _ animations: @escaping ()->Void, _ completion: (()->Void)? = nil){
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            animations()
        }) { (_) in
            completion?()
        }
    }
    
}

extension NMGTextField: UITextViewDelegate, UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        //animate placeholder to top
        delegate?.textFieldDidBeginEditing?(textField: self)
        
        //reset any errors
        if indicatingError{
            placeHolder.textColor = placeholderColor
            bottomBorder.backgroundColor = textInputBorderColor
            placeHolder.text = placeHolderText
            indicatingError = false
        }
        removeConstraint(placeHolderCenter)
        addConstraint(placeHolderBottom)
        
        animate(withDuration: animationDuration, {
            self.layoutIfNeeded()
        })
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textFieldDidChange?(textField: self,charactersTo: textView.text)
        let contentSize = textView.sizeThatFits(self.textInput.bounds.size)
        if contentSize.height != currentTextHeight{
            currentTextHeight = contentSize.height
            //make the necessary change in self height
            animate(withDuration: animationDuration, {
                self.textInputHeight.constant = contentSize.height
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField: self)
        //move the placeholder label
        removeConstraint(placeHolderCenter2)
        addConstraint(placeholderBottom2)
        
        animate(withDuration: animationDuration, {
            self.layoutIfNeeded()
        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textFieldDidEndEditing?(textField: self)
        //will need to reset the placeholder label to center if no text is available
        if textView.text == nil || textView.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0{
            //no text is available in textView, place the placeholder label in center of textView
            removeConstraint(placeHolderBottom)
            addConstraint(placeHolderCenter)
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField: self)
        if textField.text == nil || textField.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0{
            removeConstraint(placeholderBottom2)
            addConstraint(placeHolderCenter2)
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
}


extension NMGTextField{
    //MARK: Public API
    
    override func resignFirstResponder() -> Bool {
        textInput.resignFirstResponder()
        secureTextEntryView.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    func shake(){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 20, y: self.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 20, y: self.center.y))
        self.layer.add(shakeAnimation, forKey: "position")
    }
    
    func indicateError(withMessage message: String){
        placeHolder.text = message.capitalized
        indicatingError = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: { 
            self.bottomBorder.backgroundColor = .red
            self.placeHolder.textColor = .red
        }, completion: nil)
        shake()
    }
    
}
extension UIView {
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension String{
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

