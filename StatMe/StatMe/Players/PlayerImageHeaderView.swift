//
//  PlayerCollectionHeader.swift
//  StatMe
//
//  Created by spiiral on 5/10/23.
//

import UIKit

class PlayerImageHeaderView: UICollectionReusableView{
    static let reuseIdentifier = "playerHeader"
    let headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel = UILabel()
    let numberLabel = UILabel()
    let posLabel = UILabel()
    let ageLabel = UILabel()
    let heightLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        

        nameLabel.numberOfLines = 1
        nameLabel.minimumScaleFactor = 0.1
        nameLabel.font = UIFont.systemFont(ofSize: 50)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        posLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerImageView)
        addSubview(nameLabel)
        addSubview(numberLabel)
        addSubview(posLabel)
        addSubview(ageLabel)
        addSubview(heightLabel)
        
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 50),
            
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            numberLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            numberLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 20),
            
            posLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            posLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 50),
            
            ageLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            ageLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 80),
            
            heightLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            heightLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 110),
        ])
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder){
        fatalError("")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerImageView.image = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size.height = 200
        return attributes
    }
    func configureImage(image: UIImage){
        headerImageView.image = image
    }
    
    func configureText(text: [String]){
        nameLabel.text = text[0]
        numberLabel.text = text[1]
        posLabel.text = text[2]
        ageLabel.text = text[3]
        heightLabel.text = text[4]
    }
    

}
