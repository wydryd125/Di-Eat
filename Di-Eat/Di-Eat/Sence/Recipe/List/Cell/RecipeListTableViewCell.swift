//
//  RecipeListTableViewCell.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/31/25.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "RecipeListTableViewCell"
    
    private var rankingLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .diEatNavy
        label.font = .poppins(ofSize: 10, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.8
        label.layer.borderColor = UIColor.diEatGray100.cgColor
        label.clipsToBounds = true
        return label
    }()
    
    private var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .diEatGray100
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let detailView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 10, weight: .medium)
        label.textColor = .diEatGray600
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .diEatGray400
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
    
    func drawCell(type: RecipeType = .new, recipe: Recipe, index: Int) {
        if let imageURL = URL(string: recipe.imageUrl) {
            self.recipeImageView.kf.setImage(with: imageURL)
        }
        
        self.rankingLabel.backgroundColor = type == .best ? .diEatOrange : .diEatNavy
        self.rankingLabel.text = String(index)
        self.titleLabel.text = recipe.title
        
        let cookingTime = recipe.cookingTime == "" ? "30분 이내" : recipe.cookingTime
        self.detailLabel.text = "\(recipe.transformedLevel) / \(recipe.foodType) / \(cookingTime)"
    }
    
    private func setUI() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        [self.rankingLabel, self.recipeImageView, self.detailView, self.lineView].forEach {
            self.contentView.addSubview($0)
        }
        
        [self.titleLabel, self.detailLabel].forEach {
            self.detailView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.rankingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        self.recipeImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.rankingLabel.snp.trailing).offset(16)
            make.centerY.equalTo(self.detailView)
            make.size.equalTo(48)
        }
        
        self.detailView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(self.recipeImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(48)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.snp.centerY).offset(-8)
        }
        
        self.detailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
