enum shareType:String {
    
    case userMap = "Map"
    case product = "Product"
    case productGroup = "Group"
    
}


//MARK: ==========注册Item==========

protocol CollectionViewManager {
    
    func registerXibItem(_ nameArray:Array<String>)
    func registerXibHeader(_ nameArray:Array<String>)

}

extension UICollectionView: CollectionViewManager {
    
    
    //MARK: 该方法定义的Cell Identifier 为Nib name
    func registerXibItem(_ nameArray:Array<String>) {
        
        for name in nameArray {
            
            let currentNib = UINib(nibName: name, bundle: Bundle.main)

            self.register(currentNib, forCellWithReuseIdentifier: name)
            
        }
        
    }

    //MARK: 该方法定义的Header Identifier 为Nib name
    func registerXibHeader(_ nameArray:Array<String>) {
        
        for name in nameArray {
            
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            
            self.register(currentNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: name)
            
        }
        
    }
    
}



//MARK: ==========注册Cell==========
protocol TableViewManager {
    
    func registerXibCell(_ nameArray:Array<String>)
    func registerXibHeader(_ nameArray:Array<String>)
    
}

extension UITableView: TableViewManager {
    
    //MARK: 该方法定义的Cell Identifier 为Nib name
    func registerXibCell(_ nameArray:Array<String>) {
        
        for name in nameArray {
            
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            
            self.register(currentNib, forCellReuseIdentifier: name)
            
        }
        
    }
    
    
    //MARK: 该方法定义的Header Identifier 为Nib name
    func registerXibHeader(_ nameArray:Array<String>) {
        
        for name in nameArray {
            
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            
            self.register(currentNib, forHeaderFooterViewReuseIdentifier: name)
            
        }

        
    }
    
}




//MARK: ==========分享到微博,微信,朋友圈==========
protocol shareProtocol {
    
    func shareToWeChatFriends()
    func shareToWeChatCircles()
    func shareToWeibo()
    
    var type: shareType {get set}
    
    var alias: String {get set}
    
    var baseUrl: String {get set}
    
    var path: String {get}
    
}


struct shareManager:shareProtocol {

    
    fileprivate var title = "我的家里真有草原！快来看我在囧囧兔美食地图种的草吧!"
    
    fileprivate var content = "#囧囧兔#"
    
    fileprivate var weiboContent = ""
    
    fileprivate var image:UIImage?
    
    var alias: String = ""

    var baseUrl: String = "https://www.jojotoo.com"
    
    var type: shareType = .userMap
    
    fileprivate var url:String {
        
        get {
            
            return baseUrl + path + alias
            
        }
        
    }

    var path: String {
        
        switch self.type {
            
        case .userMap:
            
            return "/gourmet_map/index.html?user_alias="

        case .product:
            
            return "/share/product-detail.html?alias="
            
        
        case .productGroup:
            
            return "/share/group.html?alias="
        
        }

    }
    
    
    var imageUrl = "" {
        
        didSet {
            
            do {
                
                let data = try Data(contentsOf: URL(string: imageUrl)!)
                
                let userAvtImage = UIImage(data: data)!
                
                UIGraphicsBeginImageContext(CGSize(width: 300, height: 300))
                
                userAvtImage.draw(in: CGRect(x: 0, y: 0, width: 300, height: 300))
                
                let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                image = reSizeImage
                
            } catch let error {
                
                print(error)
                
            }
            
            
        }
        
    }
    
    
    // MARK: 分享 初始化信息
    init(_ myAlias:String,myImage:String,myTitle:String,myContent:String,myType:shareType,myWeiboContent:String) {
        
        title = myTitle.replacingOccurrences(of: "\u{00002028}", with: "")
        title = myTitle.replacingOccurrences(of: "\u{00002029}", with: "")
        
        content = myContent.replacingOccurrences(of: "\u{00002028}", with: "")
        content = myContent.replacingOccurrences(of: "\u{00002029}", with: "")

        alias = myAlias
        
        if myImage.hasSuffix("webp") {
            
            imageUrl = myImage.replacingOccurrences(of: "webp", with: "w768")
                        
        }else {
            
            imageUrl = myImage
            
        }
        

        type = myType
        weiboContent = myWeiboContent
        
    }
    

    
    func shareToWeChatFriends() {

        
        let shareParam = NSMutableDictionary()
        
        shareParam.ssdkEnableUseClientShare()
        
        shareParam.ssdkSetupWeChatParams(byText: content, title: title, url: URL(string: url), thumbImage: image, image: imageUrl, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: .webPage, forPlatformSubType: .subTypeWechatSession)

        ShareSDK.share(.subTypeWechatSession, parameters: shareParam, onStateChanged: { (myState, userData, contentEntity, error) in
            
            
            if myState == SSDKResponseState.success {
                
                JKAlert.alertText("分享成功")
                
            }else {
                
                
            }
            
            
        })

        
    }
    
    
    
    func shareToWeChatCircles() {
        
        
        let shareParam = NSMutableDictionary()
        
        shareParam.ssdkEnableUseClientShare()
        
        shareParam.ssdkSetupWeChatParams(byText: content, title: title, url: URL(string: url), thumbImage: image, image: imageUrl, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: .webPage, forPlatformSubType: .subTypeWechatTimeline)
        
        ShareSDK.share(.subTypeWechatTimeline, parameters: shareParam, onStateChanged: { (myState, userData, contentEntity, error) in
            
            if myState == SSDKResponseState.success {
                
                JKAlert.alertText("分享成功")
                
            }else {
                
                
            }
            
        })
        
        
    }
    
    
    func shareToWeibo() {
        
        let shareParam = NSMutableDictionary()
        
        shareParam.ssdkEnableUseClientShare()
        
        shareParam.ssdkSetupShareParams(byText: weiboContent + url, images: image, url: URL(string: url), title: title, type: .auto)
        
        ShareSDK.share(.typeSinaWeibo, parameters: shareParam, onStateChanged: { (myState, userData, contentEntity, error) in
            
            
            if myState == SSDKResponseState.success {
                
                JKAlert.alertText("分享成功")
                
            }else {
                
                
            }
            
            
        })
        
        
    }
    
}

