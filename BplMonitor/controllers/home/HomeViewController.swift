import UIKit
import Toaster
import ESPullToRefresh
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankStatusLabel: UILabel!
    @IBOutlet weak var productivityLabel: UILabel!
    @IBOutlet weak var forgedMissedBlocksLabel: UILabel!
    @IBOutlet weak var approvalLabel: UILabel!
    @IBOutlet weak var forgedLabel: UILabel!
    @IBOutlet weak var lastBlockForgedLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var btcEquivalentLabel: UILabel!
    @IBOutlet weak var usdEquivalentLabel: UILabel!
    @IBOutlet weak var eurEquivalentLabel: UILabel!
    @IBOutlet weak var totalBlocksLabel: UILabel!
    @IBOutlet weak var blocksRemainingLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    private var account : Account = Account()
    private var delegate : Delegate = Delegate()
    private var forging : Forging = Forging()
    private var status : Status = Status()
    private var peerVersion : PeerVersion = PeerVersion()
    private var block : Block = Block()
    
    private var balance : Double = -1
    private var bplBTCValue : Double = -1
    private var bitcoinUSDValue : Double = -1
    private var bitcoinEURValue : Double = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Home"
        
        setNavigationBarItem()

        _ = self.scrollView.es_addPullToRefresh {
            [weak self] in
            
            self?.loadData()
            
            self?.scrollView.es_stopPullToRefresh()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    func loadData() -> Void {
        
        if (!Reachability.isConnectedToNetwork()) {
            Toast(text: "Please connect to internet.",
                  delay: Delay.short,
                  duration: Delay.long).show()
            
            return
        }
        
        let activityData = ActivityData(type: NVActivityIndicatorType.lineScale)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        let settings = Settings.getSettings()

        let requestData = RequestData(myClass: self)
        
        BplService.sharedInstance.requestDelegate(settings: settings, listener: requestData)
        BplService.sharedInstance.requestAccount(settings: settings, listener: requestData)
        BplService.sharedInstance.requestForging(settings: settings, listener: requestData)
        BplService.sharedInstance.requestStatus(settings: settings, listener: requestData)
        BplService.sharedInstance.requestPeerVersion(settings: settings, listener: requestData)
        BplService.sharedInstance.requestLastBlockForged(settings: settings, listener: requestData)
        
        let requestTicker = RequestTicker(myClass: self)
        let requestBitcoinUSDTicker = RequestBitcoinUSDTicker(myClass: self)
        let requestBitcoinEURTicker = RequestBitcoinEURTicker(myClass: self)
        
        ExchangeService.sharedInstance.requestTicker(listener: requestTicker)
        ExchangeService.sharedInstance.requestBitcoinUSDTicker(listener: requestBitcoinUSDTicker)
        ExchangeService.sharedInstance.requestBitcoinEURTicker(listener: requestBitcoinEURTicker)
    }

    private func loadAccount() -> Void {
        if (self.account.address.length > 0) {
            self.totalBalanceLabel.text = String((Double(self.account.balance)! * pow(10,-8)))
            self.balance = Double(self.account.balance)!
            self.calculateEquivalentInBitcoinUSDandEUR()
        }
    }
    
    
    private func loadDelegate() -> Void {
        if (self.delegate.address.length > 0) {
            self.nameLabel.text = delegate.username

            let rankStatus : String = delegate.rate <= 201 ? "Active" : "Standby"
            self.rankStatusLabel.text = String(delegate.rate) + " / " + rankStatus

            self.productivityLabel.text = String(delegate.productivity) + "%"
            self.approvalLabel.text = String(delegate.approval) + "%"
            self.addressLabel.text = delegate.address
            
            self.forgedMissedBlocksLabel.text = String(delegate.producedblocks) + " / " + String(delegate.missedblocks)
            
        }
    }
    
    private func loadForging() -> Void {
        self.feesLabel.text =  String(Utils.convertToBplBase(value: Int64(self.forging.fees)!))
//        String(Double(data.balance)! * pow(10, -8))
        self.rewardsLabel.text =  String(Double(self.forging.rewards)! * pow(10,-8))
        self.forgedLabel.text =  String(Double(self.forging.forged)! * pow(10,-8))
    }
    
    private func loadStatus() -> Void {
        self.totalBlocksLabel.text =  String(self.status.height)
        self.blocksRemainingLabel.text = String(self.status.blocks)
    }
    
    private func loadPeerVersion() -> Void {
        self.versionLabel.text =  self.peerVersion.version
    }
    
    private func loadLastBlockForged() -> Void {
        self.lastBlockForgedLabel.text =  Utils.getTimeAgo(timestamp: Double(self.block.timestamp))
    }
    
    private func calculateEquivalentInBitcoinUSDandEUR() -> Void {
        if (self.balance > 0 && self.bplBTCValue > 0) {
            let balanceBtcEquivalent = self.balance * self.bplBTCValue
            self.totalBalanceLabel.text = String(Utils.convertToBplBase(value: Int64(self.balance)))
            self.btcEquivalentLabel.text = "0"
            if (self.bitcoinUSDValue > 0) {
                let balanceUSDEquivalent = balanceBtcEquivalent * self.bitcoinUSDValue
                self.usdEquivalentLabel.text = "0"
            }
            
            if (self.bitcoinEURValue > 0) {
                let balanceEUREquivalent = balanceBtcEquivalent * self.bitcoinEURValue
                self.eurEquivalentLabel.text = "0"
            }
        }
    }
    
    private class RequestData: RequestListener {
        let selfReference: HomeViewController
        
        init(myClass: HomeViewController){
            selfReference = myClass
        }
        
        public func onFailure(e: Error) -> Void {
            Toast(text: "Unable to retrieve data. Please try again later.",
                  delay: Delay.short,
                  duration: Delay.long).show()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        
        func onResponse(object: Any)  -> Void {
            
            
            if let account = object as? Account{
                selfReference.account = account
                selfReference.loadAccount()
            }
            
            if let delegate = object as? Delegate {
                selfReference.delegate = delegate
                selfReference.loadDelegate()
            }
            
            if let forging = object as? Forging {
                selfReference.forging = forging
                selfReference.loadForging()

            }
            
            if let status = object as? Status {
                selfReference.loadStatus()
                selfReference.status = status
            }
            
            if let peerVersion = object as? PeerVersion {
                selfReference.peerVersion = peerVersion
                selfReference.loadPeerVersion()
            }
            
            if let block = object as? Block {
                selfReference.block = block
                selfReference.loadLastBlockForged()
            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    
    private class RequestTicker: RequestListener {
        let selfReference: HomeViewController
        
        init(myClass: HomeViewController){
            selfReference = myClass
        }
        
        public func onFailure(e: Error) -> Void {
            Toast(text: "Unable to retrieve data. Please try again later.",
                  delay: Delay.short,
                  duration: Delay.long).show()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            selfReference.bplBTCValue = -1
        }
        
        func onResponse(object: Any)  -> Void {
            if let ticker = object as? Ticker {
                selfReference.bplBTCValue = ticker.last
                selfReference.calculateEquivalentInBitcoinUSDandEUR()
            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    
    private class RequestBitcoinUSDTicker: RequestListener {
        let selfReference: HomeViewController
        
        init(myClass: HomeViewController){
            selfReference = myClass
        }
        
        public func onFailure(e: Error) -> Void {
            Toast(text: "Unable to retrieve data. Please try again later.",
                  delay: Delay.short,
                  duration: Delay.long).show()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            selfReference.bitcoinUSDValue = -1
        }
        
        func onResponse(object: Any)  -> Void {
            if let ticker = object as? Ticker {
                selfReference.bitcoinUSDValue = ticker.last
                selfReference.calculateEquivalentInBitcoinUSDandEUR()
            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    private class RequestBitcoinEURTicker: RequestListener {
        let selfReference: HomeViewController
        
        init(myClass: HomeViewController){
            selfReference = myClass
        }
        
        public func onFailure(e: Error) -> Void {
            Toast(text: "Unable to retrieve data. Please try again later.",
                  delay: Delay.short,
                  duration: Delay.long).show()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }

        func onResponse(object: Any)  -> Void {
            if let ticker = object as? Ticker {
                selfReference.bitcoinEURValue = ticker.last
                selfReference.calculateEquivalentInBitcoinUSDandEUR()

            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }

}
