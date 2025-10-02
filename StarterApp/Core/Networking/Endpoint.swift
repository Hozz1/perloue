import Foundation

struct Endpoint {
    var path: String
    var method: String = "GET"
    var query: [URLQueryItem] = []
    
    func url(baseURL: URL) -> URL {
        var comp = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if !query.isEmpty {
            comp.queryItems = query
        }
        return comp.url!
    }
}
