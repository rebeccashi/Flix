//
//  MoviesViewController.swift
//  Flix
//
//  Created by Rebecca Shi on 9/22/20.
//  Copyright © 2020 Rebecca Shi. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let movie = movies[indexPath.row]
        //syntax to access a value in a dict
        let title  = movie["title"] as! String
        
        //Swift optionals
        cell.textLabel!.text = title
        
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    //Instantiates an array of dictionaries
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // api call to get an array of movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
              // Store the movies in a property to use elsewhere
            //needs to be cast as an array of dictionaries
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
              // Reload your table view data
            self.tableView.reloadData()

           }
        }
        task.resume()
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