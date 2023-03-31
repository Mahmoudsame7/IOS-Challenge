//
//  ViewController.swift
//  Starter Project
//
//  Created by Ahmed M. Hassan on 26/03/2023.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var CollectionView: UICollectionView!;
    
    
    var result:[String]=[];  //Hold url of each image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Calling fetchphotos
        fetchphotos{[weak self] (images) in
            
            //Assign the data returned by completion handler to result variable to be used by collection view
            self?.result=images
            
            //Reload the collection view using the main dispatch queue
            DispatchQueue.main.async {
                self?.CollectionView.reloadData()
             }
        }
        
        CollectionView.dataSource=self
        CollectionView.delegate=self
        

    }
    
    //Make Collection View 2 Columns evenly spaced
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let CV_width=CollectionView.bounds.width;
        
        let CV_flowlayout=collectionViewLayout as! UICollectionViewFlowLayout;
        let spacebetweencells=CV_flowlayout.minimumInteritemSpacing;
        
        let adjusted_width=CV_width-spacebetweencells;
        
        let width:CGFloat = floor(adjusted_width)/2-20;
        let height:CGFloat = 140;
        
        return CGSize(width: width, height: height);
        
    }
    
    //Number of cells rendered by collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        
        let url = URL(string: result[indexPath.item])!
        
        //Displaying image of each collection view cell
        
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
        
    //Passing the clicked image url to ImageViewController in order to be displayed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let id = segue.identifier{
            if(id == "ShowImageViewController"){
                let newVC=segue.destination as! ImageViewController
                
                //get the index path for the current clicked photo
                let indexPath=self.CollectionView.indexPath(for: sender as! CustomCollectionViewCell)
                
                let url=self.result[(indexPath!.item)];
                newVC.url=url;
                
            }
        }
        
        
    }
    
    //fetchphotos used to fetch newly added images to Unsplash API
    func fetchphotos(completionHandler: @escaping ([String]) -> Void){
        
        //completion handler expects data of type array of string will hold the url of each fetched image
        
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
                    
                    completionHandler(res)
                    
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
}

