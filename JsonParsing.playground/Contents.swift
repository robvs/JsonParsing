import Foundation



//typealias Json = [String : Any]

struct SimpleModel {
    var firstName: String
    var lastName: String?
}

let simpleModel      = SimpleModel(firstName: "Bruce", lastName: "Campbell")
let simpleJsonObject = ["firstName" : "Ash",
                        "lastName" : "Williams"]



print("***** Convert the simple JSON object to a model object... The hard way *****\n")

func convert(json: Json) -> SimpleModel? {
    
    // Get values from the JSON object
    guard let firstName = json["firstName"] as? String else { return nil }
    let lastName = json["lastName"] as? String
    
    // Create the model
    return SimpleModel(firstName: firstName, lastName: lastName)
}


if let simpleModel = convert(json: simpleJsonObject) {
    print("   \(simpleModel)")
}



print("\n\n\n\n***** Convert the simple JSON object to a model object using Decodable *****\n")

extension SimpleModel: Decodable {}

func convertDecodable(json: Json) -> SimpleModel? {
    
    // Convert the JSON object to a Data object
    guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
        print("Error: Could not convert a JSON object to a Data object.")
        return nil
    }
    
    // Use a JSONDecoder to decode the JSON data into a model object.
    let decoder = JSONDecoder()
    do {
        let model = try decoder.decode(SimpleModel.self, from: jsonData)
        return model
    }
    catch {
        print("Json decode error: \(error.localizedDescription)")
        return nil
    }
}

if let model = convertDecodable(json: simpleJsonObject) {
    print("   \(model)")
}










print("\n\n\n\n***** Convert the simple model object to a JSON object... The hard way *****\n")

func convert(simpleModel: SimpleModel) -> Json? {
    
    // Assemblee the JSON object by hand.
    return ["firstName" : simpleModel.firstName,
            "lastName" : simpleModel.lastName as Any]
}

if let json = convert(simpleModel: simpleModel) {
    print("   \(json)")
}



print("\n\n\n\n***** Convert the simple model object to a JSON object using Encodable *****\n")

extension SimpleModel: Encodable {}

func convertEncodable(simpleModel: SimpleModel) -> Json? {
    
    // Use a JSONEncoder to convert the model object into a JSON data object.
    guard let jsonData = try? JSONEncoder().encode(simpleModel) else {
        print("Error: Could not convert a model object to a JSON Data object.")
        return nil
    }
    
    // Convert the JSON Data object to a JSON object.
    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
    return json as? Json
}

if let json = convertEncodable(simpleModel: simpleModel) {
    print("   \(json)")
}









print("\n\n\n\n***** Conversion functions using generics *****\n")


func convert<Model: Decodable>(json: Json) -> Model? {
    
    // Convert the JSON object to a Data object
    guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
        print("Error: Could not convert a JSON object to a Data object.")
        return nil
    }
    
    // Use a JSONDecoder to decode the JSON data into a model object.
    let decoder = JSONDecoder()
    do {
        let model = try decoder.decode(Model.self, from: jsonData)
        return model
    }
    catch {
        print("Json decode error: \(error.localizedDescription)")
        return nil
    }
}


func convert<Model: Encodable>(model: Model) -> Json? {
    
    // Use a JSONEncoder to convert the model object into a JSON data object.
    guard let jsonData = try? JSONEncoder().encode(model) else {
        print("Error: Could not convert a model object to a JSON Data object.")
        return nil
    }
    
    // Convert the JSON Data object to a JSON object.
    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
    return json as? Json
}


if let json = convert(model: simpleModel) {
    print("   \(json)")
}

if let model = convert(json: simpleJsonObject) {
    print("   \(model)")
}








print("\n\n\n\n***** Dealling with more complex models *****\n")

struct Address: Codable {
    var street: String
    var city: String
    var state: String
    var postalCode: String
}

struct ComplexModel: Codable {
    var firstName: String
    var lastName: String
    var phoneNumbers: [String]
    var address: Address
}


let address = Address(street: "1234 Main St.",
                      city: "Grand Rapids",
                      state: "MI",
                      postalCode: "49506")

let complexModel = ComplexModel(firstName: "Hannible",
                                lastName: "Smith",
                                phoneNumbers: ["616-555-1212", "616-555-2121"],
                                address: address)

if let json = convert(model: complexModel) {
    print("   \(json)")
    
    let jsonString = JsonUtil.toString(json: json)
    print("\n\(jsonString ?? "")")
}


let complexJson: Json = ["lastName": "Smith",
                         "phoneNumbers": ["616-555-1212", "616-555-2121"],
                         "firstName": "Hannible",
                         "address": ["city": "Grand Rapids",
                                     "postalCode": "49506",
                                     "state": "MI",
                                     "street": "1234 Main St."]]

if let model: ComplexModel = convert(json: complexJson) {
    print("\n   \(model)")
}









print("\n\n\n\n***** Custom property names *****\n")

let json: Json = ["first_name": "Ash",
                  "last_name": "Williams"]

struct Name: Codable {
    var firstName: String
    var lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

if let model: Name = convert(json: json) {
    print("   \(model)")
}








var simpleJsonString = """
{
"firstName" : "Ash",
"lastName" : "Williams"
}
"""



func convert(jsonString: String) -> SimpleModel? {
    
    // String to Data
    guard let jsonData = simpleJsonString.data(using: .utf8) else { return nil }
    
    // Data to Json
    let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
    guard let json = jsonObject as? Json else { return nil }
    
    // Get values
    guard let firstName = json["firstName"] as? String else { return nil }
    let lastName = json["lastName"] as? String
    
    // Create the model
    return SimpleModel(firstName: firstName, lastName: lastName)
}
