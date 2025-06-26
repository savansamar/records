import Foundation

@objc(RecordListWrapper)


class RecordListWrapper: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var users: [User]

    init(users: [User]) {
        self.users = users
    }

    func encode(with coder: NSCoder) {
        do {
            let encodedData = try JSONEncoder().encode(users)
            coder.encode(encodedData, forKey: "users")
        } catch {
            print("❌ Failed to encode users: \(error)")
        }
    }

    required init?(coder: NSCoder) {
        do {
            if let data = coder.decodeObject(forKey: "users") as? Data {
                self.users = try JSONDecoder().decode([User].self, from: data)
            } else {
                self.users = []
            }
        } catch {
            print("❌ Failed to decode users: \(error)")
            self.users = []
        }
    }
}

