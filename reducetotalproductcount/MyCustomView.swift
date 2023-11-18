//
//  customCell.swift
//  reducetotalproductcount
//
//  Created by 4A Labs on 14.09.2023.
//

import Foundation
import UIKit
import RxRelay
import RxSwift

protocol NetworkCanceler{
    func cancelRequests()
}
@IBDesignable class MyCustomView: UICollectionViewCell {
    var injector : BehaviorRelay<[Partials]>?
    @IBAction func increase(_ sender: Any) {
        
        injector?.accept([
            Partials(cartedProductId: self.productCode.text!, entryNumber: "45", productAmount: 1, callCartService: true)
        ])
        cache += 1
        MyCache.setValue(cache,forKey:self.productCode.text!)
        countt.text = cache.description
    }
    @IBOutlet weak var productCode: UILabel!
    
    @IBAction func decrease(_ sender: Any) {
        if(cache == 0){
            addtocartbtn.isHidden = false
            return
        }
        addtocartbtn.isHidden = true
        if(cache == 1){
            addtocartbtn.isHidden = false
        }
        injector?.accept([
            Partials(cartedProductId: self.productCode.text!, entryNumber: "45", productAmount: -1, callCartService: true)
        ])
        cache -= 1
        MyCache.setValue(cache,forKey:self.productCode.text!)
        countt.text = cache.description
    }
    @IBOutlet weak var productName: UILabel!
    var view:UIView!
    @IBOutlet weak var countt: UILabel!
    var cache :Double = 0.0
    func inject(with:BehaviorRelay<[Partials]>,productName:String){
        self.productCode.text = productName
        self.addtocartbtn.isHidden = false
        cache = MyCache.getValue(forKey: productName)?.value ?? DoubleObject(0.0).value!
        countt.text = cache.description
        injector = with
        if(cache>0){
            self.addtocartbtn.isHidden = true
            
        }
    }
    
    @IBOutlet weak var addtocartbtn: UIButton!
    @IBAction func addtocart(_ sender: Any) {
        injector?.accept([
            Partials(cartedProductId: self.productCode.text!.description, entryNumber: "45", productAmount: 1, callCartService: true)
        ])
        cache += 1
        MyCache.setValue(cache,forKey:self.productCode.text!)
        countt.text = cache.description
        addtocartbtn.isHidden = true
    }
}

extension UICollectionViewCell {
    
    static func register(for collectionView: UICollectionView)  {
        let cellName = String(describing: self)
        let cellIdentifier = cellName + "Identifier"
        let cellNib = UINib(nibName: cellName, bundle: .main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}
