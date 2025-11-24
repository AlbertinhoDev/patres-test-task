import Foundation

final class DecoderService {}

extension DecoderService: DecoderServiceLogic {
    func decode<T>(data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
