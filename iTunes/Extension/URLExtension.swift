//
//  URLExtension.swift
//  iTunes
//
//  Created by Rafael Escaleira on 21/11/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import Foundation

public extension URL {
    
    enum iTunesRSSAPI: String {
        
        case top100RSSMusics = "https://rss.itunes.apple.com/api/v1/br/itunes-music/"
        case top100RSSMovies = "https://rss.itunes.apple.com/api/v1/br/movies/top-movies/all/100/explicit.json"
        case top100RSSApps = "https://rss.itunes.apple.com/api/v1/br/ios-apps/top-paid/all/100/explicit.json"
        case top100RSSBooks = "https://rss.itunes.apple.com/api/v1/br/books/top-paid/all/100/explicit.json"
        case top100RSSPodcasts = "https://rss.itunes.apple.com/api/v1/br/podcasts/top-podcasts/all/100/explicit.json"
        case top100RSSTVShows = "https://rss.itunes.apple.com/api/v1/us/tv-shows/top-tv-episodes/all/100/explicit.json"
        case top100RSSMusicVideos = "https://rss.itunes.apple.com/api/v1/br/music-videos/top-music-videos/all/100/explicit.json"
    }
    
    enum YoutubeAPI: String {
        
        case info = "http://www.youtube.com/oembed?url="
        case videos = "https://you-link.herokuapp.com/?url="
        case image = "https://i.ytimg.com/vi/"
    }
    
    enum HTTPMethod: String {
        
        case connect = "CONNECT"
        case delete  = "DELETE"
        case get     = "GET"
        case head    = "HEAD"
        case options = "OPTIONS"
        case patch   = "PATCH"
        case post    = "POST"
        case put     = "PUT"
        case trace   = "TRACE"
    }
}
