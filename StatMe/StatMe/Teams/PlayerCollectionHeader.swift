//
//  PlayerCollectionHeader.swift
//  StatMe
//
//  Created by spiiral on 5/10/23.
//

import UIKit

class PlayerCollectionHeaderView: UICollectionReusableView{
    static let reuseIdentifier = "statsHeader"
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
        
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),

        ])
    }
    
    required init?(coder: NSCoder){
        fatalError("")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        headerLabel.text = nil
    }
    
    func configureText(text: String){
        headerLabel.text = text
    }

}
