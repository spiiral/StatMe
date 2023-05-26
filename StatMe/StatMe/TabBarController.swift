//
//  ViewController.swift
//  Foog
//
//  Created by spiiral on 4/28/23.
//

import UIKit
import CoreData

struct Result: Codable{
    let standings: [Standings]
}

struct Standings: Codable{
    let rows: [Team]
}
struct Team: Codable{
   
    let draws: Int?
    let wins: Int?
    let losses: Int?
    let percentage: Float?
    let position: Int?
    let id: Int?
    let nameCode: String?
    let team: TeamId?
  
}

extension Array where Element == Team{
    func sortTeams() -> [Team]{
        return self.sorted {$0.team!.name < $1.team!.name}
    }
}

struct TeamId: Codable{
    var id: Int
    var name: String
    var nameCode: String
    
    //source: https://stackoverflow.com/questions/54301886/what-is-the-simplest-way-to-instantiate-a-new-codable-object-in-swift
    init(name: String, id: Int, nameCode: String){
        self.name = name
        self.id = id
        self.nameCode = nameCode
    }
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var teams = [Team]()
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]
    
    
    
    var managedObjectContext: NSManagedObjectContext!
    
    let playerTab = PlayerViewController()
    let teamTab = TeamViewController()

    var loadingLabel = UILabel()

    var request = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/tournament/9464/season/46786/standings/total")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        loadingLabel = UILabel()
        loadingLabel.text = "Loading teams..."
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.isUserInteractionEnabled = false
        view.addSubview(loadingLabel)
        //source for adding constraints programatically: https://stackoverflow.com/questions/26180822/how-to-add-constraints-programmatically-using-swift
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
        
        UIView.animate(withDuration: 1.0, animations: {
            self.loadingLabel.alpha = 0.0
        }) {finished in
            self.view.isUserInteractionEnabled = true
        }
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
            print(applicationDocumentsDirectory)
    
            if let data = data{
                let results = self.parse(data: data)
                let rows = results[0].standings[10].rows
                for team in rows{
                    self.teams.append(team)
                }
                self.teams = self.teams.sortTeams()
                self.playerTab.managedObjectContext = self.managedObjectContext
                self.playerTab.teams = self.teams
                self.teamTab.managedObjectContext = self.managedObjectContext
                self.teamTab.allTeams = self.teams
            }
        }
        dataTask.resume()
    }
    
    
    func parse(data: Data) -> [Result] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Result.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        //adding views to tab bar programatically: https://stackoverflow.com/questions/26850411/how-add-tabs-programmatically-in-uitabbarcontroller-with-swift
        let homeTab = HomeViewController()
        let homeItem = UITabBarItem(title: "Home", image: UIImage(named: "home.png"), selectedImage: UIImage(named: "home.png"))
        homeTab.tabBarItem = homeItem
        
        let playerItem = UITabBarItem(title: "Players", image: UIImage(named: "userW.png"), selectedImage: UIImage(named: "userW.png"))
        self.playerTab.tabBarItem = playerItem
        
        let teamItem = UITabBarItem(title: "Teams", image: UIImage(named: "team.png"), selectedImage: UIImage(named: "team.png"))
        self.teamTab.tabBarItem = teamItem
        
        let teamNav = UINavigationController(rootViewController: self.teamTab)
        let playerNav = UINavigationController(rootViewController: self.playerTab)
        
        
        self.viewControllers = [homeTab, playerNav, teamNav]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        
    }


}

