//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit

struct SeasonResult: Codable{
    var tournamentSeasons: [Seasons]
}

struct Seasons: Codable{
    var seasons: [Season]
}

struct Season: Codable{
    var id: Int
    var name: String
    var year: String
    var team: Team?
}

class TeamSeasonsViewController: UITableViewController {
    
    var teamId = Int()
    var seasons = [Season]()
    var teamName = String()
    var nameCode = String()
    var image = UIImage()
    
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Seasons"
        print(self.teamId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "season")
        
        
        var request = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/team/\(teamId)/standings/seasons")! as URL,
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
                let rows = results[0].tournamentSeasons[1].seasons 
                self.seasons.append(results[0].tournamentSeasons[0].seasons[1])
                self.seasons[0].name = "2022/2023"
                self.seasons[0].year = "2022/2023"
                self.seasons.append(results[0].tournamentSeasons[1].seasons[0])
                var temp = [Season]()
                for i in 0...rows.count{
                    if i > 0 && i < rows.count - 1{
                        if rows[i].id == 23600 {
                            continue
                        }
                        temp.append(rows[i])
                    }
                }
                temp.reverse()
                self.seasons.append(contentsOf: temp)
                self.seasons.append(rows[rows.count-1])
            
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
        dataTask.resume()
        
        var imgRequest = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/team/\(teamId)/image")! as URL,
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
    
    func parse(data: Data) -> [SeasonResult]{
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(SeasonResult.self, from: data)
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
        let seasonStatsViewController = SeasonStatsViewController(collectionViewLayout: layout)
        seasonStatsViewController.season = seasons[indexPath.row].year
        seasonStatsViewController.seasonId = seasons[indexPath.row].id
        print("seasonid \(seasons[indexPath.row].id) \(teamId)")
        seasonStatsViewController.teamId = teamId
        seasonStatsViewController.teamName = teamName
        seasonStatsViewController.nameCode = nameCode
        seasonStatsViewController.image = image
        navigationController?.pushViewController(seasonStatsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
    
}

