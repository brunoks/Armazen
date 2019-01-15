//
//  ViewController.swift
//  Generics
//
//  Created by Luciano Pezzin on 10/12/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit


struct HomeFeed: Decodable {
    let videos: [Video]
}

struct Video: Decodable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
}

class ViewController: UIViewController {
    //var homeFeed: HomeFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.shared.FetchData("https://api.letsbuildthatapp.com/youtube/home_feed") { (feed: HomeFeed) in
            feed.videos.forEach( {print($0.name)} )
        }
    }


}

struct Service {
    static let shared = Service()
    func FetchData<I: Decodable>(_ urlstring: String, completion: @escaping (I) -> ()) {
        guard let url = URL(string: urlstring) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err {
                print("Failed to fetch: ", err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let feed = try JSONDecoder().decode(I.self, from: data)
                DispatchQueue.main.async {
                    completion(feed)
                }
            } catch let jsonErr {
                print("Failed to serialize json:", jsonErr)
            }
        }.resume()
    }
}























struct asd: Decodable {
    let videos: [d]
}

struct d: Decodable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
}
