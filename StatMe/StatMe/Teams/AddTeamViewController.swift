
import UIKit

protocol AddTeamViewDelegate: AnyObject {
    func nextView(_ button: UIBarButtonItem)
    
    func addItem(_ item: Team)
}


class AddTeamViewController: UITableViewController {
    weak var delegate: AddTeamViewDelegate?
    
    var items = [String]()
    var teams = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Teams"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "newTeam")

        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newTeam", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row].team!.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = teams[indexPath.row]
        
        delegate?.addItem(selectedCell)
        
        navigationController?.popViewController(animated: true)
    }

    
}
