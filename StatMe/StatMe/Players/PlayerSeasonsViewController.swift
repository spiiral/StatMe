//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit

struct PlayerSeasonResult: Codable{
    var uniqueTournamentSeasons: [PlayerSeasons]
}

struct PlayerSeasons: Codable{
    var seasons: [Season]
}

class PlayerSeasonsViewController: UITableViewController {
    
    var playerId = Int()
    var seasons = [Season]()
    var playerName = String()
    var image = UIImage()
    
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Seasons"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "season")
        
        
        var request = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/player/\(playerId)/statistics/season")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
    
            if let data = data{
                let results = self.parse(data: data)
                var rows = results[0].uniqueTournamentSeasons[0].seasons
                if !rows.isEmpty{
                    rows[0].name = "2022/2023"
                    rows[0].year = "2022/2023"
                    self.seasons.append(rows[0])
                    if rows.count > 1{
                        self.seasons.append(rows[1])
                        var temp = [Season]()
                        if rows.count > 2{
                            for i in [2...rows.count-1]{
                                temp.append(contentsOf: rows[i])
                            }
                            temp.reverse()
                            self.seasons.append(contentsOf: temp)
                        }
                    }
                    
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
        dataTask.resume()
        
        var imgRequest = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/player/\(playerId)/image")! as URL,
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
        
        imgRequest.httpMethod = "GET"
        imgRequest.allHTTPHeaderFields = headers
        let imgTask = session.dataTask(with: imgRequest) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
            
            if let data = data{
                print(data)
                guard let image = UIImage(data: data) else{
                    fatalError("failed")
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        imgTask.resume()
        
        
    }
    
    func parse(data: Data) -> [PlayerSeasonResult]{
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(PlayerSeasonResult.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "season", for: indexPath)
        cell.textLabel?.text = seasons[indexPath.row].year
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let playerStatsViewController = PlayerStatsViewController(collectionViewLayout: layout)
        playerStatsViewController.season = seasons[indexPath.row].year
        playerStatsViewController.seasonId = seasons[indexPath.row].id
        playerStatsViewController.playerId = playerId
        playerStatsViewController.playerName = playerName
        playerStatsViewController.image = self.image
        navigationController?.pushViewController(playerStatsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
    
}

