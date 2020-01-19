//
//  DatailViewController.swift
//  iTunes
//
//  Created by Rafael Escaleira on 23/11/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit

class DatailViewController: UIViewController {
    
    @IBOutlet weak var datailTitle: UILabel!
    @IBOutlet weak var datailSubtitle: UILabel!
    @IBOutlet weak var datailGenre: UILabel!
    @IBOutlet weak var datailImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var rssFeedResult: Results?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.datailTitle.text = self.rssFeedResult?.name
        self.datailSubtitle.text = self.rssFeedResult?.artistName
        self.datailGenre.text = self.rssFeedResult?.copyright
        
        DispatchQueue.global(qos: .background).async {
            
            guard let url = URL(string: self.rssFeedResult?.artworkUrl100?.replacingOccurrences(of: "200x200", with: "800x800") ?? "") else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                
                self.datailImage.image = image
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func backButtonAction() {
        
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }
    
    @IBAction func gotToStore() {
        
        guard let urlAppleMusic = URL(string: rssFeedResult?.url ?? "") else { return }
        
        if UIApplication.shared.canOpenURL(urlAppleMusic) {
            
            UIApplication.shared.open(urlAppleMusic, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func gotToGenre() {
        
        guard let urlAppleMusic = URL(string: rssFeedResult?.genres?.first?.url ?? "") else { return }
        
        if UIApplication.shared.canOpenURL(urlAppleMusic) {
            
            UIApplication.shared.open(urlAppleMusic, options: [:], completionHandler: nil)
        }
    }
}
