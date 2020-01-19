//
//  PlayerViewController.swift
//  iTunes
//
//  Created by Rafael Escaleira on 22/11/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import AVKit
import UIKit
import SharkORM

class VideoDatabase: SRKObject {
    
    @objc dynamic var videoUrl: String?
    @objc dynamic var videoName: String?
    @objc dynamic var videoChannel: String?
    @objc dynamic var videoImage: String?
    @objc dynamic var videoFormat: String?
    @objc dynamic var videoHD: String?
}

class PlayerViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var imageVideo: UIImageView!
    @IBOutlet weak var titleVideo: UILabel!
    @IBOutlet weak var channelVideo: UILabel!
    @IBOutlet weak var hdVideo: UILabel!
    @IBOutlet weak var formatVideo: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadProgressLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    var dataCodable: YoutubeVideoInfoCodable?
    var dataLinks: [YoutubeVideoDownload] = []
    
    var task: URLSessionTask!
    
    lazy var session : URLSession = {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Cole aqui a URL"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
    }
    
    private func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        
        self.downloadYoutubeVideo(urlString: self.dataLinks.first?.url ?? "")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == "" {
            
            self.progressView.progress = 0
            self.progressView.alpha = 0
            self.downloadProgressLabel.text = ""
            
            UIView.animate(withDuration: 0.5) {
                
                self.viewResult.alpha = 0
            }
        }
            
        else {
            
            guard let urlText = URL(string: searchController.searchBar.text?.replacingOccurrences(of: "https://youtu.be/", with: "https://www.youtube.com/watch?v=") ?? "") else { return }
            
            URLRequest.youtubeVideoLinks(urlString: urlText.absoluteString) { (dataCodable) in

                DispatchQueue.main.async {

                    self.dataLinks = dataCodable
                    self.hdVideo.text = self.dataLinks.first?.qualityLabel == "720p" || self.dataLinks.first?.qualityLabel == "1080p" ? (self.dataLinks.first?.qualityLabel ?? "") + " HD" : ""
                    self.formatVideo.text = self.dataLinks.first?.mimeType?.uppercased()
                }
            }
            
            URLRequest.youtubeVideoInfo(urlString: urlText.absoluteString) { (dataCodable) in
                
                DispatchQueue.main.async {
                    
                    self.dataCodable = dataCodable
                    self.titleVideo.text = self.dataCodable?.title
                    self.channelVideo.text = self.dataCodable?.authorName
                    
                    let id = urlText.absoluteString.replacingOccurrences(of: "https://youtu.be/", with: "").components(separatedBy: "=").last
                    
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        guard let url = URL(string: URL.YoutubeAPI.image.rawValue + (id ?? "") + "/maxresdefault.jpg") else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        guard let image = UIImage(data: data) else { return }
                        
                        DispatchQueue.main.async {
                            
                            self.imageVideo.image = image
                        }
                    }
                    
                    UIView.animate(withDuration: 0.5) {
                        
                        self.viewResult.alpha = 1
                        self.downloadButton.alpha = 1
                    }
                }
            }
        }
    }
    
    @IBAction func playerButtonAction() {
        
        guard let urlText = URL(string: self.navigationController?.navigationItem.searchController?.searchBar.text?.replacingOccurrences(of: "https://youtu.be/", with: "https://www.youtube.com/watch?v=") ?? "") else { return }
        
        let player = AVPlayer(url: urlText)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    func downloadYoutubeVideo(urlString: String) {
        
        self.downloadButton.alpha = 0
        self.progressView.alpha = 1
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        let task = self.session.downloadTask(with: request)
        self.task = task
        task.resume()
    }
}

extension PlayerViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

        DispatchQueue.main.async {
            
            self.progressView.progress = progress
            self.downloadProgressLabel.text = String(format: "%.f", progress * 100) + " %"
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
        
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("completed: error: \(String(describing: error))")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let path = self.getDocumentsDirectory().appendingPathComponent((self.titleVideo.text?.withoutSpecialCharacters ?? "") + "." + (self.formatVideo.text?.lowercased() ?? ""))
        let fileManager = FileManager()
        

        do {
            try fileManager.copyItem(at: location, to: path)
            self.progressView.alpha = 0
            self.progressView.progress = 0
            self.downloadProgressLabel.text = ""
            let database = VideoDatabase()
            database.videoUrl = path.absoluteString
            database.videoHD = self.hdVideo.text
            database.videoName = self.titleVideo.text
            database.videoImage = self.navigationItem.searchController?.searchBar.text ?? ""
            database.videoChannel = self.channelVideo.text
            database.videoFormat = self.formatVideo.text
            database.commit()
        }
            
        catch {
            
            self.downloadButton.alpha = 1
            self.progressView.progress = 0
            self.progressView.alpha = 0
            self.downloadProgressLabel.text = ""
            print("Error while copy file")
            
        }
    }
}

extension String {
    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }
}
