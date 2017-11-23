import UIKit


//MARK: ==========注册 && 加载Item==========
extension UICollectionView {
    
    func registerXibItemsWithObjects<T:UICollectionViewCell>(cells: [T.Type]) {
        for cell in cells {
            let name = "\(type(of: cell.init()))"
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            register(currentNib, forCellWithReuseIdentifier: name)
        }
    }
    
    func registerXibHeadersWithObjects<T:UICollectionReusableView>(headers: [T.Type]) {
        for header in headers {
            let name = "\(type(of: header.init()))"
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            register(currentNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: name)
        }
    }
    

    func dequeueReusableXibItem<T:UICollectionViewCell>(indexPath:IndexPath, with: T.Type) -> T? {
        guard let item = dequeueReusableCell(withReuseIdentifier: "\(type(of: T()))", for: indexPath) as? T else {
            return nil
        }
        return item
    }
    

    func dequeueReusableXibView<T:UICollectionReusableView>(indexPath:IndexPath,  kind:String, with: T.Type) -> T? {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(type(of: T()))", for: indexPath) as? T else {
            return nil
        }
        return view
    }
    
}



//MARK: ==========注册 && 加载Cell==========
extension UITableView {
    
    func registerXibCellWithObjects<T:UITableViewCell>(cells: [T.Type]) {
        for cell in cells {
            let name = "\(type(of: cell.init()))"
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            register(currentNib, forCellReuseIdentifier: name)
        }
    }
    
    func registerXibHeaderWithObjects<T:UITableViewHeaderFooterView>(headers: [T.Type]) {
        for header in headers {
            let name = "\(type(of: header.init()))"
            let currentNib = UINib(nibName: name, bundle: Bundle.main)
            register(currentNib, forHeaderFooterViewReuseIdentifier: name)
        }
    }
    
    
    func dequeueReusableXibCell<T:UITableViewCell>(with: T.Type) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: "\(type(of: T()))") as? T else {
            return nil
        }
        cell.selectionStyle = .none
        return cell
    }
    

    func dequeueReusableXibHeader<T:UITableViewHeaderFooterView>(with: T.Type) -> T? {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: "\(type(of: T()))") as? T else {
            return nil
        }
        return header
    }
    
}



//MARK: ==========系统版本判断==========
struct YXWSystemVersion {
    
    static func systemVersionEqualTo(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedSame
    }
    
    static func systemVersionGreaterThan(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedDescending
    }
    
    static func systemVersionGreaterThanOrEqualTo(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedAscending
    }
    
    static func systemVersionLessThan(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
    }
    
    static func systemVersionLessThanOrEqualTo(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedDescending
    }
    
}

