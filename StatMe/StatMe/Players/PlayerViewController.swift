//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit
import CoreData

class PlayerViewController: UITableViewController, AddPlayerViewDelegate {
    
    var players = [Player]()
    var teams = [Team]()
    
    var playerModels = [PlayerModel]()
    
    var managedObjectContext: NSManagedObjectContext!
    
    @objc func nextView(_ button: UIBarButtonItem) {
        let addPlayerViewController = AddPlayerViewController()
        addPlayerViewController.delegate = self
        addPlayerViewController.teams = self.teams
        navigationController?.pushViewController(addPlayerViewController, animated: true)
    }
    
    func addItem(_ item: Player){
        var flag = false;
        for i in players{
            if item.id == i.id{
                flag = true;
                break;
            }
        }
        if(!flag){
            players.append(item)
            let playerModel = PlayerModel(context: self.managedObjectContext)
            playerModel.playerId = Int64(item.id)
            playerModel.playerName = item.name
            playerModel.teamCode = item.team!.nameCode
            playerModel.playerPos = item.position!
            do{
                try self.managedObjectContext.save()
            }catch{
                fatalError("error \(error)")
            }
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Players"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "player")
        
        let fetchRequest = NSFetchRequest<PlayerModel>()
        let entity = PlayerModel.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(
            key: "playerName",
            ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            playerModels = try managedObjectContext.fetch(fetchRequest)
        }catch{
            fatalError("error")
        }
        
        for i in playerModels{
            let player = Player(name: i.playerName!, id: Int(i.playerId), teamCode: i.teamCode!, position: i.playerPos!)
            self.players.append(player)
        }
        
        tableView.reloadData()
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextView( _:)))
        navigationItem.rightBarButtonItem = button
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        cell.textLabel?.text = "\(players[indexPath.row].name) (\(players[indexPath.row].position!) - \(players[indexPath.row].teamCode!))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(players[indexPath.row].name)
        print(players[indexPath.row].id)
        let playerSeasonsViewController = PlayerSeasonsViewController()
        playerSeasonsViewController.playerId = players[indexPath.row].id
        playerSeasonsViewController.playerName = players[indexPath.row].name

        navigationController?.pushViewController(playerSeasonsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
    
}

