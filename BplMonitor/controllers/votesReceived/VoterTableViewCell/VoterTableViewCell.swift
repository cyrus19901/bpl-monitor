import UIKit

class VoterTableViewCell: BaseTableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override class func height() -> CGFloat {
        return 44
    }

    override func setData(_ data: Any?) {
        if let data = data as? Account {
            self.usernameLabel.text = data.username
            self.addressLabel.text = data.address
            self.balanceLabel.text = String(Utils.convertToBplBase(value: Int64(data.balance)!))
        }
    }
    
    func setTitles() {
        self.usernameLabel.text = "Username"
        self.addressLabel.text = "Address"
        self.balanceLabel.text = "Balance"
    }
}
