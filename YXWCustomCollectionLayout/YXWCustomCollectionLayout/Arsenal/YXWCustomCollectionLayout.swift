import UIKit

protocol YXWCustomCollectionLayoutProtocol:class {
    
    
    // 决定sectionHeader的 高度
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,headerHeight indexPath: IndexPath ) -> CGFloat;
    
    // 决定item的 高度
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,heightForRowAtIndex indexPath: IndexPath , itemWidth: CGFloat) -> CGFloat;
    
    // 决定cell的 列数
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,columnNumberOfSection indexPath:IndexPath) -> Int
    
    // 决定cell的 边缘间距
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,edgeMarginOfCell indexPath:IndexPath) -> UIEdgeInsets
    
    
}



class YXWCustomCollectionLayout: UICollectionViewFlowLayout {
    
    
    // MARK: - 定义属性
    weak var delegate: YXWCustomCollectionLayoutProtocol?
    
    // 总列数
    fileprivate var colCount : Int = 2
    
    // 设置停留位置，默认为64(没有导航栏同样设置有效)
    var naviHeight: CGFloat = 0
    
    // 第一个Item 确认 Y 值
    fileprivate var subjectOneY:CGFloat = 0
    
    // 布局属性数组
    fileprivate lazy var attrsArray = [UICollectionViewLayoutAttributes]()
    
    // 存放所有列的当前高度
    fileprivate lazy var colHeights = [CGFloat]()
    
    // 存放所有行的高度
    fileprivate lazy var rowHeights = [CGFloat]()
    
    // Header吸附开关
    var headerAdsorb = false

    fileprivate var defaultHeaderY: CGFloat = 0

    fileprivate var sectionMargin: CGFloat = 0

    
    
    override func invalidateLayout() {
        
        colHeights.removeAll()
        
        rowHeights.removeAll()
        
        attrsArray.removeAll()
        
        subjectOneY = 0
        
        super.invalidateLayout()
        
    }
    
    
    override func prepare() {
        
        
        if attrsArray.isEmpty {
            
            for _ in 0..<colCount {
                
                colHeights.append(0.0)
                
            }
            
            let secNM = collectionView?.numberOfSections
            
            for j in 0..<secNM! {
                
                let count = collectionView?.numberOfItems(inSection: j)
                
                let headerHeight = delegate?.yxwLayout(waterFlowLayout: self, headerHeight: IndexPath(item: 0, section: j))
                
                if headerHeight == 0 {
                    
                } else{
                    
                    attrsArray.append(calculateHeaderAttributes(j))
                    
                }
                
                for i in 0..<count! {
                    
                    let indexPath = IndexPath(item: i, section: j)
                    
                    // 获取indexPath对应cell的布局属性
                    let itemAttribute = calculateItemAttributes(indexPath)
                    
                    rowHeights.append(itemAttribute.frame.size.height)
                    
                    attrsArray.append(itemAttribute)
                    
                }
                
            }
            
        }

    }
    
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return headerAdsorb
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if headerAdsorb {
            
            let collectionViewTopY = (collectionView?.contentOffset.y)! + (collectionView?.contentInset.top)!
            
            for layoutAttributes in attrsArray {
                
                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                    
                    
                    if collectionViewTopY > defaultHeaderY {
                        
                        let offset = (collectionView?.contentOffset.y)! + naviHeight
                        
                        layoutAttributes.frame.origin.y = offset
                        
                    }else {
                        
                        layoutAttributes.frame.origin.y = defaultHeaderY
                        
                    }
                    
                    layoutAttributes.zIndex = 1111
                    
                }
                
            }
            
            
        }
        
        return attrsArray
        
    }
    

    
    // 决定collectionView的可滚动范围
    override var collectionViewContentSize: CGSize {
        
        var maxHeight: CGFloat = colHeights.first!
        
        for i in 0..<colCount {
            
            let value: CGFloat = colHeights[i]
            
            if maxHeight < value {
                
                maxHeight = value
                
            }
        }
        
        return CGSize(width: 0, height: maxHeight + 5)
        
    }
    
    
    
    
    
    //Item 计算方法
    func calculateItemAttributes(_ indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        
        let itemAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        
        // 最短列
        var destCol = 0
        
        var minColHeight = colHeights.first!
        
        // 当前内边距
        let edgeInset = delegate?.yxwLayout(waterFlowLayout: self, edgeMarginOfCell: indexPath)
        
        
        // 列间距
        let listDistance = edgeInset?.right
        
        
        // 行间距
        let rowDistance = edgeInset?.bottom
        
        
        // 当前列数
        let currentColcount = delegate?.yxwLayout(waterFlowLayout: self, columnNumberOfSection: indexPath)
        
        
        // 找出高度最短的那一列
        for i in 0..<currentColcount! {
            
            let colHeight = colHeights[i]
            
            if minColHeight > colHeight {
                
                minColHeight = colHeight
                
                destCol = i
                
            }
            
        }
        
        
        if indexPath.item == 0 {
            
            destCol = 0
            
        }
        
        // 计算每个item宽度
        // (collectionView宽度 - 左右间距 - 列间距) / 总列数
        let width = (collectionView?.frame.width)! - edgeInset!.left - edgeInset!.right
        
        let w = (width - CGFloat(currentColcount! - 1) * listDistance!) / CGFloat(currentColcount!)
        
        // 使用代理决定外部cell的高度
        let h = delegate?.yxwLayout(waterFlowLayout: self, heightForRowAtIndex: indexPath, itemWidth: w)
        
        let x = edgeInset!.left + CGFloat(destCol) * (w + listDistance!)
        
        var y = minColHeight + (edgeInset?.top)!
        
        if  indexPath.item == 0 {
            
            var resultHeight:CGFloat = 0
            
            for a in rowHeights {
                
                resultHeight += a
                
            }
            
            y = resultHeight
            
        }
        
        
        if y != 0 {
            
            
            if indexPath.item == 0 {
                
                y = y + rowDistance! + (edgeInset?.top)!
                
            }else {
                
                y = y + rowDistance!
                
            }
            
        }
        
        
        
        if currentColcount == 2 {
            
            if indexPath.item == 0 {
                
                subjectOneY = y
                
            }
            
            
            if indexPath.item == 1 {
                
                y = subjectOneY
                
            }
            
            
        }
        
        
        if h! <= 0 {
            
            y = minColHeight
            
        }
        
        itemAttribute.frame = CGRect(x: x, y: y, width: w, height: h!)
        
        colHeights[destCol] = y + h!
        
        return itemAttribute

        
    }

    
    
    //Header 计算方法
    func calculateHeaderAttributes(_ section:Int) -> UICollectionViewLayoutAttributes {
        
        let headerHeight = delegate?.yxwLayout(waterFlowLayout: self, headerHeight: IndexPath(item: 0, section: section))
        
        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind:     UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
       
        
        var resultHeight:CGFloat = sectionMargin
        
        for a in rowHeights {
            
            resultHeight += a
            
        }
        
        headerAttributes.frame = CGRect.init(x: 0, y: resultHeight, width: screenWidth, height: headerHeight!)
        
        defaultHeaderY = resultHeight

        rowHeights.append(headerHeight!)
        
        return headerAttributes
        
    }
    
    
}
