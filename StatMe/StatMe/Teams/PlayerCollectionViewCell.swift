import UIKit

class PlayerCollectionViewCell : UICollectionViewCell{
    static let reuseIdenitfier = "topplayers"
    
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]
    
    let playerId = Int()
    
    let playerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
 
    
    let playerView = PlayerItemView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playerView)
        
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder){
        fatalError("")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerView.playerLabel.text = nil
        playerView.playerImageView.image = nil
    }
    
    func configureText(text: [String]){
        playerView.playerLabel.text = text[1]
        playerView.catLabel.text = text[0]
    }

  
}
