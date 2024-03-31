//
//  ViewController.swift
//  Prefetching
//
//  Created by Ranjit Mahto on 31/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview : UITableView!
    private var isFetchingFeed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUptableView()
    
    }
    
    private var feeds = [String]()
    //private let viewModels = Array(1...100).map { "Hello World: \($0)" }
    private let viewModels = Array(1...100).map { _ in ViewModel() }
    
    let url = "https://source.unsplash.com/random/\(300)x\(300)"

    func setUptableView(){
        
        let photoCellNib = UINib(nibName:"PhotoCell", bundle: nil)
        tableview.register(photoCellNib, forCellReuseIdentifier: "PhotoCell")
        //tableview.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        tableview.estimatedRowHeight = 200
        tableview.rowHeight = UITableView.automaticDimension
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.prefetchDataSource = self
    }
    
    
    func fetchFeeds() {
        isFetchingFeed = true
        //call api {
        // add array of content to modelsArray
        //reload table view
        //increase page no
        // isFetchingFeed = false
        //}
        
        
    }

}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell" , for: indexPath) as! PhotoCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //let indices = indexPaths.map {"\($0.row)"}.joined(separator:", ")
        //print("Prefetch: \(indices)")
        
        for indexPath in indexPaths {
            print("Prefetching: \(indexPath.row)")
            let viewModel = viewModels[indexPath.row]
            viewModel.downloadImage(completion:nil)
            
            //for feed
            if  feeds.count >= indexPath.row-3 && !isFetchingFeed { // call before 3 row
                fetchFeeds() //call next page of feeds. this is infinite scrolling  and  loading data
                break //for prevent reloading of data
            }
        }
    }
}

























