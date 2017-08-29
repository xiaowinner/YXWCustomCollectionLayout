enum shownMode:String {
    
    case alone = "单屏"
    case more = "多屏"
    
}

enum detailShownMode:String {
    
    case single = "单列"
    case double = "双列"
    
}


protocol filtrateProtocol {
    
    func detailShownModeOfButtonIndex(_ buttonIndex:Int) -> detailShownMode
    
    func detailShownLeftArrayDataSource(_ buttonIndex:Int) -> [String]
    
    func detailShownRightArrayDataSource(_ buttonIndex:Int, leftIndex:Int) -> [String]
    
    func resultValue(_ detailMode:detailShownMode, detailIndex:Int, key:String)
    
}


//MARK:YXW filtrate view

class YXWFiltrateView: UIView {
    
    enum YXWFiltrateTagSet:Int {
        
        case filtrateButtonTag = 2555
        
        case filtrateLeftTableTag = 2333
        
        case filtrateRightTableTag = 2666
        
    }
    
    
    var titleArray:[String]?
    
    var subLeftArray:[String] = []
    
    var subRightArray:[String] = []
    
    
    //标记每个筛选栏的 detail table 选中状态
    var selectIndexArray:[[Int]] = []
    
    
    var filtrateWidth:CGFloat = 80
    
    var filtrateHeight:CGFloat = 45
    
    
    var scrollView = UIScrollView()
    
    var leftTableView:UITableView!
    
    var rightTableView:UITableView!
    
    var rootView:UIView!
    
    var superViewController:UIViewController!
    
    var currentButtonIndex = -1
    
    var currentLeftIndex = -1
    
    
    var screenMode:shownMode = .alone
    
    var detailMode:detailShownMode = .single
    
    var delegate:filtrateProtocol?
    
    var alsoInit = false
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if !alsoInit {
            
            self.initViewInfo()
            
        }
        
        
    }
    
    
    func hideRootView() {
        
        rootView.isHidden = true
        
        guard let mode = self.delegate?.detailShownModeOfButtonIndex(currentButtonIndex) else {
            
            return
            
        }
        
        switch mode {
            
        case .single:
            
            break
            
        case .double:
            
            if self.selectIndexArray[currentButtonIndex].count == 1 {
                
                self.selectIndexArray[currentButtonIndex].removeAll()
                
            }
            
        }
        
    }
    
    
    open func initFiltrateInfo(_ titles:[String], mode:shownMode) {
        
        self.titleArray = titles
        
        self.screenMode = mode
        
        for _ in titles {
            
            self.selectIndexArray.append([])
            
        }
        
        
    }
    
    
    func initViewInfo() {
        
        initScrollView()
        
        initRootView()
        
        alsoInit = true
        
    }
    
    func initRootView() {
        
        superViewController = self.findViewController()
        
        leftTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100), style: .plain)
        
        leftTableView.delegate = self
        
        leftTableView.dataSource = self
        
        leftTableView.register(UINib(nibName: "selectRegionTableViewCell", bundle: nil), forCellReuseIdentifier: "selectRegionTableViewCell")
        
        leftTableView.tag = YXWFiltrateTagSet.filtrateLeftTableTag.rawValue
        
        rightTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100), style: .plain)
        
        rightTableView.delegate = self
        
        rightTableView.dataSource = self
        
        rightTableView.register(UINib(nibName: "selectRegionTableViewCell", bundle: nil), forCellReuseIdentifier: "selectRegionTableViewCell")
        
        rightTableView.tag = YXWFiltrateTagSet.filtrateRightTableTag.rawValue
        
        
        rootView = UIView(frame: superViewController.view.frame)
        
        rootView.frame.origin.y = self.frame.maxY
        
        let backgroundView = UIView()
        
        backgroundView.frame.origin = CGPoint.zero
        
        backgroundView.frame.size = rootView.frame.size
        
        backgroundView.backgroundColor = UIColor.black
        
        backgroundView.alpha = 0.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideRootView))
        
        backgroundView.addGestureRecognizer(tap)
        
        rootView.addSubview(backgroundView)
        
        rootView.isHidden = true
        
        superViewController.view.addSubview(rootView)
        
        superViewController.view.bringSubview(toFront: rootView)
        
    }
    
    
    
    func initScrollView() {
        
        guard let titles = titleArray else {
            
            return
            
        }
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.addSubview(scrollView)
        
        switch screenMode {
            
        case .more:
            
            break
            
        case .alone:
            
            filtrateWidth = self.frame.size.width/CGFloat(titles.count)
            
        }
        
        self.scrollView.contentSize = CGSize(width: filtrateWidth * CGFloat(titles.count), height: 0)
        
        for i in 0..<titles.count {
            
            let title = titles[i]
            
            let filtrate = Bundle.main.loadNibNamed("filtrateLabelView", owner: nil, options: nil)?.last as! filtrateLabelView
            
            filtrate.frame = CGRect(x: CGFloat(i) * filtrateWidth, y: 0, width: filtrateWidth, height: filtrateHeight)
            
            filtrate.contentLabel.text = title
            
            filtrate.filtrateButton.tag = i + YXWFiltrateTagSet.filtrateButtonTag.rawValue
            
            filtrate.filtrateButton.addTarget(self, action: #selector(showDetailTableView), for: .touchUpInside)
            
            self.scrollView.addSubview(filtrate)
            
        }
        
    }
    
    @objc fileprivate func showDetailTableView(_ button:UIButton) {
        
        let index = button.tag - YXWFiltrateTagSet.filtrateButtonTag.rawValue
        
        currentButtonIndex = index
        
        guard let mode = self.delegate?.detailShownModeOfButtonIndex(index) else {
            
            return
            
        }
        
        guard let dataArray = self.delegate?.detailShownLeftArrayDataSource(index) else {
            
            return
            
        }
        
        var tbHeight = CGFloat(dataArray.count * 40)
        
        if tbHeight >= UIScreen.main.bounds.height * 0.7 {
            
            tbHeight = UIScreen.main.bounds.height * 0.7
            
        }
        
        leftTableView.removeFromSuperview()
        
        rightTableView.removeFromSuperview()
        
        self.rootView.frame.origin.y = self.frame.maxY
        
        self.rootView.isHidden = false
        
        subLeftArray = dataArray
        
        switch mode {
            
        case .single:
            
            leftTableView.frame.size = CGSize(width: self.frame.size.width, height: 0)
            
            rootView.addSubview(leftTableView)
            
            leftTableView.reloadData()
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.leftTableView.frame.size = CGSize(width: self.frame.size.width, height: tbHeight)
                
                self.leftTableView?.layoutIfNeeded()
                
            })
            
        case .double:
            
            leftTableView.frame.size = CGSize(width: self.frame.size.width/3, height: 0)
            
            rightTableView.frame = CGRect(x: leftTableView.frame.size.width, y: 0, width: self.frame.size.width - leftTableView.frame.size.width, height: 0)
            
            rootView.addSubview(leftTableView)
            
            rootView.addSubview(rightTableView)
            
            leftTableView.reloadData()
            
            rightTableView.reloadData()
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.leftTableView.frame.size = CGSize(width: self.frame.size.width/3, height: tbHeight)
                
                self.rightTableView.frame = CGRect(x: self.leftTableView.frame.size.width, y: 0, width: self.frame.size.width - self.leftTableView.frame.size.width, height: tbHeight)
                
                self.leftTableView?.layoutIfNeeded()
                
                self.rightTableView.layoutIfNeeded()
                
            })
            
        }
        
    }
    
    
}


//MARK: tableview datasource && delegate
extension YXWFiltrateView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
            
        case YXWFiltrateTagSet.filtrateLeftTableTag.rawValue:
            
            return subLeftArray.count
            
        case YXWFiltrateTagSet.filtrateRightTableTag.rawValue:
            
            return subRightArray.count
            
        default:
            
            return 0
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectRegionTableViewCell", for: indexPath) as! selectRegionTableViewCell
        
        switch tableView.tag {
            
        case YXWFiltrateTagSet.filtrateLeftTableTag.rawValue:
            
            cell.contentLabel.text = subLeftArray[indexPath.row]
            
            if self.selectIndexArray[currentButtonIndex].first != nil {
                
                if indexPath.row == self.selectIndexArray[currentButtonIndex].first! {
                    
                    cell.contentView.backgroundColor = UIColor.red
                    
                }else {
                    
                    cell.contentView.backgroundColor = UIColor.white
                    
                }
                
            }
            
        case YXWFiltrateTagSet.filtrateRightTableTag.rawValue:
            
            cell.contentLabel.text = subRightArray[indexPath.row]
            
            if self.selectIndexArray[currentButtonIndex].last != nil && self.selectIndexArray[currentButtonIndex].count > 1 {
                
                if indexPath.row == self.selectIndexArray[currentButtonIndex].last! {
                    
                    cell.contentView.backgroundColor = UIColor.red
                    
                }else {
                    
                    cell.contentView.backgroundColor = UIColor.white
                    
                }
                
            } else {
                
                cell.contentView.backgroundColor = UIColor.white
                
            }
            
        default:
            
            break
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let mode = self.delegate?.detailShownModeOfButtonIndex(currentButtonIndex) else {
            
            return
            
        }
        
        
        selectIndexArray[currentButtonIndex].removeAll()
        
        self.leftTableView.reloadData()
        self.rightTableView.reloadData()
        
        if tableView.tag == YXWFiltrateTagSet.filtrateLeftTableTag.rawValue {
            
            currentLeftIndex = indexPath.row
            
            let keyString = titleArray?[currentButtonIndex]
            
            self.selectIndexArray[currentButtonIndex].append(currentLeftIndex)
            
            switch mode {
                
            case .single:
                
                self.delegate?.resultValue(mode, detailIndex: currentLeftIndex, key: keyString!)
                
                hideRootView()
                
                break
                
            case .double:
                
                subRightArray = (self.delegate?.detailShownRightArrayDataSource(currentButtonIndex, leftIndex: indexPath.row))!
                
                rightTableView.reloadData()
                
            }
            
            
        }else {
            
            let rightIndex = indexPath.row
            
            let keyString = subLeftArray[currentLeftIndex]
            
            self.delegate?.resultValue(mode, detailIndex: rightIndex, key: keyString)
            
            self.selectIndexArray[currentButtonIndex].append(currentLeftIndex)
            
            self.selectIndexArray[currentButtonIndex].append(rightIndex)
            
            rightTableView.reloadData()
            
            hideRootView()
            
            
        }
        
    }
    
}
