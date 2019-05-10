//
//  ViewController.swift
//  News
//
//  Created by Joseph Njogu on 10/05/2019.
//  Copyright © 2019 Joseph Njogu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    var allitemslist: [Item]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getNews()
    }
    
    
    func getNews() {
        let newsRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=9a6484ffc34342e3877f5b19089c5224")!)
        let task = URLSession.shared.dataTask(with: newsRequest) {(data, response, error) in
            
            if error != nil {
                
                print("There is an Error")
                return
                
            }
            
            self.allitemslist = [Item]()
            
            do {
                
                let items = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as!
                    [String: AnyObject]
                
                if let allItems = items["articles"] as? [[String: AnyObject]] {
                    for singleItem in allItems {
                        
                        let news = Item()
                        
                        if let title = singleItem["title"] as? String, let author = singleItem["author"] as? String,
                            let body = singleItem["description"] as? String, let picture = singleItem["urlToImage"] as? String, let path = singleItem["url"] as? String {
                            
                            news.title = title
                            news.body = body
                            news.author = author
                            news.path = path
                            news.picture = picture
                        }
                        
                        self.allitemslist?.append(news)
                    }
                }
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
                }
                
            } catch let error {
                
                print(error)
                
            }
            
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let List = tableView.dequeueReusableCell(withIdentifier: "itemList", for: indexPath) as! ItemList
        List.title.text = self.allitemslist?[indexPath.item].title
        List.body.text = self.allitemslist?[indexPath.item].description
        return List
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allitemslist?.count ?? 0
    }
    
}

