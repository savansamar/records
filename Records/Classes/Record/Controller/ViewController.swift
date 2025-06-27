
import UIKit

class ViewController: UIViewController {
    
    let viewModel = UserViewModel.shared
    var selectedUser: User?
    
    // MARK: - Outlets
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var recordsTable: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    
    // MARK: - Initialization
    @IBAction func onAddUser(_ sender: UIBarButtonItem) {
        selectedUser = nil
        naviagteToUser()
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadUsersFromCoreData()
        recordsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddUser" {
            if let destinationVC = segue.destination as? RegisteredUserVC {
                destinationVC.existingUser = selectedUser
            }
        }
    }

}

// MARK: - Initialization

extension ViewController {
    
    private func initialization() {
        
        // Load records from DB
        UserViewModel.shared.loadUsersFromCoreData()
        
        recordsTable.delegate = self
        recordsTable.dataSource = self
        
        search.searchBarStyle = .minimal
        search.backgroundImage = UIImage()
        search.backgroundColor = .clear
        search.barTintColor = .clear
    }
    
    private func naviagteToUser() {
        performSegue(withIdentifier: "AddUser", sender: self)
    }
}


// MARK: - RecordsTable

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let department = viewModel.sortedDepartments[indexPath.section]
        let usersInSection = viewModel.isSearching
            ? viewModel.filteredUsersByDepartment[department]
            : viewModel.usersByDepartment[department]

        selectedUser = usersInSection?[indexPath.row]
         performSegue(withIdentifier: "AddUser", sender: self)
      
    }
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return viewModel.sortedDepartments.count
     }

    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let department = viewModel.sortedDepartments[section]
        let usersInSection = viewModel.isSearching
                 ? viewModel.filteredUsersByDepartment[department]
                 : viewModel.usersByDepartment[department]
             
         return usersInSection?.count ?? 0
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let department = viewModel.sortedDepartments[indexPath.section]
         let usersInSection = viewModel.isSearching
               ? viewModel.filteredUsersByDepartment[department]
               : viewModel.usersByDepartment[department]
           
        
             guard let user = usersInSection?[indexPath.row] else {
                 return UITableViewCell() // return empty cell if user is nil
             }
             
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsCell", for: indexPath) as? RecordCell else {
                 fatalError("❌ Could not dequeue RecordCell with identifier 'RecordsCell'")
             }
            cell.configure(with: user)
             return cell
     }
    

     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return viewModel.sortedDepartments[section]
     }
     
     
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let department = viewModel.sortedDepartments[indexPath.section]
            let usersInSection = viewModel.isSearching
                     ? viewModel.filteredUsersByDepartment[department]
                     : viewModel.usersByDepartment[department]
                 
            guard let user = usersInSection?[indexPath.row],
                let index = viewModel.indexOfUser(matching: user.email) else {
                    return
            }
            viewModel.deleteUser(at: index)
            recordsTable.reloadData()
            }
    }
     
     
     func tableView(_ tableView: UITableView,titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
         return "Remove"
     }
    
}


// MARK: - Search

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchUsers(with: searchText)
        recordsTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.searchUsers(with: "")
        recordsTable.reloadData()
    }
}
