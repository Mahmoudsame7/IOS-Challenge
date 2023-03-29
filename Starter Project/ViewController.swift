//
//  ViewController.swift
//  Starter Project
//
//  Created by Ahmed M. Hassan on 26/03/2023.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
   
    
    
    

    @IBOutlet weak var CollectionView: UICollectionView!;
    
    var result:[String]=[];
    
    let colorData=[UIColor.blue , UIColor.red , UIColor.green,UIColor.blue , UIColor.red , UIColor.green,UIColor.blue , UIColor.red , UIColor.green , UIColor.green ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        fetchphotos()
        CollectionView.dataSource=self
        CollectionView.delegate=self

        DispatchQueue.main.async {
            self.CollectionView.reloadData()
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(result.count)
        return result.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CustomCollectionViewCell
       
        //cell.backgroundColor=colorData[indexPath.item]
        let url = URL(string: result[indexPath.item])!


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
                    cell.ImageCell.image = UIImage(data: data as Data)
                }catch{
                    print(error)
                }
            }


        }
        task.resume()
    
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(result[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let id = segue.identifier{
            if(id == "ShowImageViewController"){
                let newVC=segue.destination as! ImageViewController

                //get the index path for the current clicked photo
                var indexPath=self.CollectionView.indexPath(for: sender as! CustomCollectionViewCell)

                let url=self.result[(indexPath!.item)];
                newVC.url=url;

            }
        }


    }
    func fetchphotos(){
        let url = URL(string: "https://api.unsplash.com/photos/?client_id=Ahj-66mbyiRNL-GhTltHoIgGfkznNgv7SALhCOTLMaM")!
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            let decoder=JSONDecoder()
            
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
                    let tasks=try decoder.decode([Image].self ,from: data)
                    tasks.forEach{ i in
                        self.result.append(i.urls["small"]!)
                    }
                    print(self.result)
                }catch{
                    print(error)
                }
            }
            
            
        }
        task.resume()
    }
    
}

