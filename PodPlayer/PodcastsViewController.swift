//
//  PodcastsViewController.swift
//  PodPlayer
//
//  Created by Ivan Sliepov on 02.09.2020.
//  Copyright © 2020 Ivan Sliepov. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var podcastURLTextField: NSTextField!
    
    var podcasts: [Podcast] = []
    var episodesVC: EpisodesViewController? = nil
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        getPodcasts()
    }
    
    func getPodcasts() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
            do {
                podcasts = try context.fetch(fetchRequest)
                print(podcasts)
            }
            catch{}
            
            tableView.reloadData()
        }
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        
        if let url = URL(string: podcastURLTextField.stringValue) {
            URLSession.shared.dataTask(with: url) {
                (data:Data?, response:URLResponse?, error:Error?) in
                
                if error != nil {
                    print(error ?? "")
                }
                else {
                    if data != nil {
                        let parser = Parser()
                        let info = parser.getPodcastMetaData(data: data!)
                        
                        if !self.podcastExists(rssURL: self.podcastURLTextField.stringValue) {
                        
                            DispatchQueue.main.async{
                                if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                                    let podcast = Podcast(context: context)
                                    
                                    podcast.rssURL = self.podcastURLTextField.stringValue
                                    podcast.imageURL = info.imageURL
                                    podcast.title = info.title
                                    
                                    (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                                    
                                    self.getPodcasts()
                                    self.podcastURLTextField.stringValue = ""
                                }
                            }
                        }
                    }
                    
                }
            }.resume()
            
        }
            
    }
    
    func podcastExists(rssURL: String) -> Bool {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchRequest.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            do {
                let matchingPodcasts = try context.fetch(fetchRequest)
                
                if matchingPodcasts.count >= 1 {
                    return true
                }
                else {
                    return false
                }
            }
            catch{}
            
            tableView.reloadData()
        }
        return false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "podcastcell"), owner: self) as? NSTableCellView
        
        let podcast = podcasts[row]
        
        if podcast.title != nil {
            cell?.textField?.stringValue = podcast.title!
        }
        else {
            cell?.textField?.stringValue = "UNKNOWN TITLE"
        }
            
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        if tableView.selectedRow>=0 {
            let podcast = podcasts[tableView.selectedRow]
            
            episodesVC?.podcast = podcast
            episodesVC?.updateView()
        }
    }
    
}
