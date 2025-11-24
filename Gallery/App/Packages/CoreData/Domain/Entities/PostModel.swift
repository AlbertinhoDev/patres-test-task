import Foundation

struct Post: Identifiable, Hashable {
    var id: Int
    var title: String
    var body: String
    var like: Bool
    var image: Data
}
