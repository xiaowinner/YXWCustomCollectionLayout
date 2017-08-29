

extension UIView {
    
    func findViewController() -> UIViewController! {
        
        return self.findControllerWithClass(UIViewController.self)
        
    }
    
    func findNavigationController() -> UINavigationController! {
        
        return self.findControllerWithClass(UINavigationController.self)
        
    }
    
    func findControllerWithClass<T>(_ clzz: AnyClass) -> T? {
        
        var responder = self.next
        
        while(responder != nil) {
            
            if (responder!.isKind(of: clzz)) {
                
                return responder as? T
                
            }
            
            responder = responder?.next
            
        }
        
        return nil
    }
    
}

extension UIViewController {
    
    func setCustomNavigation(_ alpha: Float) {
        
        let backButton = UIButton(frame: CGRect(x: screenWidth - 45, y: 0, width: 30, height: 30))
        
        backButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        
        let barButtonItem1 = UIBarButtonItem(customView: backButton)
        
        if alpha <= 0 {
            
            backButton.setImage(UIImage(named: "blackBackIcon"), for: .normal)
            
            navigationController?.barStyle = .black
            
        }else {
            
            navigationController?.navigationBar.lt_setBackgroundColor(appMainColor)
            
            backButton.setImage(UIImage(named: "backArrow"), for: .normal)
            
            navigationController?.barStyle = .light
        }
        
        navigationItem.leftBarButtonItem = barButtonItem1
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    
    //MARK: 返回
    func backViewController() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
}

extension UINavigationController {
    
    
    var barStyle: barType? {
        
        set {
            
            objc_setAssociatedObject(self, RuntimeKey.barKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
        }
        
        get {
            
            return  objc_getAssociatedObject(self, RuntimeKey.barKey) as? barType
            
        }
        
    }

    
}


extension NSLayoutConstraint {
    
    func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
        
    }
    
}





struct RuntimeKey {
    
    static let barKey = UnsafeRawPointer(bitPattern: "barKey".hashValue)
    
}

public enum barType:Int {
    
    case black = 0 //黑色
    case light = 1 //白色
    
}


extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    
    //MARK: ====================== 计算 HtmlAttribute
    func calculateHtmlAttribute() -> NSAttributedString? {
        
        var attributedHML = NSAttributedString()
        
        do {
            
            if self.characters.count == 0 {
                
                return nil
                
            }
            
            attributedHML = try NSAttributedString(data: (self.data(using: .utf16, allowLossyConversion: false))!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            return attributedHML
            
        }catch let error {
            
            print(error)
            
            return nil
            
        }
        
        
    }
    
}


func associatedObject<ValueType: AnyObject>(base: AnyObject,key: UnsafePointer<UInt8>,initialiser: () -> ValueType)-> ValueType {
    
        if let associated = objc_getAssociatedObject(base, key) as? ValueType {
            
            return associated
            
        }
    
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,.OBJC_ASSOCIATION_RETAIN)
        return associated
    
}


func associateObject<ValueType: AnyObject>(base: AnyObject,key: UnsafePointer<UInt8>,value: ValueType) {
    
    objc_setAssociatedObject(base, key, value,.OBJC_ASSOCIATION_RETAIN)
    
}
