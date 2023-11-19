
import UIKit
import RxRelay
import RxSwift

class ViewController: UIViewController {
    
    private weak var task: URLSessionTask?
    let disposeBag :DisposeBag = DisposeBag()
    var networkcanceler:NetworkCanceler?
    let cancelSubject = PublishSubject<Void>()
    let partialArrayForAdjustingProductCounts = BehaviorRelay<[Partials]>(value: [])
    @IBOutlet weak var kollektion: UICollectionView!
    @IBOutlet weak var sumofproducts: UILabel!
    let totalProducts = ViewController.generateRandomUUIDArray(count:10000)
    override func viewDidLoad() {
        super.viewDidLoad()
        kollektion.delegate = self
        kollektion.dataSource = self
        initViews()
        bindRx()
    }
    
    func initViews(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth-10), height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        kollektion.collectionViewLayout = layout
        MyCustomView.register(for:kollektion)
    }
    func bindRx(){
        let observable = partialArrayForAdjustingProductCounts
            .asObservable()
        let scannedDebounceObservable = observable
            .scan([]) { accumulator, feed in
                return accumulator + [feed]
            }
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
        
        scannedDebounceObservable
            .filter({ $0.count>0 })
            .subscribe({ [weak self] (accumulatedPartials) in
                var result2:[String:Double] = [:]
                let partialCount: [String:Double] = (accumulatedPartials.element?.reduce(["":0.0], { partialResult, arr in
                    for part in arr {
                        if(result2[part.cartedProductId] != nil){
                            result2[part.cartedProductId]! += part.productAmount + 0
                        }else{
                            result2[part.cartedProductId] = part.productAmount
                        }
                    }
                    return result2
                }))!
                guard partialCount.count>0 else {return}
                //check login & token
                let debugText = "sending to server\n(accumulated# in 2 sec \n\(partialCount.description.replacingOccurrences(of: ",", with: "\n")))"
                print("\(debugText))")
                let loader = LoaderVC()
                loader.product = debugText
                loader.modalPresentationStyle = .fullScreen
                loader.modalTransitionStyle = .crossDissolve
                self?.present(loader, animated: true, completion: nil)
                //self?.loadItems(name: "test", url: URL(string:"https://google.com")!)
                
            })
            .disposed(by: disposeBag)
    }
    deinit {
        task?.cancel()
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MyCustomView = kollektion.dequeueReusableCell(withReuseIdentifier: "MyCustomViewIdentifier", for: indexPath) as! MyCustomView
        cell.inject(with: partialArrayForAdjustingProductCounts,productName:totalProducts[indexPath.row])
        return cell
        
    }
    
}

extension ViewController{
    func loadItems(name: String, url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
        }
        task.resume()
        self.task = task
    }
    static func generateRandomUUIDArray(count: Int) -> [String] {
        var uuidArray: [String] = []
        
        for _ in 0..<count {
            let uuid = UUID().uuidString
            uuidArray.append(uuid)
        }
        
        return uuidArray
    }
}
