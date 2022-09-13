//
//  ViewController.swift
//  Flix
//
//  Created by Trek on 9/7/22.
//

import UIKit
import AlamofireImage

struct Constants {
    static var movies = [[String:Any]]()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.movies.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = Constants.movies[indexPath.row]
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as!String
        let posterUrl = URL(string: baseURL + posterPath)
        
        cell.titleLabel.text = movie["title"] as! String
        cell.synopsisLabel.text = movie["overview"] as! String
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 Constants.movies = dataDictionary["results"] as! [[String : Any]]
                 self.tableView.reloadData()
             }
        }
        task.resume()
    }


}

