//
//  PlayerCollectionHeader.swift
//  StatMe
//
//  Created by spiiral on 5/10/23.
//

import UIKit

class TeamImageHeaderView: UICollectionReusableView{
    static let reuseIdentifier = "infoHeader"
    let headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel = UILabel()
    let confLabel = UILabel()
    let divLabel = UILabel()
    let recordLabel = UILabel()
    let totLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    
        

        nameLabel.numberOfLines = 1
        nameLabel.minimumScaleFactor = 0.1
        nameLabel.font = UIFont.systemFont(ofSize: 50)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        confLabel.translatesAutoresizingMaskIntoConstraints = false
        divLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        totLabel.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerImageView)
        addSubview(nameLabel)
        addSubview(confLabel)
        addSubview(divLabel)
        addSubview(recordLabel)
        addSubview(totLabel)
        
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 50),
            
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            recordLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            recordLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 10),
            
            confLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            confLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 50),
            
            divLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            divLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 90),
            
            totLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 40),
            totLabel.topAnchor.constraint(equalTo: headerImageView.topAnchor, constant: 130),
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
    
    func configureImage(image: UIImage){
        headerImageView.image = image
    }
    
    func configureText(text: [String]){
        nameLabel.text = text[0]
        recordLabel.text = text[1]
        confLabel.text = text[2]
        divLabel.text = text[3]
        totLabel.text = text[4]
    }
    

}
