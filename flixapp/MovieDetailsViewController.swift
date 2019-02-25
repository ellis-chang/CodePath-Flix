//
//  MovieDetailsViewController.swift
//  flixapp
//
//  Created by Ellis Chang on 2/19/19.
//  Copyright © 2019 echang41@gmail.com. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var movie: [String: Any]!
    var trailers = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let id = movie["id"] as! Int
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.trailers = dataDictionary["results"] as! [[String:Any]]
                
                print(dataDictionary)
            }
        }
        task.resume()
        
        //movie title
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        
        //movie synopsis
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        //movie release date reconfigured
        let dates = movie["release_date"] as! String
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd" //get the current date configuration
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" //new date configuration
        
        if let date = dateFormatterGet.date(from: dates) {
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.sizeToFit()
        } else {
            print("There was an error configuring the string")
        }
        
        //Movie Poster View
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        posterView.layer.borderWidth = 2
        posterView.layer.borderColor = UIColor.white.cgColor
        
        posterView.isUserInteractionEnabled = true

        //Backdrop view
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdropView.af_setImage(withURL: backdropUrl!)
    }
    
    @IBAction func posterTap(_ sender: Any) {
        performSegue(withIdentifier: "trailerSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        var count = 0
        var check = false
        while check == false {
            let videos = trailers[count]
            let videoType = videos["type"] as! String
            if (videoType == "Trailer") {
                check = true
            }
            else {
                check = false
                count  = count + 1
            }
        }
        
        print(count)
        
        let trailer = trailers[count]
        let trailerKey =  trailer["key"] as! String
        
        let videoURL = String(format: "https://www.youtube.com/watch?v=%@", trailerKey)
        let trailerViewController = segue.destination as! MovieDetailsTrailerViewController
        trailerViewController.videoURL = videoURL
    }

}
