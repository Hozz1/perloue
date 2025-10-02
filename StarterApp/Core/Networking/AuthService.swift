import Foundation

struct LoginPayLoad: Encodable {
    let username: String
    let password: String
}

final class AuthService {
    private let api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func login(username: String, password: String) async throws -> AuthResponse {
        let ep = Endpoint(path: "/api/token/", method: "POST")
        let payload = LoginPayLoad(username: username, password: password)
        return try await api.request(ep, expecting: AuthResponse.self, body: payload)
    }
}
