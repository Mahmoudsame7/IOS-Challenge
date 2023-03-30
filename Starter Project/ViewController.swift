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
        fetchphotos{[weak self] (images) in
            self?.result=images
            //print(images)
            DispatchQueue.main.async {
                self?.CollectionView.reloadData()
             }
        }
        
        CollectionView.dataSource=self
        CollectionView.delegate=self
        
//        DispatchQueue.main.async {
//            self.CollectionView.reloadData()
//         }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let CV_width=CollectionView.bounds.width;
        
        let CV_flowlayout=collectionViewLayout as! UICollectionViewFlowLayout;
        let spacebetweencells=CV_flowlayout.minimumInteritemSpacing;
        
        let adjusted_width=CV_width-spacebetweencells;
        
        let width:CGFloat = adjusted_width/2 - 20;
        let height:CGFloat = 140;
        
        return CGSize(width: width, height: height);
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(self.result.count)
        return self.result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        //cell.backgroundColor=colorData[indexPath.item]
        let url = URL(string: self.result[indexPath.item])!
        
        
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
    func fetchphotos(completionHandler: @escaping ([String]) -> Void){
        
        var res:[String]=[]
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
                        res.append(i.urls["small"]!)
                    }
                    //print(res)
                    completionHandler(res)
                    //print(self.result)
                }catch{
                    print(error)
                }
            }
            
            
        }
        task.resume()
        
    }
    
}

