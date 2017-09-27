import UIKit

class Ticker: NSObject {
    public var last: Double = 0
    public var lowestAsk: Double = 0
    public var highestBid: Double = 0
    public var percentChange: Double = 0
    public var baseVolume: Double = 0
    public var quoteVolume: Double = 0
    public var high24hr: Double = 0
    public var low24hr: Double = 0
    
    public static func fromJson(objectJson : NSDictionary) -> Ticker {
        let ticker = Ticker()
        
        if let last = objectJson.object(forKey: "last") as? String {
            ticker.last = Double(last)!
        }
        
        if let lowestAsk = objectJson.object(forKey: "lowestAsk") as? String {
            ticker.lowestAsk = Double(lowestAsk)!
        }
        
        if let highestBid = objectJson.object(forKey: "highestBid") as? String {
            ticker.highestBid = Double(highestBid)!
        }
        
        if let percentChange = objectJson.object(forKey: "percentChange") as? String {
            ticker.percentChange = Double(percentChange)!
        }
        
        if let baseVolume = objectJson.object(forKey: "baseVolume") as? String {
            ticker.baseVolume = Double(baseVolume)!
        }
        
        if let quoteVolume = objectJson.object(forKey: "quoteVolume") as? String {
            ticker.quoteVolume = Double(quoteVolume)!
        }
        
        if let high24hr = objectJson.object(forKey: "high24hr") as? String {
            ticker.high24hr = Double(high24hr)!
        }
        
        if let low24hr = objectJson.object(forKey: "low24hr") as? String {
            ticker.low24hr = Double(low24hr)!
        }

        if let last = objectJson.object(forKey: "Last") as? Double {
            ticker.last = last
        }
        
        if let lowestAsk = objectJson.object(forKey: "Ask") as? Double {
            ticker.lowestAsk = lowestAsk
        }
        
        if let highestBid = objectJson.object(forKey: "Bid") as? Double {
            ticker.highestBid = highestBid
        }

        if let baseVolume = objectJson.object(forKey: "BaseVolume") as? Double {
            ticker.baseVolume = baseVolume
        }

        if let high24hr = objectJson.object(forKey: "High") as? Double {
            ticker.high24hr = high24hr
        }

        if let low24hr = objectJson.object(forKey: "Low") as? Double {
            ticker.low24hr = low24hr
        }
        
        return ticker
    }
}
