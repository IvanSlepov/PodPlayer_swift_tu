//
//  TheSplitController.swift
//  PodPlayer
//
//  Created by Ivan Sliepov on 03.09.2020.
//  Copyright © 2020 Ivan Sliepov. All rights reserved.
//

import Cocoa

class TheSplitController: NSSplitViewController {

    @IBOutlet weak var PodcastsItem: NSSplitViewItem!
    @IBOutlet weak var EpisodesItem: NSSplitViewItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let podcastsVC = PodcastsItem.viewController as? PodcastsViewController {
            if let episodesVC = EpisodesItem.viewController as? EpisodesViewController {
                podcastsVC.episodesVC = episodesVC
                episodesVC.podcastsVC = podcastsVC
            }
        }
        
    }
    
}
