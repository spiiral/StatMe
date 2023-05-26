//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit

struct PlayerInfoResult: Codable{
    let player: Player
}
struct PlayerStatsResult: Codable{
    let statistics: PlayerStats
    let team: Team
}

struct PlayerStats: Codable{
    let appearances: Int
    let defensiveAssistTackles: Int?
    let defensiveCombinedTackles: Int?
    let defensiveFgBlocked: Int?
    let defensiveExtraBlocked: Int?
    let defensiveForcedFumbles: Int?
    let defensivePassesDefensed: Int?
    let defensivePuntsBlocked: Int?
    let defensiveSacks: Int?
    let defensiveSafeties: Int?
    let defensiveTotalTackles: Int?
    let fumbleFumbles: Int?
    let fumbleLost: Int?
    let fumbleRecovery: Int?
    let fumbleTouchdownReturns: Int?
    let kickingExtraAttempts: Int?
    let kickingExtraMade: Int?
    let kickingExtraPercentage: Float?
    let kickingFgAttempts: Int?
    let kickingFgMade: Int?
    let kickingFgMade50plus: Int?
    let kickingFgLong: Int?
    let kickingFgPercentage: Float?
    let kickoffYards: Int?
    let passingAttempts: Int?
    let passingCompletionPercentage: Float?
    let passingCompletions: Int?
    let passingFirstDownPercentage: Float?
    let passingFirstDowns: Int?
    let passingFortyPlus: Int?
    let passingInterceptionPercentage: Float?
    let passingInterceptions: Int?
    let passingLongest: Int?
    let passingNetYards: Int?
    let passingPasserRating: Float?
    let passingSacked: Int?
    let passingSackedYardsLost: Int?
    let passingTouchdownInterceptionRatio: Float?
    let passingTouchdownPercentage: Float?
    let passingTouchdowns: Int?
    let passingYards: Int?
    let passingYardsPerAttempt: Float?
    let passingYardsPerGame: Float?
    let receivingFirstDownPercentage: Float?
    let receivingFirstDowns: Int?
    let receivingFortyPlus: Int?
    let receivingFumbles: Int?
    let receivingLongest: Int?
    let receivingReceptions: Int?
    let receivingTargets: Int?
    let receivingTouchdowns: Int?
    let receivingYards: Int?
    let receivingYardsPerReception: Float?
    let rushingAttempts: Int?
    let rushingFirstDownPercentage: Float?
    let rushingFirstDowns: Int?
    let rushingFortyPlus: Int?
    let rushingLongest: Int?
    let rushingYards: Int?
    let rushingYardsPerAttempt: Float?
    let rushingYardsPerGame: Float?
    
}
class PlayerStatsViewController: UICollectionViewController{
    
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]
    var playerName = String()
    var playerId = Int()
    var season = String()
    var seasonId = Int()
    var nameLabel = UILabel()
    
    var image = UIImage()
    let playerImageView = UIImageView()
    
    var playerDob = Int()
    var playerHeight = Int()
    var playerNumber = Int()
    var playerPos = String()
    
    var playerStats: [String: Any] = [:]
    var validKeys = [String]()
    
    
    override init(collectionViewLayout: UICollectionViewLayout){
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var statsRequest = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/player/\(playerId)/tournament/9464/season/\(seasonId)/statistics/regularSeason")! as URL,
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
        
        collectionView.register(PlayerImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "playerHeader")
        collectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: "topplayers")
       
        statsRequest.httpMethod = "GET"
        statsRequest.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
       
        let statsTask = session.dataTask(with: statsRequest) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
            
            if let data = data{
                let result = self.parse(data: data)
            
                let statTypes = Mirror(reflecting: result[0].statistics)
                let stats = statTypes.children.map{ $0.value }
                let names = statTypes.children.map{ $0.label }
          
        
                
                for i in 0...stats.count-1{
                    if let intVal = stats[i] as? Int{
                        if intVal > 0{
                            self.playerStats.updateValue(intVal, forKey: names[i]!)
                            self.validKeys.append(names[i]!)
                        }
                    }else if let floatVal = stats[i] as? Float{
                        if floatVal > 0{
                            self.playerStats.updateValue(floatVal, forKey: names[i]!)
                            self.validKeys.append(names[i]!)
                        }
                    }
                }
                print(stats)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        statsTask.resume()
        
        var infoRequest = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/player/\(playerId)")! as URL,
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
        
        infoRequest.httpMethod = "GET"
        infoRequest.allHTTPHeaderFields = headers
       
        let infoTask = session.dataTask(with: infoRequest) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
            
            if let data = data{
                let results = self.parseInfo(data: data)
               
                if let dob = results[0].player.dateOfBirthTimestamp{
                    let birthday = NSDate(timeIntervalSince1970: Double(dob))
                    let today = NSDate(timeIntervalSinceNow: 0)
                    let difference = today.timeIntervalSince(birthday as Date)
                    
                    let age = Int(difference / 31556952)
                    self.playerDob = age
                }else{
                    self.playerDob = 0
                }
                if let tempHeight = results[0].player.height{
                    self.playerHeight = tempHeight
                } else{
                    self.playerHeight = 0
                }
                if let tempNum = results[0].player.shirtNumber{
                    self.playerNumber = tempNum
                } else{
                    self.playerNumber = 0
                }
                if let tempPos = results[0].player.position{
                    self.playerPos = tempPos
                } else{
                    self.playerPos = ""
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        infoTask.resume()
       
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return validKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topplayers", for: indexPath) as! PlayerCollectionViewCell
        var numString = ""
        if let num = self.playerStats[self.validKeys[indexPath.row]] as? Int{
            numString = "\(num)"
        }else if let num = self.playerStats[self.validKeys[indexPath.row]] as? Float{
            numString = "\(num)"
        }
        cell.configureText(text: ["", "\(self.validKeys[indexPath.row]): \(numString)"])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "playerHeader", for: indexPath) as! PlayerImageHeaderView
        headerView.configureText(text: [playerName, "Age: \(playerDob)", "Height: \(playerHeight) in", "#\(playerNumber)", playerPos])
        headerView.configureImage(image: self.image)
        return headerView
    }
  
    func parse(data: Data) -> [PlayerStatsResult] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(PlayerStatsResult.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func parseInfo(data: Data) -> [PlayerInfoResult] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(PlayerInfoResult.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
}

