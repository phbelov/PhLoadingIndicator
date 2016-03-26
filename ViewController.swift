//
//  ViewController.swift
//  PhSpinner
//
//  Created by Филипп Белов on 3/25/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: PhLoadingIndicator!
    @IBAction func stopAnimation(sender: UIButton) {
        loadingIndicator.stopAnimating()
    }
    @IBAction func startAnimation(sender: UIButton) {
        loadingIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

