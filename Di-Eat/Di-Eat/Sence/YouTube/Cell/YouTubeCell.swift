//
//  YouTubeCell.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/17/25.
//

import UIKit

class YouTubeCell: UITableViewCell {
    static let identifier = "YouTubeCell"
    
    private var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hexString: "#E2E2E2")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hexString: "#363062")
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 12, weight: .light)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .light)
        label.textColor = UIColor(hexString: "#6B6B6B")
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#BDBDBD", alpha: 0.4)
        return view
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
    
    func drawCell(youTube: YouTubeVideo) {
//        if let imageURL = URL(string: recipe.imageUrl) {
//            self.recipeImageView.kf.setImage(with: imageURL)
//        }
//        self.titleLabel.text = recipe.title
//        self.typeLabel.text = recipe.foodType
//        self.levelLabel.text = recipe.transformedLevel
//        self.dateLabel.text = recipe.formatDate
    }
    
    private func setUI() {
//        self.selectionStyle = .none
//        self.backgroundColor = .white
//        
//        [self.recipeImageView, self.nameLabel, self.typeLabel, self.levelLabel, self.dateLabel, self.lineView].forEach {
//            self.contentView.addSubview($0)
//        }
    }
    
    private func setConstraints() {
        self.recipeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(80)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.recipeImageView.snp.trailing).offset(20)
            make.bottom.equalTo(self.levelLabel.snp.top).offset(-4)
            make.trailing.equalToSuperview().inset(28)
//            make.width.lessThanOrEqualTo(self.contentView.snp.width).multipliedBy(0.75).offset(-127)
        }
        
        self.levelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.recipeImageView)
            make.leading.equalTo(self.titleLabel)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.levelLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.titleLabel)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.typeLabel)
            make.trailing.equalToSuperview().inset(28)
        }
        
        self.lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
