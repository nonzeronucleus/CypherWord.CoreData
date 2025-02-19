extension Character: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(self))  // Encode Character as a String
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let firstCharacter = stringValue.first, stringValue.count == 1 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid character encoding")
        }
        self = firstCharacter  // Decode single-character string to Character
    }
}
