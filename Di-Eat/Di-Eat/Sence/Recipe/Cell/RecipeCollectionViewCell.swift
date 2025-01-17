//
//  RecipeCollectionViewCell.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/16/25.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    // MARK: - Property
    static let identifier = "RecipeCollectionViewCell"
    
    private var view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1.6
        view.layer.borderColor = UIColor(hexString: "#BDBDBD", alpha: 0.4).cgColor
        return view
        
    }()
    private var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hexString: "#E2E2E2")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var rankingLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor =  UIColor(hexString: "#5BDAA4")
        label.font = .poppins(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1.6
        label.layer.borderColor = UIColor(hexString: "#BDBDBD", alpha: 0.4).cgColor
        label.clipsToBounds = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .poppins(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hexString: "#363062")
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .light)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawCell(index: Int, recipe: Recipe) {
        if let imageURL = URL(string: recipe.imageUrl) {
            self.recipeImageView.kf.setImage(with: imageURL)
        }
        self.rankingLabel.text = String(index)
        self.titleLabel.text = recipe.title
        self.typeLabel.text = recipe.foodType + ", \(recipe.materialType)"
        self.levelLabel.text = recipe.transformedLevel
    }
    
    private func setUI() {
        self.contentView.addSubview(self.view)
        self.recipeImageView.addSubview(self.rankingLabel)
        
        [self.recipeImageView, self.titleLabel, self.typeLabel, self.levelLabel].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.recipeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(self.contentView).multipliedBy(0.6)
        }
        
        self.rankingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.size.equalTo(28)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.recipeImageView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self.recipeImageView).inset(4)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLabel)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.levelLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.titleLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
