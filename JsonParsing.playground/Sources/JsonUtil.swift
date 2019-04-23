import Foundation


/// Type def that represents a json dictionary
public typealias Json = [String : Any]


/// Utility functions for manipulating Json data.
public struct JsonUtil {
    
    /// The key applied to JSON data that is provided as an array of JSON instead of
    /// an object so that the array can be presented as Json, not [Json].
    static let arrayKey = "items"
    
    /// Convert the given model object into a JSON-based Data object.
    public static func toData<Model: Encodable>(model: Model) -> Data? {
        return try? JSONEncoder().encode(model)
    }
    
    /// Convert the given json object into a model object.
    public static func toModel<Model: Decodable>(json: Json) -> Model? {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            print("Error: Could not convert a JSON object to a Data object.")
            return nil
        }
        
        return toModel(jsonData: jsonData)
    }
    
    /// Convert the given JSON-based Data object into a model object.
    public static func toModel<Model: Decodable>(jsonData: Data) -> Model? {
        
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(Model.self, from: jsonData)
            return model
        }
        catch {
            var errorMessage = "Json decode error: "
            if let decodingError = error as? DecodingError {
                errorMessage += decodingError.detailedDescription
            }
            else {
                errorMessage += error.localizedDescription
            }
            
            if let json = toJson(data: jsonData), let jsonString = toString(json: json) {
                errorMessage += "\n" + jsonString
            }
            
            print(errorMessage)
            return nil
        }
    }
    
    /// Convert the given model object into a JSON string.
    public static func toString<Model: Encodable>(model: Model) -> String? {
        
        guard let jsonData = toData(model: model) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// Convert the given JSON object into the string equivalent.
    public static func toString(json: Json) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json,
                                                      options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    /// Convert the given model object into a JSON object.
    public static func toJson<Model: Encodable>(model: Model) -> Json? {
        
        guard let jsonData = toData(model: model) else { return nil }
        return toJson(data: jsonData)
    }
    
    /// Convert the given JSON-based Data object into a JSON object.
    public static func toJson(data: Data) -> Json? {
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json as? Json
    }
    
    /// Convert the given JSON string into a JSON object.
    public static func toJson(jsonString: String) -> Json? {
        
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        return toJson(data: jsonData)
    }
}


// MARK: - ModelToJsonDataConvertable

/// A protocol that, when applied to a model class that implements `Encodable`,
/// provides a method for converting the model into a JSON-based Data object.
public protocol ModelToJsonDataConvertable {}

public extension ModelToJsonDataConvertable where Self: Encodable {
    
    func toJsonData() -> Data {
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
        }
        catch {
            print("Error: Converting model to json data failed. This shouldn't happen.")
            return Data()
        }
    }
}


// MARK: - DecodingError extension

public extension DecodingError {
    
    var detailedDescription: String {
        
        switch self {
        case .dataCorrupted(let context):
            return "Data corrupted: \(context.debugDescription)"
        case .keyNotFound(let codingKey, let context):
            return "Key not found: \(context.debugDescription) - codingKey: \(codingKey.stringValue)"
        case .typeMismatch(let type, let context):
            return "Type mismatch: \(type) - \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            return "Value not found: \(type) - \(context.debugDescription)"
        @unknown default:
            print("Unhandled `DecodingError` type: \(self)")
            return "Unhandled DecodingError: \(self)"
        }
    }
}
