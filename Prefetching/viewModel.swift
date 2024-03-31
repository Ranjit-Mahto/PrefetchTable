//
//  viewModel.swift
//  Prefetching
//
//  Created by Ranjit Mahto on 31/03/24.
//

import Foundation
import UIKit
class ViewModel {
    
    
    
    init() {}
    
    private var isDownloading = false
    private var catchImage : UIImage?
    private var callback: ((UIImage?) -> Void)?
    
    func downloadImage(completion: ((UIImage?) -> Void)?) {
        
        if let image = catchImage {
            completion?(image)
            return
        }
        
        guard isDownloading == false else {
            self.callback = completion
            return
        }
        
        isDownloading = true
        //let size = Int.random(in: 100...350)
        
        guard let url = URL(string: "https://source.unsplash.com/random/\(300)x\(300)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.catchImage = image
                self.callback?(image)
                self.callback = nil
                completion?(image)
            }
        }
        task.resume()
        
    }
    
}
