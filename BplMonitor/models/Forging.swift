import UIKit

class Forging: NSObject {
    public var fees: String = ""
    public var rewards: String = ""
    public var forged: String = ""
    
     public static func fromJson(objectJson : NSDictionary) -> Forging {
        let forging = Forging()
        
        if let fees = objectJson.object(forKey: "fees") as? String {
            forging.fees = fees
        }
        
        if let rewards = objectJson.object(forKey: "rewards") as? String {
            forging.rewards = rewards
        }
        
        if let forged = objectJson.object(forKey: "forged") as? String {
            forging.forged = forged
        }
        
        return forging
    }
}

