import UIKit
import PhotosUI

class RegisteredUserVC: UIViewController {

    // Props
    var existingUser: User?
    let viewModel = UserViewModel.shared
    
    // MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userDOB: UITextField!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var userDepartment: UITextField!
    @IBOutlet weak var submitStyle: UIButton!
    
    private let datePicker = UIDatePicker()
    private let departmentPicker = UIPickerView()
    
    // MARK: - Actions
    @IBAction func onSubmit(_ sender: Any) {
        onSubmit()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
}



// MARK: - UI Setup & Configuration
extension RegisteredUserVC {

    private func onViewDidLoad() {
        handleParams()
        setupUI()
        onTextFieldChange()
    }
    
    private func setupUI(){
        setupCollectionView()
        setupDatePicker()
        setupDepartmentPicker()
        setupSubmitButton()
    }
    
    private func setupCollectionView() {
        if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            layout.scrollDirection = .vertical
        }

        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
    
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        userDOB.inputView = datePicker
        userDOB.inputAccessoryView =  InputToolbarBuilder.makeToolbar(
            target: self,
            cancelAction: #selector(cancelDateSelection),
            doneAction: #selector(confirmDateSelection)
        )
    }
    
    private func setupDepartmentPicker() {
        departmentPicker.dataSource = self
        departmentPicker.delegate = self
        
        userDepartment.inputView = departmentPicker
        userDepartment.inputAccessoryView =  InputToolbarBuilder.makeToolbar(
            target: self,
            cancelAction: #selector(cancelDateSelection),
            doneAction: #selector(confirmDateSelection)
        )
    }
    
    private func setupSubmitButton() {
        guard existingUser == nil else { return }
        submitStyle.isEnabled = false
        submitStyle.alpha = 0.5
        submitStyle.layer.cornerRadius = 8
        submitStyle.clipsToBounds = true
        
        submitStyle.backgroundColor = UIColor(
            red: 255 / 255,
            green: 140 / 255,
            blue: 0 / 255,
            alpha: 1.0
        )
        
        submitStyle.setTitleColor(.white, for: .normal)
    }
    
    
    private func handleParams() {
        if let user = existingUser {
            userName.text = user.name
            userEmail.text = user.email
            userDOB.text = user.dob
            userAge.text = "\(user.age)"
            userDepartment.text = user.department
            viewModel.userGalleryArray = user.gallery ?? []
            viewModel.userGalleryArray.insert(UserGallery(url: "", showAdd: true,fileName: ""), at: 0)
            
            galleryCollectionView.reloadData()

            submitStyle.isEnabled = true
            submitStyle.alpha = 1.0
        }else{
            viewModel.loadGalleryItems()
        }
    }
    
    private func onTextFieldChange(){
        [userName, userEmail, userDOB, userDepartment].forEach {
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
       

   func showImagePicker() {
        var config = PHPickerConfiguration()
            config.selectionLimit = 5
            config.filter = .images

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            DispatchQueue.main.async {
                self.present(picker, animated: true, completion: nil)
            }
    }

    func onSubmit() {
        guard let user = extractUserFromForm() else { return }
        saveUser(user)
        viewModel.loadGalleryItems()
        navigationController?.popViewController(animated: true)
    }
    
    private func extractUserFromForm() -> User? {
        guard
            let name = userName.text, !name.isEmpty,
            let email = userEmail.text, !email.isEmpty,
            let dobString = userDOB.text, !dobString.isEmpty,
            let department = userDepartment.text, !department.isEmpty
        else {
            return nil
        }
        
        guard let dobDate = DateFormatter.appMedium.date(from: dobString) else {
            return nil
        }
        
        let age = viewModel.calculateAge(from: dobDate)
        let validGallery = viewModel.userGalleryArray.filter {
            !$0.url.isEmpty && !$0.showAdd
        }
        
        // Construct User model
        return User(
            name: name,
            email: email,
            dob: dobString,
            age: age,
            department: department,
            gallery: validGallery
        )
    }
    
    private func saveUser(_ user: User) {
        if let existing = existingUser,
           let index = viewModel.indexOfUser(matching: existing.email) {
            viewModel.updateUser(at: index, with: user)
        } else {
            viewModel.addUser(
                name: user.name,
                email: user.email,
                dob: user.dob,
                age: user.age,
                department: user.department,
                gallery: user.gallery ?? []
            )
        }
    }
}



// MARK: - Obj-C Selectors
extension RegisteredUserVC {

    @objc func cancelDateSelection() {
        view.endEditing(true)
    }

    @objc func confirmDateSelection() {
        if userDOB.isFirstResponder {
            userDOB.text = DateFormatter.appMedium.string(from: datePicker.date)
            textFieldDidChange(userDOB)

            let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date()).year ?? 0
            userAge.text = "\(age)"

        } else if userDepartment.isFirstResponder {
            let selectedRow = departmentPicker.selectedRow(inComponent: 0)
            userDepartment.text = viewModel.departments[selectedRow]
            textFieldDidChange(userDepartment)
        }

        view.endEditing(true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let isValid = viewModel.isFormValid(
            name: userName.text ?? "",
            email: userEmail.text ?? "",
            dob: userDOB.text ?? "",
            department: userDepartment.text ?? ""
        )
        submitStyle.isEnabled = isValid
        submitStyle.alpha = isValid ? 1.0 : 0.5
    }
}

