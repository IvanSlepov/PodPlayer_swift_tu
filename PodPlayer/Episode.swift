//
//  Episode.swift
//  PodPlayer
//
//  Created by Ivan Sliepov on 03.09.2020.
//  Copyright © 2020 Ivan Sliepov. All rights reserved.
//

import Foundation
import Cocoa

class Episode {
    var title = ""
    var episodeDescription = ""
    var audioURL = ""
    var pubDate = Date()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
