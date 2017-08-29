import UIKit
import SwiftHTTP
import SwiftyJSON
import RealmSwift

class uploadMonitorData: NSObject {
    
    static func uploadSubjectExposure() {
        
        DispatchQueue.global().async {
            
            do {
  
                var resultArray:[Dictionary<String,Any>] = []
                
                let realm = try Realm()
                
                let exposures = realm.objects(subjectExposure.self)
                
                if exposures.count == 0 {
                    
                    return
                    
                }
                
                let resultRef = ThreadSafeReference(to: exposures)
                
                
                for i in 0..<exposures.count {
                    
                    let currentDC = ["subject_alias":exposures[i].subjectAlias,"count":exposures[i].count] as [String : Any]
                    
                    resultArray.append(currentDC)
                    
                }
            
    
                
                var nowToken = ""
                
                if UserDefaults.standard.object(forKey: "userApiToken") != nil {
                    
                    nowToken = UserDefaults.standard.object(forKey: "userApiToken") as! String
                    
                }
                
                let url = YXWRequestV1 + "collect/subject?api_token=\(nowToken)"
                
                let parameters = [
                    
                    "type" : "subject_exposure",
                    "data" : resultArray
                    
                    ] as [String : Any]
                
                let opt = try HTTP.POST(url, parameters: parameters, headers: nil, requestSerializer: JSONParameterSerializer())
                
                print(resultArray.description)
                
                opt.start({ (responsed) in
                    
                    let resp = JSON.init(data: responsed.data)
                    
                    print(resp.description)
                    
                    if resp["errcode"].int == 0 {
                        
                        
                        do {
                            
                            let alRealm = try Realm()
                            
                            let alObjects = alRealm.resolve(resultRef)
                            
                            try alRealm.write {
                                
                                alRealm.delete(alObjects!)
                                
                            }
                            
                        }catch let elseError {
                            
                            print("捕获错误:\(elseError)")
                            return
                            
                        }

                    }
  
                })
                
                
            } catch let error {
                
                print("捕获错误:\(error)")
                return
            }

            
            
        }

        
        
    }

    
    static func uploadProductExposure() {
        
        
        DispatchQueue.global().async {
            
            do {
                
                var resultArray:[Dictionary<String,Any>] = []
                
                let realm = try Realm()
                
                let exposures = realm.objects(productExposure.self)
                
                if exposures.count == 0 {
                    
                    return
                    
                }
                
                let resultRef = ThreadSafeReference(to: exposures)
                
                
                for i in 0..<exposures.count {
                    
                    let currentDC = ["product_alias":exposures[i].productAlias,"count":exposures[i].count] as [String : Any]
                    
                    resultArray.append(currentDC)
                    
                }
                
                var nowToken = ""
                
                if UserDefaults.standard.object(forKey: "userApiToken") != nil {
                    
                    nowToken = UserDefaults.standard.object(forKey: "userApiToken") as! String
                    
                }
                
                let url = YXWRequestV1 + "collect/product?api_token=\(nowToken)"
                
                let parameters = [
                    
                    "type" : "product_exposure",
                    "data" : resultArray
                    
                    ] as [String : Any]
                
                let opt = try HTTP.POST(url, parameters: parameters, headers: nil, requestSerializer: JSONParameterSerializer())
                
                print(resultArray.description)
                
                opt.start({ (responsed) in
                    
                    let resp = JSON.init(data: responsed.data)
                    
                    print(resp.description)
                    
                    if resp["errcode"].int == 0 {
                        
                        
                        do {
                            
                            let alRealm = try Realm()
                            
                            let alObjects = alRealm.resolve(resultRef)
                            
                            try alRealm.write {
                                
                                alRealm.delete(alObjects!)
                                
                            }
                            
                        }catch let elseError {
                            
                            print("捕获错误:\(elseError)")
                            return
                            
                            
                        }
                        
                        
                    }
                    
                    
                })
                
                
            } catch let error {
                
                print("捕获错误:\(error)")
                return
            }

        }

    }
    

}
