import Foundation

protocol DecoderServiceLogic {
    func decode<T: Decodable>(data: Data) throws -> T
}
