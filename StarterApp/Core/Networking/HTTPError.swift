import Foundation

enum HTTPError: LocalizedError {
    case invalidURL
    case transport(Error)
    case server(status: Int, message: String?)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self{
        case .invalidURL: return "Wrong server url"
        case .transport(let e): return "Network error: \(e.localizedDescription)"
        case .server(let status, let message):
            return message ?? "Server returned code \(status)"
        case .decoding: return "Error reading server answer"
        }
    }
    
}
