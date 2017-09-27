import UIKit

class Status: NSObject {
    public var blocks: Int64 = 0
    public var height: Int64 = 0
    
    public static func fromJson(objectJson : NSDictionary) -> Status {
        let status = Status()
        
        if let blocks = objectJson.object(forKey: "blocksCount") as? Int64 {
            status.blocks = blocks
        }
        
        if let height = objectJson.object(forKey: "height") as? Int64 {
            status.height = height
        }

        return status
    }
}
