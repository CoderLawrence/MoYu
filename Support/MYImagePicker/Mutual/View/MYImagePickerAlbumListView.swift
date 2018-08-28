//
//  MYImagePickerAlbumListView.swift
//  MoYu
//  相册列表
//  Created by Lawrence on 2018/7/31.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

protocol MYImagePickerAlbumListViewDelegate: NSObjectProtocol {
    func didSelectedAlbum(listView: MYImagePickerAlbumListView, albumItem: MYImagePickerAlbumModel)
}

class MYImagePickerAlbumListView: UIControl, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - setter && getter
    
    /// 委托
    public weak var delegate: MYImagePickerAlbumListViewDelegate? = nil
    
    /// 相册列表数据
    public var albumList: Array<MYImagePickerAlbumModel>? {
        didSet {
            if (self.albumList != nil && (self.albumList?.count)! > 0) {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutViews()
    }
    
    private func setupUI() {
        
        //背景色相关
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        //相册列表
        self.addSubview(self.tableView)
    }
    
    // MARK: - lazy load
    
    /// 相册列表
    private lazy var tableView: UITableView = {
       () -> UITableView in
        let tempTableView: UITableView = UITableView()
        tempTableView.register(MYImagePickerAlbumCell.classForCoder(), forCellReuseIdentifier: kMYImagePickerAlbumCellReuseIdentifier)
        tempTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tempTableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        tempTableView.frame = CGRect.zero
        tempTableView.delegate = self
        tempTableView.dataSource = self
        
        return tempTableView
    }()
    
    // MARK: - private func
    
    private func layoutViews() {
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height/2
        self.tableView.frame = CGRect(x: 0, y: -height, width: width, height: height)
    }
    
    // MARK: - public func
    
    /// 显示或者收取相册列表
    ///
    /// - Parameter isPackUp: 显示/收起
    public func show(isPackUp: Bool, animation: Bool) {
        
        if (animation == false) {
            self.isHidden = isPackUp
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            
            self.isHidden = isPackUp
            let maxY: CGFloat = self.tableView.frame.size.height
            var tableViewFrame: CGRect = self.tableView.frame

            if isPackUp {
                tableViewFrame.origin.y -= maxY
                self.tableView.frame = tableViewFrame
                self.backgroundColor = UIColor.black.withAlphaComponent(0)
                self.tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
            } else {
                tableViewFrame.origin.y += maxY
                self.tableView.frame = tableViewFrame
                self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.tableView.backgroundColor = UIColor.white.withAlphaComponent(1)
            }
        }
    }
    
    // MARK: - UITableViewDataSource && UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.albumList != nil && (self.albumList?.count)! > 0) {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.albumList != nil && (self.albumList?.count)! > 0) {
            return (self.albumList?.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MYImagePickerAlbumCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MYImagePickerAlbumCell = tableView.dequeueReusableCell(withIdentifier: kMYImagePickerAlbumCellReuseIdentifier, for: indexPath) as! MYImagePickerAlbumCell
        cell.albumItem = self.albumList?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let albumItem: MYImagePickerAlbumModel = self.albumList![indexPath.row]
        if (self.delegate != nil) {
            self.delegate?.didSelectedAlbum(listView: self, albumItem: albumItem)
        }
    }
    
    // MARK: - 重写方法
    
    // 处理事件传递问题, 避免事件传递导致相册列表的事件混乱
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            
            let superViews: Array<UIView> = self.subviews
            
            for i in (0..<superViews.count).reversed() {
                let subView: UIView = superViews[i]
                let newPoint: CGPoint = self.convert(point, to: subView)
                let view: UIView? = subView.hitTest(newPoint, with: event)
                if view != nil {
                    return view
                }
            }
            
            return super.hitTest(point, with: event)
        }
        
        return nil
    }
}
