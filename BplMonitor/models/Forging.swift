import UIKit

class Forging: NSObject {
    public var fees: Int64 = 0
    public var rewards: Int64 = 0
    public var forged: Int64 = 0
    
    public static func fromJson(objectJson : NSDictionary) -> Forging {
        let forging = Forging()
        
        if let fees = objectJson.object(forKey: "fees") as? Int64 {
            forging.fees = fees
        }
        
        if let rewards = objectJson.object(forKey: "rewards") as? Int64 {
            forging.rewards = rewards
        }
        
        if let forged = objectJson.object(forKey: "forged") as? Int64 {
            forging.forged = forged
        }
        return forging
    }
}

