import Foundation


final class AppSettings {
    private let defaults = UserDefaults.standard
    private enum Keys {
        static let isAuthorized = "isAuthorized"
        static let storedToken = "storedToken"
    }
    
    var isAuthorized: Bool {
        get { defaults.bool(forKey: Keys.isAuthorized) }
        set { defaults.set(newValue, forKey: Keys.isAuthorized) }
    }
    
    var storedToken: String? {
        get { defaults.string(forKey: Keys.storedToken) }
        set {defaults.set(newValue, forKey: Keys.storedToken)}
    }
}
