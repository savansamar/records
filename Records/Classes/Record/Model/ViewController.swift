
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var recordsTable: UITableView!
    
    
    // MARK: - Initialization
    @IBAction func onAddUser(_ sender: UIBarButtonItem) {
        naviagteToUser()
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddUser" {
            if let destinationVC = segue.destination as? RegisteredUserVC {

            }
        }
    }


}

// MARK: - Initialization

extension ViewController {
    
    private func initialization() {
        
        //load all records from DB
        UserViewModel.shared.loadUsersFromCoreData()
        
        recordsTable.delegate = self
        recordsTable.dataSource = self
    }
    
    private func naviagteToUser() {
        performSegue(withIdentifier: "AddUser", sender: self)
    }
}


// MARK: - RecordsTable

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordsTable.dequeueReusableCell(withIdentifier: "RecordsCell", for: indexPath) as! RecordCell
        return cell
    }
}
