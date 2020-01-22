//
//  ResultsCell.swift
//  Foodventures
//
//  Created by Frank Su on 2020-01-21.
//  Copyright © 2020 frankusu. All rights reserved.
//

import UIKit

class ResultsCell: UICollectionViewCell {
    
    let foodImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .yellow
        iv.widthAnchor.constraint(equalToConstant: 128).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 128).isActive = true
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        iv.layer.borderWidth = 0.5
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Kraby Paddy"
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.text = "Bikini Bottom"
        return label
    }()
    
    let aliasLabel : UILabel = {
        let label = UILabel()
        label.text = "Burgers"
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$"
        return label
    }()
    
    let ratingsLabel : UILabel = {
        let label = UILabel()
        label.text = "10/10"
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let labelStackView = UIStackView(arrangedSubviews: [
            nameLabel,
            locationLabel,
            aliasLabel,
            priceLabel,
            ratingsLabel
        ])
        labelStackView.spacing = 3
        labelStackView.axis = .vertical
        
        let infoStackView = UIStackView(arrangedSubviews: [
            foodImageView,
            labelStackView
        ])
        infoStackView.spacing = 12
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.alignment = .center
        
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: self.topAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -12),
            infoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
