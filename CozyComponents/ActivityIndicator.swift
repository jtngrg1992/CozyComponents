
import UIKit

class MessageActivityIndicator: UIView{
    
    var color: UIColor = .red{
        didSet{
            setAnimationLayerColors()
        }
    }
    var message: String = "Please Wait.."{
        didSet{
            messageLabel.text = message
        }
    }
    var speed: CGFloat = 0.5
    
    
    private var animationLayer = CAShapeLayer()
    private var lighterLayer = CAShapeLayer()
    private var isAnimating = false
    
    var animationContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    var messageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Hi"
        l.numberOfLines = 2
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    convenience init(message: String? = "Please wait..", animationColor: UIColor,rotationSpeed: CGFloat = 0.5){
        self.init(frame: .zero)
        self.messageLabel.text = message
        self.speed = rotationSpeed
        self.color = animationColor
        setAnimationLayerColors()
    }
    
    private func setAnimationLayerColors(){
        animationLayer.strokeColor = color.cgColor
        lighterLayer.strokeColor = color.withAlphaComponent(0.4).cgColor
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup(){
        createGradient()
        layer.masksToBounds = true
        layer.cornerRadius = 3
        
        addSubview(animationContainer)
        addSubview(messageLabel)
        
        let horizontalConstraint = NSLayoutConstraint(item: animationContainer, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15)
        
        let verticalConstraintTop = NSLayoutConstraint(item: animationContainer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10)
        
        let verticalConstraintBottom = NSLayoutConstraint(item: animationContainer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        
        let aspect = NSLayoutConstraint(item: animationContainer, attribute: .width, relatedBy: .equal, toItem: animationContainer, attribute: .height, multiplier: 1, constant: 0)
        
        addConstraints([horizontalConstraint,verticalConstraintTop,verticalConstraintBottom,aspect])
        
        let horizontalConstraint1 = NSLayoutConstraint(item: messageLabel, attribute: .left, relatedBy: .equal, toItem: animationContainer, attribute: .right, multiplier: 1, constant: 15)
        
        let horizontalConstraint2 = NSLayoutConstraint(item: messageLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10)
        
        let center = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        addConstraints([horizontalConstraint1,horizontalConstraint2,center])
//        layoutIfNeeded()
        
        animationContainer.layer.addSublayer(lighterLayer)
        lighterLayer.fillColor = UIColor.clear.cgColor
        lighterLayer.strokeColor = color.withAlphaComponent(0.4).cgColor
        lighterLayer.lineWidth = 3
        animationContainer.layer.addSublayer(animationLayer)
        
        animationLayer.fillColor = UIColor.clear.cgColor
        animationLayer.strokeColor = color.cgColor
        animationLayer.lineWidth = 3
        animationLayer.frame = animationContainer.bounds
        
        
    }
    
    private func createGradient(){
        gradientLayer = CAGradientLayer()
        let color1 = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        let color2 = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1,color2].map{$0.cgColor}
        layer.addSublayer(gradientLayer)
    }
    
    private var gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maxBounds = animationContainer.bounds
        let radius = min(maxBounds.width,maxBounds.height)/2
        let centera = CGPoint(x: maxBounds.width/2, y: maxBounds.height/2)
        
        let circle = UIBezierPath(arcCenter: centera, radius: radius, startAngle: 0, endAngle: 0.6*2*CGFloat.pi, clockwise: true)
        
        let circle2 = UIBezierPath(arcCenter: centera, radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        animationLayer.frame = maxBounds
        lighterLayer.frame = maxBounds
        gradientLayer.frame = bounds
        lighterLayer.path = circle2.cgPath
        animationLayer.path = circle.cgPath
    }
    
    func startAnimating(){
        if isAnimating{
            return
        }
        
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = CFTimeInterval(speed);
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = HUGE;
        
        animationLayer.add(rotationAnimation, forKey: "rotation")
        isAnimating = true
    }
    
    func stopAnimating(){
        if !isAnimating{
            return
        }
        animationLayer.removeAllAnimations()
        isAnimating = false
    }
    
    static var overlay: UIView?
    
    var totalHeight: CGFloat {
        let text = messageLabel.text
        let size = (text! as NSString).boundingRect(with: CGSize(width: messageLabel.bounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : messageLabel.font], context: nil)
        return size.height > 60 ? size.height : 60
    }
    
    static var recordKeeper = [UIView:UIView]()
    
    static func show(addToView view: UIView, message: String? = "Please wait ... ", _ color: UIColor = .green, speed: CGFloat = 0.6, animated: Bool){
        let loader = MessageActivityIndicator()
        loader.translatesAutoresizingMaskIntoConstraints  = false
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        
        loader.message = message!
        loader.color = color
        
        if animated{
            loader.startAnimating()
        }
        
        overlay.addSubview(loader)
        
        let width: CGFloat  = 200
        let height: CGFloat = loader.totalHeight
        
        overlay.addConstraint(NSLayoutConstraint(item: loader, attribute: .centerY, relatedBy: .equal, toItem: overlay, attribute: .centerY, multiplier: 1, constant: 0))
        
        overlay.addConstraint(NSLayoutConstraint(item: loader, attribute: .centerX, relatedBy: .equal, toItem: overlay, attribute: .centerX, multiplier: 1, constant: 0))
        
        overlay.addConstraint(NSLayoutConstraint(item: loader, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
        
        overlay.addConstraint(NSLayoutConstraint(item: loader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        
        view.addSubview(overlay)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : overlay]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : overlay]))
        
        
        //add to records
        recordKeeper[view] = overlay
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            overlay.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            loader.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    static func hide(from view: UIView){
        if let overlay = recordKeeper[view]{
            UIView.animate(withDuration: 0.5, animations: {
                overlay.backgroundColor = .clear
                
            }, completion: { (success) in
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                    overlay.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    overlay.alpha = 0
                }, completion: { (_) in
                    overlay.subviews.forEach
                        {
                            $0.removeFromSuperview()
                    }
                    overlay.removeFromSuperview()
                })
                
            })
        }
    }
    
}

