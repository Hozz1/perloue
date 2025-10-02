import SwiftUI
import Combine


@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    //зависимости( в реальности можно прокидывать DI, пока создадим тут
    private let settings = AppSettings()
    private let api: APIClient
    private let auth: AuthService
    
    init(){
        let base = URL(string: "http://127.0.0.1:8000")!
        let client = APIClient(baseURL: base)
        
        self.api = client
        self.auth = AuthService(api: client)
        
        client.tokenProvider = { [weak self] in self?.settings.storedToken }
        
        
        
    }
    
    var isValid:Bool{
        password.count >= 6
    }
    
    func login() async -> Bool {
        guard isValid else{
            error = "password >= 6"
            return false
        }
        isLoading = true
        defer { isLoading = false}
        
        do {
            let resp = try await auth.login(username: username, password: password)
            
            let token = resp.access ?? resp.token
            guard let token else{
                self.error = "Sever doesn't returned the token"
                return false
            }
            
            settings.storedToken = token
            self.error = nil
            return true
        }catch let err as HTTPError{
            self.error = err.localizedDescription
            return false
        }catch{
            self.error = error.localizedDescription
            return false
        }
    }
    
}
