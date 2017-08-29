import UIKit

class customPopupViewController: UIViewController {
    
    var popupView:shopFreeGroupPopupView!
    
    var popupAlert:shopFreeGroupPopupAlertView!
    
    var backgroundView:UIView!
    
    var type = 0
    
    var myDates:[freeCouponModel] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        switch type {
            
        case 1:
            
            showFreeCouponView()
            
        case 2:
            
            showFreeAlertView()
            
        default:
            
            break
            
        }
        
    }
    
    
    func showFreeCouponView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.backgroundView.alpha = 0.5
            
        }) { (success) in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.popupView.center.y = self.view.center.y
                
            })
            
        }
        
    }
    
    
    
    func showFreeAlertView() {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.backgroundView.alpha = 0.5
            
        }) { (success) in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.popupAlert.center.y = self.view.center.y
                
            })
            
        }
        
        
    }

    
    
    func initFreeAlertView() {
        
        popupAlert = Bundle.main.loadNibNamed("shopFreeGroupPopupAlertView", owner: self, options: nil)?.first as! shopFreeGroupPopupAlertView
        
        popupAlert.openGroupButton.addTarget(self, action: #selector(openGroup), for: .touchUpInside)

        popupAlert.closeButton.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)

        self.view.backgroundColor = UIColor.clear
        
        popupAlert.frame.origin = CGPoint(x: 0, y: self.view.frame.maxY)
        
        popupAlert.center.x = self.view.center.x
        
        UIApplication.shared.keyWindow?.addSubview(popupAlert)
        
    }
    
    
    func initFreeCouponView() {
        
        popupView = Bundle.main.loadNibNamed("shopFreeGroupPopupView", owner: self, options: nil)?.first as! shopFreeGroupPopupView
        
        popupView.dates = myDates
        
        popupView.openGroupButton.addTarget(self, action: #selector(openGroup), for: .touchUpInside)
        
        popupView.closeButton.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)

        self.view.backgroundColor = UIColor.clear
        
        
        popupView.frame.origin = CGPoint(x: 0, y: self.view.frame.maxY)
        
        popupView.center.x = self.view.center.x
        
        UIApplication.shared.keyWindow?.addSubview(popupView)
        
    }
    
    
    func hidePopupView() {
        
        popupView.removeFromSuperview()
        
        popupAlert.removeFromSuperview()
        
        backgroundView.removeFromSuperview()
        
        self.dismiss(animated: true) {
            
        }
        
    }
    
    func openGroup() {
        
        guard let couponModel = self.myDates.first else {
            
            return
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init("openFreeGroup"), object: couponModel.coupon_code)
        
        hidePopupView()
        
    }
    
    
    func initBackground() {
        
        backgroundView = UIView()
        
        backgroundView.frame = self.view.frame
        
        backgroundView.alpha = 0
        
        backgroundView.backgroundColor = UIColor.black
        
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        
    }


    init(_ showType:Int,dates:[freeCouponModel]) {
        
        self.type = showType
        
        self.myDates = dates
        
        super.init(nibName: nil, bundle: nil)
        
        initBackground()
        initFreeCouponView()
        initFreeAlertView()

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
