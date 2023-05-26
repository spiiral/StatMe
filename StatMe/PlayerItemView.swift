import UIKit

class PlayerItemView : UIView{
    
    let playerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let catLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12.5)
        return label
    }()
    
    let playerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playerLabel)
        addSubview(playerImageView)
        addSubview(catLabel)
        
        NSLayoutConstraint.activate([
            catLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            catLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            
            playerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            playerLabel.topAnchor.constraint(equalTo: catLabel.bottomAnchor, constant:1)
        ])
    }
    
    required init?(coder: NSCoder){
        fatalError("")
    }
    
    func configureText(text: [String]){
        playerLabel.text = text[1]
        catLabel.text = text[0]
    }

}
