// 用于整体控制 手势侧滑返回问题 根navigationController 继承即可

import UIKit

class allBaseNavigationController: UINavigationController,UINavigationBarDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        weak var weakSelf = self
        
        self.interactivePopGestureRecognizer?.delegate = weakSelf
        
        self.delegate = weakSelf
        
        self.navigationBar.delegate = weakSelf
        
        self.navigationBar.lt_setBackgroundColor(appMainColor)
        
        self.navigationBar.shadowImage = UIImage.init()
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    


    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        
        
        self.interactivePopGestureRecognizer?.isEnabled = false

        return true
        
    }
    
    
    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        
        print(viewControllers)
        
        if self.viewControllers.count > 1 {
            
            if self.viewControllers[1].isKind(of: PublishViewController.self) || self.viewControllers[1].isKind(of: SearchSubjectVC.self) || self.viewControllers[1].isKind(of: shopMerchantViewController.self) || self.viewControllers[1].isKind(of: shopViewController.self) {
                
                self.interactivePopGestureRecognizer?.isEnabled = false

                
            }else {
                
                self.interactivePopGestureRecognizer?.isEnabled = true

            }

        }
        
        
    }


    
    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        
        if self.viewControllers.count == 1 {
            
            self.interactivePopGestureRecognizer?.isEnabled = false

        }

    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        if self.viewControllers.count > 1 {
            
            if self.viewControllers[1].isKind(of: PublishViewController.self) || self.viewControllers[1].isKind(of: SearchSubjectVC.self) || self.viewControllers[1].isKind(of: shopMerchantViewController.self) || self.viewControllers[1].isKind(of: shopViewController.self) {
                
                return false
                
            }else {
                
                return true
                
            }
            
        }else {
            
            return false
            
        }
        
        
    }
    

}
