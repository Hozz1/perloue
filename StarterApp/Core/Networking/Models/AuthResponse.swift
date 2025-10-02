import Foundation

struct AuthResponse: Decodable {
    let access: String?
    let refresh: String?
    let token: String?
}
