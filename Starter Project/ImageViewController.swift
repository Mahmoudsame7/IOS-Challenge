//
//  ImageViewController.swift
//  Starter Project
//
//  Created by Sameh on 28/03/2023.
//

import UIKit

class ImageViewController: UIViewController {

    var url:String="";
    @IBOutlet weak var Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: url)!


        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print(response)
                return
            }
            if let data=data{
                do{
                    self.Image.image=UIImage(data: data as Data)
                }catch{
                    print(error)
                }
            }


        }
        task.resume()
    }
    

   

}
