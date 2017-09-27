import UIKit

class PeerVersion: NSObject {
    public var version: String = ""
    public var build: String = ""

    public static func fromJson(objectJson : NSDictionary) -> PeerVersion {
        let peerVersion = PeerVersion()
        
        if let version = objectJson.object(forKey: "version") as? String {
            peerVersion.version = version
        }
        
        if let build = objectJson.object(forKey: "build") as? String {
            peerVersion.build = build
        }

        return peerVersion
    }
}
