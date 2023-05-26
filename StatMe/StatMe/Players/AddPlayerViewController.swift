
import UIKit

protocol AddPlayerViewDelegate: AnyObject {
    func nextView(_ button: UIBarButtonItem)
    
    func addItem(_ item: Player)
}

struct Search: Codable{
    let results: [SearchResult]
}

struct SearchResult: Codable{
    var entity: Player
    let type: String
}

struct Player: Codable{
    let name: String
    let id: Int
    let position: String?
    let team: Team?
    let dateOfBirthTimestamp: Int?
    let height: Int?
    let shirtNumber: Int?
    var teamCode: String?
    //source: https://stackoverflow.com/questions/54301886/what-is-the-simplest-way-to-instantiate-a-new-codable-object-in-swift
    init(name: String, id: Int, teamCode: String, position: String){
        self.name = name
        self.id = id
        self.teamCode = teamCode
        self.position = position
        self.height = 0
        self.shirtNumber = 0
        self.dateOfBirthTimestamp = 0
        self.team = nil
    }

}


class AddPlayerViewController: UITableViewController {
    weak var delegate: AddPlayerViewDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var items = [String]()
    var players = [Player]()
    var teams = [Team]()
    var term = String()
    
    let headers = [
        "X-RapidAPI-Key": "886867ab85msh526dafb1cba659cp141c9cjsnd6080b6fd6a2",
        "X-RapidAPI-Host": "americanfootballapi.p.rapidapi.com"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Players"
        
        print(teams)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search players"
        navigationItem.searchController = searchController
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "newPlayer")
        
    }
    
    func parse(data: Data) -> [Search] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Search.self, from: data)
            return [result]
        } catch{
            print("JSON Error: \(error)")
            return []
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newPlayer", for: indexPath)
        cell.textLabel?.text = "\(players[indexPath.row].name) (\(players[indexPath.row].position!) - \(players[indexPath.row].team!.nameCode!))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = players[indexPath.row]
        
        delegate?.addItem(selectedCell)
        
        navigationController?.popViewController(animated: true)
    }

    
}

extension AddPlayerViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.term = searchController.searchBar.text ?? ""
    }
}
extension AddPlayerViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchTerm = self.term.replacingOccurrences(of: " ", with: "+")
        //https://www.appsloveworld.com/swift/100/26/swift-getting-only-alphanumeric-characters-from-string
        let pattern = "[^A-Za-z0-9]+"
        searchTerm = searchTerm.replacingOccurrences(of: pattern, with: "")
        var request = URLRequest(url: URL(string: "https://americanfootballapi.p.rapidapi.com/api/american-football/search/\(searchTerm)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        var pResults = [Player]()
        let dataTask = session.dataTask(with: request) {data, response, error in
            if let error = error{
                print("Failed \(error.localizedDescription)")
            }else {
                print("Success")
            }
            
    
            if let data = data{
                let results = self.parse(data: data)
                if !results.isEmpty{
                    let rows = results[0].results
                    
                    for var player in rows{
                        if player.entity.team != nil{
                            player.entity.teamCode = player.entity.team!.nameCode
                            if player.type == "player"{
                                var tFlag = false
                                for i in self.teams{
                                    if i.team?.id == player.entity.team!.id || i.id == player.entity.team!.id{
                                        tFlag = true
                                    }
                                }
                                if !tFlag{
                                    break
                                }
                                var pFlag = false
                                for i in self.players{
                                    if i.id == player.entity.id{
                                        pFlag = true
                                        break
                                    }
                                }
                                if !pFlag{
                                    pResults.append(player.entity)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async{
                        self.players = pResults
                        self.tableView.reloadData()
                    }
                }
            }
        }
        dataTask.resume()
    }
}
