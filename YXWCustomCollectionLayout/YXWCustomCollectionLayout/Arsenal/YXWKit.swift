import UIKit

@IBDesignable
class roundView: UIView {
    
    @IBInspectable var Round:CGFloat = 0 {
        
        didSet {
            
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.Round
            
        }
        
    }
    

    
}


@IBDesignable
class roundTextField: UITextField {
    
    @IBInspectable var Round:CGFloat = 0 {
        
        didSet {
            self.layer.cornerRadius = Round
            self.layer.masksToBounds = true
        }
        
    }
    
}


@IBDesignable
class roundLabel: UILabel {
    
    @IBInspectable var Round:CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = Round
            self.layer.masksToBounds = true
            
        }
        
    }
    
}


@IBDesignable
class roundImageView: UIImageView {
    
    
    @IBInspectable var Round:CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = Round
            self.layer.masksToBounds = true
            
        }
        
    }
    
    
    @IBInspectable var BorderColor:UIColor = UIColor.black {
        
        didSet {
            
            self.layer.borderColor = BorderColor.cgColor
            
        }
        
    }
    
    
    @IBInspectable var BorderWidth:CGFloat = 0 {
        
        didSet {
            
            self.layer.borderWidth = BorderWidth
            
        }
        
    }
    
    
}




@IBDesignable
class roundButton: UIButton {
    
    
    @IBInspectable var Round:CGFloat = 0 {
        
        didSet {
            
            self.layer.masksToBounds = true
            self.layer.cornerRadius = Round
            
        }
        
    }
    
    
    
    @IBInspectable var BorderColor:UIColor = UIColor.black {
        
        didSet {
            
            self.layer.borderColor = BorderColor.cgColor
            
        }
        
    }
    
    
    @IBInspectable var BorderWidth:CGFloat = 0 {
        
        didSet {
            
            self.layer.borderWidth = BorderWidth
            
        }
        
    }
    
    
}



@IBDesignable

class customItem: UITabBarItem {
    
    @IBInspectable var alwaysImage:UIImage? {
        
        didSet {
            
            self.image = alwaysImage?.withRenderingMode(.alwaysOriginal)
            
        }
    }
    
    
    @IBInspectable var selectAlwaysImage:UIImage? {
        
        didSet {
            
            self.selectedImage = selectAlwaysImage?.withRenderingMode(.alwaysOriginal)
            
        }
        
        
    }
    
    
}

