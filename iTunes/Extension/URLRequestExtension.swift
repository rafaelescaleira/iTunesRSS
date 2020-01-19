//
//  URLRequestExtension.swift
//  iTunes
//
//  Created by Rafael Escaleira on 21/11/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    static func top100RSS(urlString: String, completion: @escaping (RSSFeed) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                
                guard let data = data else { return }
                let rssFeed = try JSONDecoder().decode(RSSFeed.self, from: data)
                
                DispatchQueue.main.async { completion(rssFeed) }
            }
                
            catch {}
            
        }).resume()
    }
    
    static func top100RSSMusics(urlString: String, completion: @escaping (RSSFeed) -> ()) {
        
        guard let url = URL(string: URL.iTunesRSSAPI.top100RSSMusics.rawValue + urlString + "/all/100/explicit.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                
                guard let data = data else { return }
                let rssFeed = try JSONDecoder().decode(RSSFeed.self, from: data)
                
                DispatchQueue.main.async { completion(rssFeed) }
            }
                
            catch {}
            
        }).resume()
    }
    
    static func youtubeVideoInfo(urlString: String, completion: @escaping (YoutubeVideoInfoCodable) -> ()) {
        
        guard let url = URL(string: URL.YoutubeAPI.info.rawValue + urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                
                guard let data = data else { return }
                let dataCodable = try JSONDecoder().decode(YoutubeVideoInfoCodable.self, from: data)
                
                DispatchQueue.main.async { completion(dataCodable) }
            }
                
            catch {}
            
        }).resume()
    }
    
    static func youtubeVideoLinks(urlString: String, completion: @escaping ([YoutubeVideoDownload]) -> ()) {
        
        guard let url = URL(string: URL.YoutubeAPI.videos.rawValue + urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = URL.HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                
                guard let data = data else { return }
                let dataCodable = try JSONDecoder().decode([YoutubeVideoDownload].self, from: data)
                
                DispatchQueue.main.async { completion(dataCodable) }
            }
                
            catch {}
            
        }).resume()
    }
}
