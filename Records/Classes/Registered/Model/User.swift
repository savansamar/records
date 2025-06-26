import Foundation


struct User:Codable {
    let name: String
    let email: String
    let dob: String
    let age: Int
    let department: String
    var gallery: [UserGallery]? = nil
}

