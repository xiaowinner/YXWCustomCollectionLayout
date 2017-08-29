import UIKit

class shopFreeGroupPopupView: UIView {
    
    @IBOutlet weak var openGroupButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var dates:[freeCouponModel] = [] {
        
        didSet {
            
            tableView.reloadData()
            
        }
        
        
    }
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXibCell(["popupFreeCouponTableViewCell"])
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 12
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        tableView.separatorStyle = .none
        
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    
}


extension shopFreeGroupPopupView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dates.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupFreeCouponTableViewCell", for: indexPath) as! popupFreeCouponTableViewCell
        
        cell.selectionStyle = .none
        
        cell.timeLabel.text = dates[indexPath.row].deadline!
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    
}
