//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit

struct TopPlayersResult: Codable{
    let topPlayers: TopPlayers
}

struct TopPlayers: Codable{
    let defensiveInterceptions: [StatType]
    let defensiveSacks: [StatType]
    let defensiveTotalTackles: [StatType]
    
    let kickingFgMade: [StatType]
    
    let passingCompletionPercentage: [StatType]
    let passingTouchdowns: [StatType]
    
    let receivingTouchdowns: [StatType]
    let receivingYardsPerReception: [StatType]
    
    let rushingTouchdowns: [StatType]
    let rushingYardsPerAttempt: [StatType]
}

struct StatType: Codable{
    let playedEnough: Bool
    let player: Player
    let statistics: Statistics
}

struct Statistics: Codable{
    let receivingTouchdowns: Int?
    let receivingYardsPerReception: Float?
    
    let rushingTouchdowns: Int?
    let rushingYardsPerAttempt: Float?
    
    let passingCompletionPercentage: Float?
    let passingTouchdowns: Int?
    
    
    let kickingFgMade: Int?
    let kickingFgAttempts: Int?
    
    let defensiveInterceptions: Int?
    let defensiveSacks: Float?
    let defensiveTotalTackles: Float?

    
    let passingCompletions: Int?
    let appearances: Int
}



struct SeasonStatsResult: Codable{
    let standings: [GroupStandings]
}

struct GroupStandings: Codable{
    let id: Int
    let name: String
    let rows: [Team]
}

class SeasonStatsViewController: UICollectionViewController {
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]
    var image = UIImage()
    var season = String()
    var seasonId = Int()
    var teamId = Int()
    var teamName = String()
    var nameCode = String()
    var sIndices = [Int()]
    var tIndices = [Int()]
    
    var divLabel = String()
    var confLabel = String()
    var totLabel = String()
    var recordLabel = String()
    
    let teamImageView = UIImageView()
  
    let headerContainer = UIView()
    
    var playerDStats = [StatType]()
    var playerRecStats = [StatType]()
    var playerRushStats = [StatType]()
    var playerPassStats = [StatType]()
    var playerKStats = [StatType]()
    var playerStats = [[StatType]]()
    
    var playerImages = [[UIImage]]()
    
    let session = URLSession.shared
    
    override init(collectionViewLayout: UICollectionViewLayout){
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = season
        //view.backgroundColor = .white
        let year = String(season[season.index(season.startIndex, offsetBy: 0)...season.index(season.startIndex, offsetBy: 3)])
        let intYear = Int(year)
        
        
        collectionView.register(TeamImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "infoHeader")
        collectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: "topPlayers")
        collectionView.register(PlayerCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "statsHeader")
        
    
        
        
        var statsRequest = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/tournament/9464/season/\(seasonId)/standings/total")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
        
        statsRequest.httpMethod = "GET"
        statsRequest.allHTTPHeaderFields = headers
        let statsTask = session.dataTask(with: statsRequest) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
            
            if let data = data{
                let results = self.parse(data: data)
                let standings = results[0].standings
                var sIndex = 0
                self.sIndices = [Int]()
                self.tIndices = [Int]()
                for sGroup in standings{
                    var tIndex = 0
                    for row in sGroup.rows{
                        if self.teamId ==  row.team!.id{
                            self.sIndices.append(sIndex)
                            self.tIndices.append(tIndex)
                        }
                        tIndex += 1
                    }
                    sIndex += 1
                }
                for i in 0...self.sIndices.count-1{
                    if standings[self.sIndices[i]].rows.count == 4 || standings[self.sIndices[i]].rows.count == 3{
                        var division = standings[self.sIndices[i]].name.replacingOccurrences(of: "AMERICAN", with: "AFC")
                        division = division.replacingOccurrences(of: "NATIONAL", with: "NFC")
                        let pos = standings[self.sIndices[i]].rows[self.tIndices[i]].position!
                        self.divLabel = "\(pos) \(division)"
                        print("\(pos) \(division)")
                    }
                    if standings[self.sIndices[i]].rows.count == 16 || standings[self.sIndices[i]].rows.count == 15{
                        var conference = standings[self.sIndices[i]].name.replacingOccurrences(of: "AMERICAN", with: "AFC")
                        conference = conference.replacingOccurrences(of: "NATIONAL", with: "NFC")
                        let pos = standings[self.sIndices[i]].rows[self.tIndices[i]].position!
                        self.confLabel = "\(pos) \(conference)"
                        if(intYear == 2016 || intYear == 2017){
                            self.recordLabel = "\(standings[self.sIndices[i]].rows[self.tIndices[i]].wins!) - \(standings[self.sIndices[i]].rows[self.tIndices[i]].losses!)"
                        }
                        print("\(pos) \(conference)")
                    }
                    if standings[self.sIndices[i]].rows.count == 32 || standings[self.sIndices[i]].rows.count == 31{
                        var total = standings[self.sIndices[i]].name.replacingOccurrences(of: "AMERICAN", with: "AFC")
                        total = total.replacingOccurrences(of: "NATIONAL", with: "NFC")
                        let pos = self.tIndices[i]+1
                        self.totLabel = "\(pos) \(total)"
                        print("\(pos) \(total)")
                        self.recordLabel = "\(standings[self.sIndices[i]].rows[self.tIndices[i]].wins!) - \(standings[self.sIndices[i]].rows[self.tIndices[i]].losses!)"
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
        statsTask.resume()
        
      
        
        if intYear! >= 2016{
            var topRequest = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/team/\(teamId)/tournament/9464/season/\(seasonId)/best-players/regularSeason")! as URL,
                                        cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
            
            topRequest.httpMethod = "GET"
            topRequest.allHTTPHeaderFields = headers
            let topTask = session.dataTask(with: topRequest) {data, response, error in
                if let error = error{
                    print("Failed \(error.localizedDescription)")
                }else {
                    print("Success yuh")
                }
                
                
                if let data = data{
                    let results = self.parseTop(data: data)
                    let topPlayers = results[0].topPlayers
                    
                    
                    self.playerRecStats.append(topPlayers.receivingTouchdowns[0])
                    self.playerRecStats.append(topPlayers.receivingYardsPerReception[0])
                    
                    self.playerRushStats.append(topPlayers.rushingTouchdowns[0])
                    self.playerRushStats.append(topPlayers.rushingYardsPerAttempt[0])
                    
                    self.playerKStats.append(topPlayers.kickingFgMade[0])
                    
                    self.playerPassStats.append(topPlayers.passingCompletionPercentage[0])
                    self.playerPassStats.append(topPlayers.passingTouchdowns[0])
                    
                    self.playerDStats.append(topPlayers.defensiveInterceptions[0])
                    self.playerDStats.append(topPlayers.defensiveSacks[0])
                    self.playerDStats.append(topPlayers.defensiveTotalTackles[0])
                    
                    self.playerStats = [self.playerRecStats, self.playerRushStats, self.playerPassStats, self.playerKStats, self.playerDStats]
                    
                    
                
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
            }
            topTask.resume()
            
        }
    }
    
    func parse(data: Data) -> [SeasonStatsResult] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(SeasonStatsResult.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func parseTop(data: Data) -> [TopPlayersResult] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(TopPlayersResult.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return playerStats.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            return playerStats[section-1].count
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topPlayers", for: indexPath) as! PlayerCollectionViewCell
        let cItem = playerStats[indexPath.section-1][indexPath.row]
        let statTypes = Mirror(reflecting: cItem.statistics)
        let names = statTypes.children.compactMap{ $0.label }
        let stats = statTypes.children.compactMap{ $0.value }
        
        if(indexPath.section == 0){
            return cell
        }else{
            var numString = ""
            if let num = stats[2*indexPath.section-1 + indexPath.row-1] as? Int{
                numString = "\(num)"
            }else if let num = stats[2*indexPath.section-1 + indexPath.row-1] as? Float{
                numString = "\(num)"
            }

            cell.configureText(text: ["\(names[2*indexPath.section-1 + indexPath.row-1])", "\(cItem.player.name) (\(cItem.player.position!)) - \(numString)"])
            //cell.configureImage(playerId: cItem.player.id, session: self.session)
        }
       
       
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        if(indexPath.section == 0){
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "infoHeader", for: indexPath) as! TeamImageHeaderView
            headerView.configureImage(image: self.image)
            let nameLabel = "\(teamName) [\(nameCode)]"
            let headerText = [nameLabel, recordLabel, confLabel, divLabel, totLabel]
            print(headerText)
            headerView.configureText(text: headerText)

            return headerView
        }
        else{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "statsHeader", for: indexPath) as! PlayerCollectionHeaderView
            if(indexPath.section == 1){
                headerView.configureText(text: "Recieving")
            }
            else if(indexPath.section == 2){
                headerView.configureText(text: "Rushing")
            }
            else if(indexPath.section == 3){
                headerView.configureText(text: "Passing")
            }
            else if(indexPath.section == 4){
                headerView.configureText(text: "Kicking")
            }
            else if(indexPath.section == 5){
                headerView.configureText(text: "Defense")
            }
            return headerView
        }
        
     
            
    }
    

}

