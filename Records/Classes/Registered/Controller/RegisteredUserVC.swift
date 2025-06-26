import UIKit
import PhotosUI

class RegisteredUserVC: UIViewController {

    // Props
    var existingUser: User?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userDOB: UITextField!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var userDepartment: UITextField!

    
    private let datePicker = UIDatePicker()
    private let departmentPicker = UIPickerView()

    let viewModel = UserViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
}



// MARK: - UI Setup & Configuration
extension RegisteredUserVC {

    func onViewDidLoad() {
        
        if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            layout.scrollDirection = .vertical
        }
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        setupDOBField()
        setupDepartmentPicker()
        handleParams()
        [userName, userEmail, userDOB, userDepartment].forEach {
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }

  
    private func setupDOBField() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        userDOB.inputView = datePicker
        userDOB.inputAccessoryView = createToolbar()
    }

    private func setupDepartmentPicker() {
        departmentPicker.dataSource = self
        departmentPicker.delegate = self

        userDepartment.inputView = departmentPicker
        userDepartment.inputAccessoryView = createToolbar()
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDateSelection))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(confirmDateSelection))

        toolbar.setItems([cancel, flexible, done], animated: false)
        return toolbar
    }

    @objc private func cancelDateSelection() {
        view.endEditing(true)
    }

    @objc private func confirmDateSelection() {
        if userDOB.isFirstResponder {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            userDOB.text = formatter.string(from: datePicker.date)
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

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isValid = viewModel.isFormValid(
            name: userName.text ?? "",
            email: userEmail.text ?? "",
            dob: userDOB.text ?? "",
            department: userDepartment.text ?? ""
        )

        
    }

    func handleParams() {
        if let user = existingUser {
            userName.text = user.name
            userEmail.text = user.email
            userDOB.text = user.dob
            userAge.text = "\(user.age)"
            userDepartment.text = user.department
            viewModel.userGalleryArray = user.gallery ?? []
            viewModel.userGalleryArray.insert(UserGallery(url: "", showAdd: true, fileName: ""), at: 0)
            
        } else {
            viewModel.loadGalleryItems()
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
        guard
            let name = userName.text, !name.isEmpty,
            let email = userEmail.text, !email.isEmpty,
            let dobString = userDOB.text, !dobString.isEmpty,
            let department = userDepartment.text, !department.isEmpty
        else {
            print("Form incomplete")
            return
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        guard let dobDate = formatter.date(from: dobString) else {
            print("⚠️ Invalid DOB format")
            return
        }

        let age = viewModel.calculateAge(from: dobDate)
        let validGallery = viewModel.userGalleryArray.filter { !$0.url.isEmpty && !$0.showAdd }
        let newUser = User(
            name: name,
            email: email,
            dob: dobString,
            age: age,
            department: department,
            gallery: validGallery
        )

        if let index = viewModel.indexOfUser(matching: email) {
            viewModel.updateUser(at: index, with: newUser)
        } else {
            viewModel.addUser(name: name, email: email, dob: dobString, age: age, department: department, gallery: validGallery)
        }

        viewModel.loadGalleryItems()
        navigationController?.popViewController(animated: true)
    }
}

