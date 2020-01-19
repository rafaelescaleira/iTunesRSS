//
//  DownloadViewController.swift
//  iTunes
//
//  Created by Rafael Escaleira on 09/12/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import AVKit

class DownloadViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [VideoDatabase] = []
    var images: [String: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.data = VideoDatabase.query().fetch() as? [VideoDatabase] ?? []
        self.downloadImages(data: self.data)
    }
    
    private func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func downloadImages(data: [VideoDatabase]) {
        
        for video in data {
            
            DispatchQueue.global(qos: .background).async {
                
                let id = video.videoImage?.replacingOccurrences(of: "https://youtu.be/", with: "").components(separatedBy: "=").last
                guard let url = URL(string: URL.YoutubeAPI.image.rawValue + (id ?? "") + "/maxresdefault.jpg") else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    
                    self.images[id ?? ""] = image
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func playerButtonAction(_ sender: UIButton) {
        
        let item = self.data[sender.tag]
        
        let path = self.getDocumentsDirectory().appendingPathComponent((item.videoName?.withoutSpecialCharacters ?? "") + "." + (item.videoFormat?.lowercased() ?? ""))
        
        let player = AVPlayer(url: path)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    @objc func shareButtonAction(_ sender: UIButton) {
        
        let item = self.data[sender.tag]
        
        let path = self.getDocumentsDirectory().appendingPathComponent((item.videoName?.withoutSpecialCharacters ?? "") + "." + (item.videoFormat?.lowercased() ?? ""))
        
        let controller = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        
        DispatchQueue.main.async { self.present(controller, animated: true, completion: nil) }
    }
}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = self.data.count == 0 ? .none : .singleLine
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTableViewCell", for: indexPath) as? DownloadTableViewCell else { return UITableViewCell() }
        
        let item = data[indexPath.row]
        
        cell.selectionStyle = .none
        cell.playVideo.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.playVideo.addTarget(self, action: #selector(self.playerButtonAction(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(self.shareButtonAction(_:)), for: .touchUpInside)
        cell.videoName.text = item.videoName
        cell.videoFormat.text = item.videoFormat
        cell.videoChannel.text = item.videoChannel
        cell.videoHD.text = item.videoHD
        cell.videoImage.image = self.images[item.videoImage?.replacingOccurrences(of: "https://youtu.be/", with: "https://www.youtube.com/watch?v=").components(separatedBy: "=").last ?? ""]
        
        return cell
    }
}

public class DownloadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoChannel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoFormat: UILabel!
    @IBOutlet weak var videoHD: UILabel!
    @IBOutlet weak var playVideo: UIButton!
    @IBOutlet weak var shareButton: UIButton!
}
