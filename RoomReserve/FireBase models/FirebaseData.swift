//
//  FirebaseData.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 24/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
class FirebaseDataModel: NSObject {
    
  
    class func fetchAreaList(roomTypesRef:DatabaseReference!, completion:@escaping (Dictionary<String, String>)->()) {
       
      //  common.showHUD("Loading")

       // var arealist = [String]()
        var responseDict = [String: String]()


          var handle: UInt = 0
         handle =  roomTypesRef.observe(.value, with: { snapshot in
                         for i in snapshot.children {
                          let id = (i as! DataSnapshot).key
                          let value = (i as! DataSnapshot).value as! String
                            responseDict[id] = value
                         //print(id)
              }
            
          roomTypesRef.removeObserver(withHandle: handle)
            completion(responseDict)
         //   common.hideHUD()

             }) { (error) in
               print(error.localizedDescription)
          //      common.hideHUD()

           }
       
    }
    
    
    
    class func fetchFilterList(filterTypesRef:DatabaseReference!,groupState:Int,date:String,noOfSeats:String,timeFrom:String,timeTo:String, completion:@escaping ([Dictionary<String, Any>])->()) {
       
    //    common.showHUD("Loading")
        
            let date_formatted = date.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            filterTypesRef.child(date_formatted).queryOrdered(byChild:"RoomType").queryEqual(toValue:groupState).observe(.value, with: { snapshot in
                // Returns all groups with state "open"
                var sortedSnapshots = [Dictionary<String, Any>]()
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    
                for group in snapshots {
                    
                    if (group.childSnapshot(forPath: "NoOfSeats").value! as! String) == noOfSeats {
                        let checkCompF = (group.childSnapshot(forPath: "TimeFrom").value! as! String)
                        let checkCompT = (group.childSnapshot(forPath: "TimeTo").value! as! String)
                        let isOverlaping = checkTimeOverLap(startDate1: timeFrom, endDate1: timeTo, startDate2: checkCompF, endDate2: checkCompT)
                        
                        if isOverlaping {
                            let dictValue = group.value as? NSDictionary
                            sortedSnapshots.append(dictValue as! Dictionary<String, Any>)
                        }
                        
                    }
                    }
                }
               
             completion(sortedSnapshots)
             //   common.hideHUD()
            }){ (error) in
                print(error.localizedDescription)
               //  common.hideHUD()

            }
            
       
    }

    class func checkTimeOverLap(startDate1:String,endDate1:String,startDate2:String,endDate2:String)-> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startDate1d = dateFormatter.date(from:startDate1)!
        let startDate2d = dateFormatter.date(from:startDate2)!
        let endDate1d = dateFormatter.date(from:endDate1)!
        let endDate2d = dateFormatter.date(from:endDate2)!
        let isOverlapping = (startDate1d...endDate1d).overlaps(startDate2d...endDate2d)
        return isOverlapping
    }
    

    
}
