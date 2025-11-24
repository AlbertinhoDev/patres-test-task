import Foundation

protocol Endpoint {
    var scheme: HTTPScheme { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    private var url: URL {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        
        guard let url = components.url else {
            fatalError("Invalid URL: \(scheme.rawValue)://\(host)\(path)")
        }

        return url
    }
    
    func makeRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
