//
//  MYImagePickerAlbumCell.swift
//  MoYu
//  相册列表项视图
//  Created by Lawrence on 2018/8/2.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

let kMYImagePickerAlbumCellReuseIdentifier = "kMYImagePickerAlbumCellReuseIdentifier"

class MYImagePickerAlbumCell: UITableViewCell {
    
    // MARK: - setter && getter
    public var albumItem: MYImagePickerAlbumModel? {
        didSet {
            if (self.albumItem != nil) {
                
                self.albumTitleLabel.text = self.albumItem?.name
                self.photoCountLabel.text = String.init(format: "%d", (self.albumItem?.count)!)
                
                if (self.albumItem?.thumbnailImage != nil) {
                     self.albumImageView.image = albumItem?.thumbnailImage
                } else {
                    self.albumItem?.asyncGetThumbnailImage({ (image) in
                        self.albumImageView.image = image
                    })
                }
            }
        }
    }
    
    // MARK: - class func
    
    /// cell 高度
    class func cellHeight() -> CGFloat {
        let height: CGFloat = 80
        return height
    }
    
    // MARK: - init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.albumImageView)
        self.contentView.addSubview(self.albumTitleLabel)
        self.contentView.addSubview(self.photoCountLabel)
    }
    
    /// 相册封面图片
    private lazy var albumImageView: UIImageView = {
        () -> UIImageView in
        let marginX: CGFloat = 16
        let marginY: CGFloat = 10
        let width: CGFloat = MYImagePickerAlbumCell.cellHeight() - marginY * 2
        let tempImageView: UIImageView = UIImageView(frame: CGRect(x: marginX, y: marginY, width: width, height: width))
        tempImageView.contentMode = UIViewContentMode.scaleAspectFill
        tempImageView.clipsToBounds = true
        
        return tempImageView
    }()
    
    /// 相册名字
    private lazy var albumTitleLabel: UILabel = {
        () -> UILabel in
        let height: CGFloat = 30
        let width: CGFloat = UIScreen.main.bounds.size.width - self.albumImageView.frame.size.width - 16 * 2
        let marginX: CGFloat = self.albumImageView.frame.maxX + 16
        let marginY: CGFloat = self.albumImageView.frame.minY
        let tempTitleLabel: UILabel = UILabel.init(frame: CGRect(x: marginX, y: marginY, width: width, height: height))
        tempTitleLabel.font = UIFont.systemFont(ofSize: 17)
        tempTitleLabel.textColor = UIColor.black
        tempTitleLabel.textAlignment = NSTextAlignment.left
        tempTitleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tempTitleLabel.numberOfLines = 1
        
        return tempTitleLabel
    }()
    
    /// 相册图片个数
    private lazy var photoCountLabel: UILabel = {
        () -> UILabel in
        let height: CGFloat = 20
        let width: CGFloat = UIScreen.main.bounds.size.width - self.albumImageView.frame.size.width - 16 * 2
        let marginX: CGFloat = self.albumImageView.frame.maxX + 16
        let marginY: CGFloat = self.albumTitleLabel.frame.maxY
        let tempLabel: UILabel = UILabel.init(frame: CGRect(x: marginX, y: marginY, width: width, height: height))
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        tempLabel.textColor = UIColor.black
        tempLabel.textAlignment = NSTextAlignment.left
        tempLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tempLabel.numberOfLines = 1
        
        return tempLabel
    }()
}
