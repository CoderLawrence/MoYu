//
//  MYImagePickerViewController.swift
//  MoYu
//  相册主页面
//  Created by Lawrence on 2018/7/27.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

protocol MYImagePickerViewDelegate: class {
    
    /// 取消图片选择器
    ///
    /// - Parameter imagePicker: 图片选择器
    func didCancelImagePicker(imagePicker: MYImagePickerViewController)
    
    /// 完成图片选择
    ///
    /// - Parameters:
    ///   - imagePicker: 图片选择器
    ///   - images: 选中的图片集合
    func didSelectedImage(imagePicker: MYImagePickerViewController, images:[MYImagePickerItemModel]?)
}

protocol MYImaegPickerViewDataSource: class {
    
}

class MYImagePickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MYImagePickerViewModelDelegate, MYImagePickerAlbumSwitchButtonDelegate, MYImagePickerAlbumListViewDelegate {
    
    /// 委托
    open weak var delegate: MYImagePickerViewDelegate? = nil
    
    /// 数据源
    open weak var dataSource: MYImaegPickerViewDataSource? = nil
    
    // MARK: - init
    
    /// 显示相册
    ///
    /// - Parameter viewController: 要弹出相册的控制器
    public class func show(in viewController: UIViewController, delegate: MYImagePickerViewDelegate?) {
        
        let vc: MYImagePickerViewController = MYImagePickerViewController()
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: vc)
        
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        //加载系统相册数据
        self.viewModel.loadAlbumList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupNavigationBar(isTranslucent: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        //设置导航栏背景颜色不透明
        self.setupNavigationBar(isTranslucent: false)
        
        //修正视图大小
        var viewFrame = self.view.frame
        viewFrame.size.height -= self.my_navigationAndStatusBarHeight()
        self.view.frame = viewFrame
        
        //background
        self.view.backgroundColor = UIColor.white
        
        //barButtonItem
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        
        //collectionView
        self.collectionView.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        
        // 相册切换按钮
        self.navigationItem.titleView = self.albumSwitchButton
        
        // 相册列表
        self.view.addSubview(self.albumListView)
    }
    
    private func setupNavigationBar(isTranslucent: Bool) {
        //设置导航栏不透明
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
    }
    
    // MARK: - lazy load
    
    lazy var viewModel: MYImagePickerViewModel = {
        () -> MYImagePickerViewModel in
        
        let tempViewModel: MYImagePickerViewModel = MYImagePickerViewModel()
        tempViewModel.viewController = self
        tempViewModel.delegate = self
        
        return tempViewModel
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
      () -> UICollectionViewFlowLayout in
        
        let itemSpace: CGFloat = MYImagePickerCell.itemSpace
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = CGFloat(floorf(Float((screenWidth - 3 * itemSpace - itemSpace * 2)/4)))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = itemSpace
        layout.minimumLineSpacing = itemSpace
        
        return layout
    }()
    
    /// 相册图片列表
    lazy var collectionView: UICollectionView = {
        () -> UICollectionView in
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let tempCollectionView: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: self.layout)
        tempCollectionView .register(MYImagePickerCell.classForCoder(), forCellWithReuseIdentifier: kMYImagePickerCellReuseIdentifier)
        tempCollectionView.delegate = self;
        tempCollectionView.dataSource = self;
        
        return tempCollectionView
    }()
    
    lazy var leftBarButtonItem: UIBarButtonItem = {
       () -> UIBarButtonItem in
        let item: UIBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onLeftBarButtonPress))
        
        return item
    }()
    
    /// 相册切换按钮
    lazy var albumSwitchButton: MYImagePickerAlbumSwitchButton = {
        () -> MYImagePickerAlbumSwitchButton in
        
        let height = 30
        let width: Int = Int(UIScreen.main.bounds.size.width)
        let tempButton: MYImagePickerAlbumSwitchButton = MYImagePickerAlbumSwitchButton()
        tempButton.frame = CGRect.init(x: width/2, y: 0, width: width, height: height)
        tempButton.delegate = self
        tempButton.title = "选择相册"
        
        return tempButton
    }()
    
    /// 相册列表
    lazy var albumListView: MYImagePickerAlbumListView = {
        () -> MYImagePickerAlbumListView in
        
        let width: CGFloat = self.view.frame.size.width
        let height: CGFloat = self.view.frame.size.height
        let tempListView: MYImagePickerAlbumListView = MYImagePickerAlbumListView()
        tempListView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        tempListView.addTarget(self, action: #selector(onAlbumListPress), for: UIControl.Event.touchUpInside)
        tempListView.delegate = self
        tempListView.show(isPackUp: true, animation: false)
        
        return tempListView
    }()
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: MYImagePickerCell.itemSpace, left: MYImagePickerCell.itemSpace, bottom: MYImagePickerCell.itemSpace, right: MYImagePickerCell.itemSpace)
    }
    
    // MARK: - UICollectionViewDelegate && UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.viewModel.currentAlbum != nil {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.viewModel.currentAssetList.count > 0) {
            return self.viewModel.currentAssetList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MYImagePickerCell = collectionView .dequeueReusableCell(withReuseIdentifier: kMYImagePickerCellReuseIdentifier, for: indexPath) as! MYImagePickerCell
        let assetItem: MYImagePickerItemModel = self.viewModel.currentAssetList[indexPath.row]
        cell.setAssetItem(item: assetItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.viewModel.onClickToPreviewAssetItem(index: indexPath.row)
    }
    
    // MARK: - MYImagePickerViewModelDelegate
    
    func didFinishLoadAlbumList(_ viewModel: MYImagePickerViewModel, _ list: [MYImagePickerAlbumModel]?) {
        if (list != nil && (list?.count)! > 0) {
            self.albumListView.albumList = list
            self.viewModel.loadAssetList(album: self.viewModel.currentAlbum!)
        }
    }
    
    func didFinishLoadAssetList(_ viewModel: MYImagePickerViewModel, _ list: [MYImagePickerItemModel]?) {
        if self.viewModel.currentAssetList.count > 0 {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - MYImagePickerAlbumSwitchButtonDelegate
    
    func didSwitchAlbum(switchButton: MYImagePickerAlbumSwitchButton, isSwitch: Bool) {
        self.albumListView.show(isPackUp: !isSwitch, animation: true)
    }
    
    // MARK: - MYImagePickerAlbumListViewDelegate
    
    func didSelectedAlbum(listView: MYImagePickerAlbumListView, albumItem: MYImagePickerAlbumModel) {
        self.viewModel.loadAssetList(album: albumItem)
        self.albumSwitchButton.title = albumItem.name
        self.albumSwitchButton.packupAlbum()
    }
    
    // MARK: - action
    
    @objc private func onLeftBarButtonPress() {
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func onAlbumListPress() {
        self.albumSwitchButton.packupAlbum()
    }
}
