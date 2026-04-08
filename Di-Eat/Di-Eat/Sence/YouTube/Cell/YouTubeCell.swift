//
//  YouTubeCell.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/17/25.
//

import UIKit
import Kingfisher

class YouTubeCell: UITableViewCell {
    static let identifier = "YouTubeCell"
    
    var youtubeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .diEatGray100
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()

    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func drawCell(youTube: YouTube) {
        let urlString = "https://img.youtube.com/vi/\(youTube.key)/0.jpg"
        self.youtubeImageView.kf.setImage(with: URL(string: urlString))
//        self.titleLabel.text = youTube.title
//        self.creatorLabel.text = youTube.creator

    }
    
    private func setUI() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        [self.titleLabel, self.creatorLabel].forEach {
            self.youtubeImageView.addSubview($0)
        }
        
        self.contentView.addSubview(self.youtubeImageView)
    }
    
    private func setConstraints() {
        self.youtubeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(180)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.creatorLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(self.titleLabel)
        }
    }
}
