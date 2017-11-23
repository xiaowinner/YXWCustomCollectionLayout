# YXWCustomCollectionLayout

这套自定义CollectionView布局主要是用来解决单双列混合结构瀑布流所制作，详细用法可Clone到本地查看Demo。

**用法**

_1.把项目中的 YXWCustomCollectionLayout.swift 文件拖入项目即可。_
_2.添加的自己的collectionview.collectionViewLayout:_

	   let customLayout = YXWCustomCollectionLayout()
	   collectionView.collectionViewLayout = customLayout 
 
_3.实现4个delegate:_

	    // 决定sectionHeader的 高度
	    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,headerHeight indexPath: IndexPath ) -> CGFloat
	
	    // 决定item的 高度
	    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,heightForItemAtIndex indexPath: IndexPath , itemWidth: CGFloat) -> CGFloat;
	
	    // 决定cell的 列数
	    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,columnNumberOfSection indexPath:IndexPath) -> Int
	
	    // 决定cell的 边缘间距
	    func yxwLayout(waterFlowLayout: YXWCustomCollectionLayout,edgeMarginOfCell indexPath:IndexPath) -> UIEdgeInsets


**截图**
[单列.jpg][1]
[双列.jpg][2]
[混合.jpg][3]

[1]:	https://github.com/xiaowinner/YXWCustomCollectionLayout/blob/master/YXWCustomCollectionLayout/YXWCustomCollectionLayout/1511424211305.jpg
[2]:	https://raw.githubusercontent.com/xiaowinner/YXWCustomCollectionLayout/master/YXWCustomCollectionLayout/1511424228708.jpg "1511424228708.jpg"
[3]:	https://raw.githubusercontent.com/xiaowinner/YXWCustomCollectionLayout/master/YXWCustomCollectionLayout/1511424246479.jpg "1511424246479.jpg"