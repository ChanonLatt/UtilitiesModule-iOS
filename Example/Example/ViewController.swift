//
//  ViewController.swift
//  Example
//
//  Created by ITD-Latt Chanon on 25/12/24.
//

import UIKit
import UtilitiesModule_iOS

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var name: String?
        
        name.unwrap {
            print($0)
        }
    }
}

