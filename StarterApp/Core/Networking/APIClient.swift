import Foundation

final class APIClient {
    let baseURL: URL
    var tokenProvider: () -> String? = {nil}
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        expecting: T.Type,
        body: Encodable? = nil
    ) async throws -> T {
        var req = URLRequest(url: endpoint.url(baseURL: baseURL))
        req.httpMethod = endpoint.method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = tokenProvider() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            req.httpBody = try JSONEncoder().encode(AnyEncodable(body))
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let(data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else {
                throw HTTPError.transport(URLError(.badServerResponse))      }
            
            switch http.statusCode {
            case 200..<300:
                do {
                    return try decoder.decode(T.self, from: data)
                }catch{
                    throw HTTPError.decoding(error)
                }
                
            default :
                let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["detail"] as? String
                throw HTTPError.server(status: http.statusCode, message: message)
            }
        }catch let e as HTTPError{
            throw e
        }catch{
            throw HTTPError.transport(error)
        }
    }
}

private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    init(_ encodable: Encodable){
        self.encodeFunc = encodable.encode
    }
    func encode(to encoder: Encoder) throws { try encodeFunc(encoder) }
    
}
