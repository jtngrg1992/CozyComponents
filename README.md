# CozyComponents

Swift sources for various controls that can be used in your projects.

# List of contents

 ## 1. MessageActivityIndicator
 
 > An android style activity indicator for iOS written in swift with customisable rotation animation speed, color and message

###### Usage

```swift
MessageActivityIndicator.show(addToView: v1, message: "Please wait ...", .green, speed: 1, animated: true)
```
![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/MAI.png)

## 2. NMGTextField

> A customized textinput with animated placeholder.


###### Usage

```swift
let t = NMGTextField()
t.placeHolderText = "Enter text here"
t.placeholderColor = UIColor.black.withAlphaComponent(0.5)
t.textInputBorderColor = UIColor.gray
t.placeHolderFont = UIFont(name: "Avenir", size: 15)!
t.textInputFont = UIFont(name: "Avenir", size: 18)!
t.delegate = self
t.translatesAutoresizingMaskIntoConstraints = false
 ```
 
![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/NMGTF1.png)

![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/NMGTF2.png)


## 3. NMGFlashMessage

> A customized pop up dialog


###### Usage

```swift

//Configure in app delegate
NMGFlashMessage.shared.configureDialog(titleFont: UIFont(name: "Avenir-Heavy", size: 20)!,
                                               messageFont: UIFont(name: "Avenir", size: 15)!,
                                               titleFontColor: UIColor.init(red: 80.0/255.0, green: 85.0/255.0, blue: 88.0/255.0, alpha: 1),
                                               messageFontColor: UIColor.init(red: 80.0/255.0, green: 85.0/255.0, blue: 88.0/255.0, alpha: 1),
                                               errorImage: #imageLiteral(resourceName: "error"),
                                               successImage: #imageLiteral(resourceName: "snap"),
                                               neutralImage: #imageLiteral(resourceName: "success"),
                                               headerColor: .white,
                                               backgroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1),
                                               actionBackgroundColor: UIColor.init(red: 246.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1),
                                               actionFont: UIFont(name: "Avenir-Heavy", size: 17)!,
                                               actionColor: .white)
                                               
```

```swift
//Write this to show
NMGFlashMessage.shared.show(withTitle: "Test", usingMessage: "This is a test", havingAction: "Okay!", andActionMode: .success)
```

![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/NMGFlash1.png)

 ## 4. NMGCheckBox
 
 > A checkbox to use in projects

###### Usage

```swift
let check = NMGCheckBox(checked: false, fillColor: UIColor.init(red: 246.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1), checkColor: .white)
```
![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/NMGC1.png)
![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/NMGC2.png)

## 5. CustomtextField
 
 > Another variation of nmg textfield
 
![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/Screen Shot 2017-12-21 at 12.21.20 PM.png)
![ScreenShot](https://raw.github.com/jtngrg1992/CozyComponents/master/Screenshots/Screen Shot 2017-12-21 at 12.21.28 PM.png)
 
