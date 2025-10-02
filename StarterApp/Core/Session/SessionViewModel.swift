import SwiftUI
import Combine

final class SessionViewModel: ObservableObject {
    @Published var isAuthorized: Bool = false //@Published → SwiftUI узнаёт: состояние изменилось → перерисовывает нужные экраны.
    private let settings = AppSettings()
    
    init() {
        if let token = settings.storedToken, !token.isEmpty {
            isAuthorized = true
        }else{
            isAuthorized = settings.isAuthorized
        }
    }
    
    func signIn(){
        isAuthorized = true
        settings.isAuthorized = true
    }
    
    func signOut(){
        isAuthorized = false
        settings.isAuthorized = false
        settings.storedToken = nil
    }
}
