//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit
import CoreData

class TeamViewController: UITableViewController, AddTeamViewDelegate {
    
    var allTeams = [Team]()
    var teams = [TeamId]()
    
    var teamModels = [TeamModel]()
     
    var managedObjectContext: NSManagedObjectContext!
    
    
    @objc func nextView(_ button: UIBarButtonItem) {
        let addTeamViewController = AddTeamViewController()
        addTeamViewController.delegate = self
        addTeamViewController.teams = self.allTeams
        navigationController?.pushViewController(addTeamViewController, animated: true)
    }
    
    func addItem(_ item: Team){
        var flag = false;
        for i in teams{
            if item.team!.id == i.id{
                flag = true
                break
            }
        }
        if(!flag){
            teams.append(item.team!)
            let teamModel = TeamModel(context: self.managedObjectContext)
            teamModel.teamId = Int64(item.team!.id)
            teamModel.teamName = item.team!.name
            teamModel.teamCode = item.team!.nameCode
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
        self.title = "Teams"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "team")
        
        let fetchRequest = NSFetchRequest<TeamModel>()
        let entity = TeamModel.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(
            key: "teamName",
            ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            teamModels = try managedObjectContext.fetch(fetchRequest)
        }catch{
            fatalError("error")
        }
        
        for i in teamModels{
            let team = TeamId(name: i.teamName!, id: Int(i.teamId), nameCode: i.teamCode!)
            self.teams.append(team)
        }
        
        tableView.reloadData()
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nextView( _:)))
        navigationItem.rightBarButtonItem = button
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "team", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamSeasonsViewController = TeamSeasonsViewController()
        teamSeasonsViewController.teamId = teams[indexPath.row].id
        teamSeasonsViewController.teamName = teams[indexPath.row].name
        teamSeasonsViewController.nameCode = teams[indexPath.row].nameCode
        

        navigationController?.pushViewController(teamSeasonsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

