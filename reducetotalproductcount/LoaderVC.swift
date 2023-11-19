//
//  LoaderVC.swift
//  reducetotalproductcount
//
//  Created by 4A Labs on 17.11.2023.
//

import UIKit

class LoaderVC : UIViewController {
    var product = ""
    override func viewDidLoad() {
        
        let products = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 350) , size: CGSize(width: 500, height: 250)))
        products.text = product
        products.numberOfLines = 6
        products.textColor = .white
        let customFont = UIFont.systemFont(ofSize: 12)
        products.font = customFont
        
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 50, y: 150) , size: CGSize(width: 150, height: 50)))
        label.text = "adding product..."
        label.numberOfLines = 6
        label.textColor = .white
        
        let act = UIActivityIndicatorView(style: .medium)
        act.color = .white
        act.startAnimating()
        act.layer.position.x = 60
        act.layer.position.y = 200

        view.backgroundColor = .systemBlue
        view.addSubview(label)
        view.addSubview(act)
        view.addSubview(products)
        let randomtimeoffset:Double = Double(Int.random(in: 3..<4))
        DispatchQueue.main.asyncAfter(deadline: (.now() + randomtimeoffset), execute: {
            [weak self] in
            self?.dismiss(animated: true)
        })
    }
}
