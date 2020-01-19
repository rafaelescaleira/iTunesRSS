//
//  MusicsViewController.swift
//  iTunes
//
//  Created by Rafael Escaleira on 21/11/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import Blueprints

class MusicsViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var rssFeed: RSSFeed?
    var rssFeedResults: [Results] = []
    var images: [String: UIImage] = [:]
    var feedTypes: [[String: String]] = [["Hot Tracks":"hot-tracks"], ["New Music": "new-music"], ["Recent Releases":"recent-releases"], ["Top Albums": "top-albums"], ["Top Songs":"top-songs"]]
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemsPerRow = (self.view.frame.width - 60)
        let numbersItem: CGFloat = 2
        let height = (((itemsPerRow / numbersItem) * 1) / 1) + 40
        let layout = VerticalBlueprintLayout(itemsPerRow: itemsPerRow / (itemsPerRow / numbersItem), height: CGFloat(height), minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), stickyHeaders: false, stickyFooters: false)
        self.collectionView.collectionViewLayout = layout
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search title, genre and artist"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        self.feedTypes.reverse()
        
        self.title = self.feedTypes[selectedIndex].first?.key
        
        activityIndicator.startAnimating()
        
        URLRequest.top100RSSMusics(urlString: self.feedTypes[selectedIndex].first?.value ?? "") { (rssFeed) in
            
            DispatchQueue.main.async {
                
                self.rssFeed = rssFeed
                self.rssFeedResults = self.rssFeed?.feed?.results ?? []
                self.downloadImages(rssFeed: self.rssFeed)
            }
        }
    }
    
    @IBAction func listButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "FeedTypeViewController") as? FeedTypeViewController else { return }
        
        DispatchQueue.global(qos: .background).async {
            
            controller.delegate = self
            controller.dataSource = self
            
            DispatchQueue.main.async { self.present(controller, animated: true, completion: nil) }
        }
    }
    
    @IBAction func reloadButtonAction(_ sender: Any) {
        
        self.rssFeedResults = []
        self.rssFeed = nil
        self.collectionView.reloadData()
        activityIndicator.startAnimating()
        
        URLRequest.top100RSSMusics(urlString: self.feedTypes[selectedIndex].first?.value ?? "") { (rssFeed) in
            
            DispatchQueue.main.async {
                
                self.rssFeed = rssFeed
                self.rssFeedResults = self.rssFeed?.feed?.results ?? []
                self.downloadImages(rssFeed: self.rssFeed)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == "" { self.rssFeedResults = self.rssFeed?.feed?.results ?? [] }
            
        else {
            
            self.rssFeedResults = self.rssFeed?.feed?.results?.filter({ (current) -> Bool in
                
                return current.name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false || current.artistName?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false || current.genres?.first?.name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            }) ?? []
        }
        
        self.collectionView.reloadData()
    }
    
    private func downloadImages(rssFeed: RSSFeed?) {
        
        guard let results = rssFeed?.feed?.results else { return }
        
        for result in results {
            
            DispatchQueue.global(qos: .background).async {
                
                guard let url = URL(string: result.artworkUrl100?.replacingOccurrences(of: "200x200", with: "500x500") ?? "") else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    
                    self.images[url.absoluteString] = image
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension MusicsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.feedTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedType", for: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = self.feedTypes[indexPath.row].first?.key
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            cell.accessoryType = .checkmark
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
                self.selectedIndex = indexPath.row
                
                DispatchQueue.main.async { self.dismiss(animated: true) {
                    
                    self.rssFeedResults = []
                    self.rssFeed = nil
                    self.title = self.feedTypes[self.selectedIndex].first?.key
                    self.collectionView.reloadData()
                    self.activityIndicator.startAnimating()
                    
                    URLRequest.top100RSSMusics(urlString: self.feedTypes[self.selectedIndex].first?.value ?? "") { (rssFeed) in
                        
                        DispatchQueue.main.async {
                            
                            self.rssFeed = rssFeed
                            self.rssFeedResults = self.rssFeed?.feed?.results ?? []
                            self.downloadImages(rssFeed: self.rssFeed)
                        }
                    }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.rssFeedResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        let results = self.rssFeedResults[indexPath.row]
        
        cell.movieTitle.text = results.name
        cell.movieImage.image = self.images[results.artworkUrl100?.replacingOccurrences(of: "200x200", with: "500x500") ?? ""]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let results = self.rssFeedResults[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "DatailViewController") as? DatailViewController else { return }
        
        DispatchQueue.global(qos: .background).async {
            
            controller.rssFeedResult = results
            
            DispatchQueue.main.async { self.present(controller, animated: true, completion: nil) }
        }
    }
}
