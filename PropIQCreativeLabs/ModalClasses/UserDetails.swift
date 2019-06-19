

import UIKit

class UserDetails: NSObject {
    
    static let sharedInstance: UserDetails = {
        let instance = UserDetails()
        // setup code
        return instance
    }()

    var strUser_Name = ""
    var strUser_Position = ""
    var strUser_ImageUrl = ""
    
    
    


func clearUserData()
{
     strUser_Name = ""
     strUser_Position = ""
     strUser_ImageUrl = ""
    
    
}
  
    

func fillingLoginData (PlayerDetail:[String: AnyObject?])
{
   
    if let PlayerName = PlayerDetail["name"] as? String
    {
        strUser_Name = PlayerName
    }
    if let strPosition = PlayerDetail["position"] as? String
    {
        strUser_Position = strPosition
    }
    if let strUrl = PlayerDetail["image_url"] as? String
    {
        strUser_ImageUrl = strUrl
    }
   
    
}
    
    





} // end of the function
