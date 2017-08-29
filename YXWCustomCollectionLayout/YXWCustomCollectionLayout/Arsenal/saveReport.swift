import UIKit
import RealmSwift
import SwiftHTTP
import SwiftyJSON

class saveReport: NSObject {
    
    static func notesSubjectExposure(_ subjectAlias:String) {
        
        DispatchQueue.global(qos: .background).async {
    
            do {
                
                let realm = try Realm()
                
                let subject = realm.object(ofType: subjectExposure.self, forPrimaryKey: subjectAlias)
                
                if subject != nil {
                    
                    let currentCount = (subject?.count)! + 1
                    
                    try realm.write {
                        
                        subject?.count = currentCount
                        
                    }
                    
                }else {
                    
                    let newSubject = subjectExposure()
                    
                    newSubject.count = 1
                    
                    newSubject.subjectAlias = subjectAlias
                    
                    try realm.write {
                        
                        realm.add(newSubject, update: true)
                        
                    }
                    
                }
                
            } catch {
                
                print("数据库错误")
                return
                
            }

            
        }

    }
    
    
    static func notesProductExposure(_ productAlias:String) {
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                
                let realm = try Realm()
                
                let product = realm.object(ofType: productExposure.self, forPrimaryKey: productAlias)
                
                if product != nil {
                    
                    let currentCount = (product?.count)! + 1
                    
                    try realm.write {
                        
                        product?.count = currentCount
                        
                    }
                    
                }else {
                    
                    let newProduct = productExposure()
                    
                    newProduct.count = 1
                    
                    newProduct.productAlias = productAlias
                    
                    try realm.write {
                        
                        realm.add(newProduct, update: true)
                        
                    }
                    
                }
                
            } catch {
                
                print("数据库错误")
                return
                
            }
            
            
        }
        
    }

}
