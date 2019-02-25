//
//  MovieGridDetailsTrailerViewController.swift
//  flixapp
//
//  Created by Ellis Chang on 2/24/19.
//  Copyright © 2019 echang41@gmail.com. All rights reserved.
//

import UIKit

class MovieGridDetailsTrailerViewController: UIViewController {
    
    @IBOutlet weak var trailerWebView: UIWebView!
    
    var videoURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        trailerWebView.loadRequest(URLRequest(url: NSURL(string: videoURL)! as URL))
    }
    
    @IBAction func onClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
