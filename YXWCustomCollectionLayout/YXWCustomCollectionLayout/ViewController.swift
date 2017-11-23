//  ViewController.swift
//  YXWCustomCollectionLayout
//
//  Created by 原晓文 on 2017/8/30.
//  Copyright © 2017年 原晓文. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    enum collectionMode:Int {
        case single = 0
        case double = 1
        case mix = 2
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var singleRowButton: UIButton!
    @IBOutlet weak var doubleRowButton: UIButton!
    @IBOutlet weak var mixRowButton: UIButton!
    
    var mode:collectionMode = .single
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleRowButton.addTarget(self, action: #selector(rowButtonAction(button:)), for: .touchUpInside)
        doubleRowButton.addTarget(self, action: #selector(rowButtonAction(button:)), for: .touchUpInside)
        mixRowButton.addTarget(self, action: #selector(rowButtonAction(button:)), for: .touchUpInside)
        let customLayout = YXWCustomCollectionLayout()
        collectionView.collectionViewLayout = customLayout
        collectionView.registerXibItemsWithObjects(cells: [testCollectionViewCell.self])
        collectionView.registerXibHeadersWithObjects(headers: [testCollectionReusableView.self])
        customLayout.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func rowButtonAction(button:UIButton) {
        switch button.tag {
        case 1111:
            mode = .single
        case 2222:
            mode = .double
        case 6666:
            mode = .mix
        default:
            return
        }
        collectionView.reloadData()
    }
    


}

extension ViewController:YXWCustomCollectionLayoutProtocol,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //控制布局的 delegate:
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout, headerHeight indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout, heightForItemAtIndex indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(300) + 100)
    }
    
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout, columnNumberOfSection indexPath: IndexPath) -> Int {
        
        switch mode {
        case .single:
            return 1
        case .double:
            return 2
        case .mix:
            if indexPath.section == 1 {
                return 2
            }else {
                return 1
            }
        }
        
    }
    
    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout, edgeMarginOfCell indexPath: IndexPath) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
    //collectionView delegate:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableXibItem(indexPath: indexPath, with: testCollectionViewCell.self)
        cell?.contentLabel.text = "Section:\(indexPath.section),Item:\(indexPath.item)"
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableXibView(indexPath: indexPath, kind: kind, with: testCollectionReusableView.self)
        view?.contentLabel.text = "Section:\(indexPath.section)"
        return view!
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
}

