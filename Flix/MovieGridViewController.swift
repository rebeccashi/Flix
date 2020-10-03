//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Rebecca Shi on 9/27/20.
//  Copyright © 2020 Rebecca Shi. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing) / 2
        layout.itemSize = CGSize(width: width, height: width / 0.675)
        
        //fetch movies similar to Wonderwoman
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        print(request)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
          // This will run when the network request returns
          if let error = error {
             print(error.localizedDescription)
          } else if let data = data {
            print("data")
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.movies = dataDictionary["results"] as! [[String : Any]]
            self.collectionView.reloadData()

          }
       }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        //get movie item from the dictionary
        let movie = movies[indexPath.item]
           
        //set image url based on poster_path parameter in movie object
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        //Alamofire in charge of downloading and setting the image
        cell.posterView.af.setImage(withURL: posterUrl!)
        print(posterUrl)
        
        return cell
    }
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//             Get the new view controller using segue.destination.
//             Pass the selected object to the new view controller.
            
//             Find the selected movie based on row number
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let movie = movies[indexPath.row]
            
//             Pass the selected movie to the details view controller
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
        
        //unselect animation?
            
        }
    

}
