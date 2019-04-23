import Foundation


var simpleJsonString = """
{
    "firstName" : "Ash",
    "lastName" : "Williams"
}
"""

struct SimpleModel {
    var firstName: String
    var lastName: String?
}



print("***** Convert the JSON string to a model object... The hard way *****")

//typealias Json = [String : Any]

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


if let simpleModel = convert(jsonString: simpleJsonString) {
    print(simpleModel)
}

