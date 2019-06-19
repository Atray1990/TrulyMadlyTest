
import UIKit
import Foundation


class ViewController: UIViewController {
    

    //MARK: - Outlets
    @IBOutlet weak var tblMainTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var arrUserData = [AnyObject]()
    var carousalClicked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isHidden = true
        
        requestForUserDataWith() { result in
           
            if let compatData = result["compatibility_questions"]  {
                self.arrUserData = compatData as! [AnyObject]
            }
         
            DispatchQueue.main.async {
                self.tblMainTable.reloadData()
            }
        }
        
       // collectionViewSetUp(isCrousal: false)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. players.
        
      
    }
    
    func collectionViewSetUp(isCrousal: Bool) {
        
        carousalClicked = isCrousal
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        if isCrousal {
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            layout.scrollDirection = .horizontal
        } else {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (self.collectionView.frame.width - 10 )/2, height: 200)
        }
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.reloadData()
        collectionView!.collectionViewLayout = layout
        
    }

    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (self.collectionView!.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<collectionView.visibleCells.count {
            let cell = collectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = collectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.collectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    
    //MARK :- Methods
    
    // Api call to get dara
    
   func requestForUserDataWith(completionHandler: @escaping(_ result: [String: Any]) -> ())
    {
        let url = URL(string: "https://app.deltaapp.in/api/v2/meta/data")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if (responseJSON as? [String : Any]) != nil {
             
                completionHandler(responseJSON as! [String : Any])
            }
        }
        
        task.resume()
    }
    
    func collectionViewShow() {
        self.tblMainTable.isHidden = true
        self.collectionView.isHidden = false
        
       
    }
    
    // MARK: - btn action
    @IBAction func tableVioewActionClicked(_ sender: Any) {
        self.tblMainTable.isHidden = false
        self.collectionView.isHidden = true
        self.collectionView.reloadData()
        
    }
   
    @IBAction func collectionViewActionClicked(_ sender: Any) {
        self.collectionViewSetUp(isCrousal: false)
       self.collectionViewShow()
        
        
    }
    
    @IBAction func crousalActionClicked(_ sender: Any) {
        self.collectionViewSetUp(isCrousal: true)
        collectionViewShow()
    }
}

// MARK: - tableview delegate and datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let PlayerCell:PlayerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as! PlayerTableViewCell
        
        if let question = arrUserData[indexPath.row]["question"] as? String {
            PlayerCell.lblPlayerName.text = question
        }
        
        if let style = self.arrUserData[indexPath.row]["style"] as? [String:AnyObject], let imageUrl = style["medium"] as? String{
           
            PlayerCell.ivPlayerImage.DownloadImageForCollectionView(from: imageUrl) { (err) in
                
                if err != nil {
                    
                }
            }
        }
       
        return PlayerCell
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUserData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let bodyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell",for: indexPath) as! collectionViewCell
        
        if let question = arrUserData[indexPath.row]["question"] as? String {
            bodyCell.lblPlayerName.text = question
        }
        
        if let style = self.arrUserData[indexPath.row]["style"] as? [String:AnyObject], let imageUrl = style["large"] as? String{
            
            bodyCell.ivPlayerImage.DownloadImageForCollectionView(from: imageUrl) { (err) in
                
                if err != nil {
                    
                }
            }
        }
        return bodyCell
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView && arrUserData.count > 0 {
            if carousalClicked {
                scrollToNearestVisibleCollectionViewCell()
            }

        }
    }
    
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionView && arrUserData.count > 0 {
            if carousalClicked {
                scrollToNearestVisibleCollectionViewCell()
            }
        }
    }
}





