//
//  ViewController.swift
//  PluggableApplicationDelegate
//
//  Created by fmo91 on 02/25/2017.
//  Copyright (c) 2017 fmo91. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    public var text: String?
    @IBOutlet private weak var lbText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbText.text = text
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

