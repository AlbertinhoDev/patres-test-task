import Foundation

struct UserPostEndpoint: Endpoint {
    let page: Int?
    var path: String
    var scheme: HTTPScheme = .https
    var host: String = "jsonplaceholder.typicode.com"
    var method: HTTPMethod = .get
    
    init(
        page: Int?
    ) {
        self.page = page
        self.path = "/users/\(page ?? 1)/posts"
    }
}

struct UserPhotoEndpoint: Endpoint {
    let id: Int?
    var path: String
    var scheme: HTTPScheme = .https
    var host: String = "picsum.photos"
    var method: HTTPMethod = .get
    
    init(
        id: Int?
    ) {
        self.id = id
        self.path = "/id/\(id ?? 1)/200/300"
    }
}
