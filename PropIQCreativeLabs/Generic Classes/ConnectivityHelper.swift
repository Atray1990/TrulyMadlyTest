

import Foundation
import Alamofire



// get request value
public class ConnectivityHelper
{
    @discardableResult class func executePOSTRequest(URLString: String, parameters: [String : AnyObject]?, headers: [String: String]?, success: @escaping(_ responsevalue: Any)->Void, failure: @escaping(_ error: Error?)->Void, notRechable: @escaping()->Void, sessionExpired: @escaping()->Void) -> DataRequest?
    {
       
        if !GlobalReachability.sharedInstance.reachability.isReachable
        {
            DispatchQueue.main.async {
                
                notRechable()
            }
            
            return nil
        }
        
        let dataRequest = Alamofire.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            
            DispatchQueue.main.async {
                
                
                
                guard response.result.isSuccess else {
                    
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    
                                        
                    if let httpResponse = response.response
                    {
                        if httpResponse.statusCode == 401
                        {
                            sessionExpired()
                            
                            return
                        }
                        else if httpResponse.statusCode == 410
                        {
                            success(httpResponse)
                            
                            return
                        }
                    }
                    
                    failure(response.result.error)
                    
                    return
                }
                
               // print("Response: \(response.response) For request : \(response.request)")
                
                if let jsonResponse = response.result.value
                {
                   // print("response: \(jsonResponse)")
                    success(jsonResponse)
                }
                else
                {
                    failure(nil)
                }
            }
        }
        
        return dataRequest
    }
    
    
    // post request value
    @discardableResult class func executeGETRequest(URLString: String, parameters: [String : AnyObject]?, headers: [String: String]?, success: @escaping(_ responsevalue: Any)->Void, failure: @escaping(_ error: Error?)->Void, notRechable: @escaping()->Void, sessionExpired: @escaping()->Void) -> DataRequest?
    {
       // print("parameters are \(parameters) and headers are \(headers) for url \(URLString)")
        
        if !GlobalReachability.sharedInstance.reachability.isReachable
        {
            DispatchQueue.main.async {
                
                notRechable()
            }
            
            return nil
        }
        
        
        let dataRequest = Alamofire.request(URLString, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            
            DispatchQueue.main.async {
                
                guard response.result.isSuccess else {
                    
                   // print("Error while fetching remote rooms: \(response.result.error)")
                    
                    if let httpResponse = response.response
                    {
                        if httpResponse.statusCode == 401
                        {
                            sessionExpired()
                            
                            return
                        }
                    }
                    
                    failure(response.result.error)
                    
                    return
                }
                
               // print("Response: \(response.response) For request : \(response.request)")
                
                if let jsonResponse = response.result.value
                {
                   // print("response: \(jsonResponse)")
                    success(jsonResponse)
                }
                else
                {
                    failure(nil)
                }
            }
        }
        
        return dataRequest
    }
}

