//
//  RoomReserveVC.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 21/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class RoomReserveVC: UIViewController,findAreaProtocol {
    
    

    //main view outlets
    @IBOutlet weak var labelAreaType: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelRoom: UILabel!
    @IBOutlet weak var labelTimeSlot: UILabel!
        
    @IBOutlet var category_PopUp_View: UIView!
    @IBOutlet var view_tableAreaList: UIView!
    
    @IBOutlet weak var tableView_AreaList: UITableView!
    

    
    // For Date Selection
    @IBOutlet weak var datePicker_SubView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
  //  @IBOutlet weak var button_Cancel: CustomButtonVC!
   // @IBOutlet weak var button_Save: CustomButtonVC!
    var strDate : String = String()
    
    //For Time Selection
    
    @IBOutlet weak var TimePicker_SubView: UIView!
    @IBOutlet weak var label_startTime_Hr: UILabel!
    @IBOutlet weak var label_startTime_Min: UILabel!
    @IBOutlet weak var label_endTime_Hr: UILabel!
    @IBOutlet weak var label_endTime_Min: UILabel!
 //   @IBOutlet weak var button_Save_Time: CustomButtonVC!
   // @IBOutlet weak var button_CancelTime: CustomButtonVC!
    var start_Time : String = String()
    var end_Time : String = String()
    var selected_UserImage : String = String()
    
    //For picker Selection
    @IBOutlet weak var pickerView_Subview: UIView!
    @IBOutlet weak var picker_view: UIPickerView!

    //For nOTIFICATION pOPUP
    
    @IBOutlet weak var notification_SubView: UIView!
    @IBOutlet weak var labelNotification_Msg: UILabel!
    
    
    var shadowView = UIView()
    var int_type = Int()
    
    var roomTypesRef: DatabaseReference = Database.database().reference().child("RoomType")
    var filterRoomRef: DatabaseReference = Database.database().reference().child("Booking")

    var dict_areaList = [String : String]()
    var arr_areaValues = [String]()
    var arr_areaKeys = [String]()
    var database_input = [String : String]()
    var strAreaKey = String()
    //pickerview datas
    let array_seatCapacity = ["10-20","20-30","30-40","40-50","50-60","60-70","70-80","80-90","100+"]
    let array_bookingType = ["Once","Weekly","Fortnightly","Monthly"]
    var strSeatCapacity = String()
    var strBookingType = String()
    
    //popupView filterResult
    private var isResultShow : Bool = false
    var filterAreaVC : filterAreaListVC! = nil

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())

        SetupView()
      //  roomTypesRef = Database.database().reference().child("RoomType")
        tableView_AreaList.delegate = self
        tableView_AreaList.dataSource = self
    }
    
    
    func SetupView() {
        
        //mine
      //  self.category_PopUp_View.roundCornerView(.allCorners, radius: 15, borderColor: UIColor.white, borderWidth: 2)
        datePicker_SubView.isHidden = true
        TimePicker_SubView.isHidden = true
        self.notification_SubView.isHidden=true
      //  self.view_tableAreaList.roundCornerView(.allCorners, radius: 15, borderColor: UIColor.white, borderWidth: 2)
                
        self.view.layoutIfNeeded()
    }
    
    //main view Actions
    @IBAction func AreaTypePressed(_ sender: Any) {
        SetUpSubView(popUpType: 1)
        if dict_areaList.values.isEmpty{
            FirebaseDataModel.fetchAreaList(roomTypesRef: roomTypesRef) { (result) -> () in
                 self.dict_areaList = result
                 self.arr_areaValues = Array(self.dict_areaList.values)
                 self.arr_areaKeys = Array(self.dict_areaList.keys)
                 self.tableView_AreaList.reloadData()
            }
        }
    }
    
    @IBAction func DateTimePressed(_ sender: Any) {
        SetUpSubView(popUpType: 2)
    }
    
    @IBAction func ButtonClosePressed(_ sender: Any) {
        CloseAction()
    }
        
    @IBAction func buttonFindPressed(_ sender: Any) {
        if (strBookingType != "" && strAreaKey != ""  && strSeatCapacity != "" && strDate != "" && start_Time != "" ){
            fetchFilterRoomResult()
            slideTheMenu()
        } else{
          //  common.showErrorView(message: "Please input details", viewController: self)
        }
    }
    
    // functions
    func FindTimeDifference() -> String  {
        let sample_array = [end_Time,start_Time]
        var hours:Int = 0
        var minutes:Int = 0
        for timeString in sample_array {
            let components = timeString.components(separatedBy: ":")
            let hourComp = Int(components.first ?? "0") ?? 0
            let minComp = Int(components.last ?? "0") ?? 0
            hours += hourComp
            minutes += minComp
        }
        hours -= minutes/60
        minutes = minutes%60
        let hoursString = hours > 9 ? hours.description : "0\(hours)"
        let minsString = minutes > 9 ? minutes.description : "0\(minutes)"
        let totalTime = hoursString+":"+minsString
        return totalTime
    }
        
    func CloseAction(){
        self.category_PopUp_View.isHidden = true
        self.view_tableAreaList.isHidden = true
        self.datePicker_SubView.isHidden = true
        self.pickerView_Subview.isHidden = true
        self.TimePicker_SubView.isHidden = true
        self.notification_SubView.isHidden=true
        shadowView .removeFromSuperview()
    }
    
    func SetUpSubView(popUpType : NSInteger){
        shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black .withAlphaComponent(0.5)
        if (popUpType == 1){
            self.view_tableAreaList.isHidden = false
            self.parent?.view.addSubview(shadowView)
            self.parent?.view.addSubview(self.view_tableAreaList)
            view_tableAreaList.frame = CGRect(x:0, y:0, width: 325, height: 400)
            view_tableAreaList.center = (self.parent?.view.center)!
        }else{
            self.category_PopUp_View.isHidden = false
            self.parent?.view.addSubview(shadowView)
            self.parent?.view.addSubview(self.category_PopUp_View)
            category_PopUp_View.frame =  CGRect(x:0, y: 0, width:325, height:250)
            category_PopUp_View.center = (self.parent?.view.center)!
            
           if (popUpType == 2) {
                datePicker_SubView.isHidden = false
            pickerView_Subview.isHidden = true
              //  button_Cancel.roundCornersbutton([UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 20, borderColor: UIColor.darkGray, borderWidth: 2)
              //  button_Save.roundCornersbutton([UIRectCorner.topLeft, UIRectCorner.bottomLeft], radius: 20, borderColor: UIColor.darkGray, borderWidth: 2)

            } else if(popUpType == 3) {
                TimePicker_SubView.isHidden = false
           //     button_CancelTime.roundCornersbutton([UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 20, borderColor: UIColor.darkGray, borderWidth: 2)
             //   button_Save_Time.roundCornersbutton([UIRectCorner.topLeft, UIRectCorner.bottomLeft], radius: 20, borderColor: UIColor.darkGray, borderWidth: 2)
            } else if(popUpType == 4) {
                pickerView_Subview.isHidden = false
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Button_SaveDate_Pressed(_ sender: Any) {
        if((sender as AnyObject).tag==0){
            setDateAndTime()
            labelDateTime.text = strDate
            CloseAction()
            SetUpSubView(popUpType: 3)
        } else if((sender as AnyObject).tag==1){
            start_Time = label_startTime_Hr.text! + ":" + label_startTime_Min .text!
            end_Time = label_endTime_Hr.text! + ":" + label_endTime_Min.text!
            print(start_Time , end_Time)
            labelDateTime.text?.append("\n"+start_Time + "-" + end_Time)
            CloseAction()
        }
    }
    //For Select Time
    @IBAction func ButtonUpArrowPressed(_ sender: Any) {
        var time : NSInteger
        
        switch (sender as AnyObject).tag {
            
        case 1:
            
            time = 21
            var current_Time: Int = Int(label_startTime_Hr.text!)!
            if(current_Time < time){
                current_Time = current_Time+1
                label_startTime_Hr.text = String(describing: current_Time)
                
            }
        case 2 :
            
            time = 59
            var current_Time: Int = Int(label_startTime_Min.text!)!
            if(current_Time < time){
                current_Time = current_Time+1
                label_startTime_Min.text = String(describing: current_Time)
            }
        case 3 :
            
            time = 21
            var current_Time: Int = Int(label_endTime_Hr.text!)!
            if(current_Time < time){
                current_Time = current_Time+1
                label_endTime_Hr.text = String(describing: current_Time)
            }
        case 4 :
            
            time = 59
            var current_Time: Int = Int(label_endTime_Min.text!)!
            if(current_Time < time){
                current_Time = current_Time+1
                label_endTime_Min.text = String(describing: current_Time)
            }
            
        default:
            print("Do Nothing! :p")
        }
    }
    
    @IBAction func buttomDownArrowPressed(_ sender: Any) {
        var time : NSInteger
        
        switch (sender as AnyObject).tag {
            
        case 1:
            
            time = 21
            var current_Time: Int = Int(label_startTime_Hr.text!)!
            if(current_Time <= time && current_Time > 6){
                current_Time = current_Time-1
                label_startTime_Hr.text = String(describing: current_Time)
                
            }
        case 2 :
            
            time = 59
            var current_Time: Int = Int(label_startTime_Min.text!)!
            if(current_Time <= time && current_Time > 0){
                current_Time = current_Time-1
                label_startTime_Min.text = String(describing: current_Time)
            }
        case 3 :
            
            time = 21
            var current_Time: Int = Int(label_endTime_Hr.text!)!
            if(current_Time <= time && current_Time > 6){
                current_Time = current_Time-1
                label_endTime_Hr.text = String(describing: current_Time)
            }
        case 4 :
            
            time = 59
            var current_Time: Int = Int(label_endTime_Min.text!)!
            if(current_Time <= time && current_Time > 0
                ){
                current_Time = current_Time-1
                label_endTime_Min.text = String(describing: current_Time)
            }
            
        default:
            print("Do Nothing! :p")
        }
    }
    
    //MARK:- Date
    func setDateAndTime() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "dd-MM-yyyy"

        strDate = dateFormatter.string(from: datePicker.date)
    }
    
    //MARK:- SETUP RESULT SUBVIEW
    func showViewController(_ viewController: UIViewController) {
        
    }
    
    func slideTheMenu() {
        
        if !isResultShow {
           // filterAreaVC.setValues()
        }
                
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
            self.isResultShow = !self.isResultShow
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "areaListSegue" {
        if let childVC = segue.destination as? filterAreaListVC {
          //Some property on ChildVC that needs to be set
            childVC.delegate = self
        }
      }
    }
        
    func fetchFilterRoomResult(){
            
        print( strDate , start_Time , end_Time , strSeatCapacity,strBookingType,strAreaKey)
                   
                
        FirebaseDataModel.fetchFilterList(filterTypesRef: filterRoomRef, groupState: Int(strAreaKey)!, date: strDate, noOfSeats: strSeatCapacity, timeFrom: start_Time, timeTo: end_Time){(result) -> () in
                          print(result)
                      
        }
    }
}

//MARK:- TableView Delegates

extension RoomReserveVC: UITableViewDataSource, UITableViewDelegate {
     
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arr_areaValues.count
   }
     
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
       let cell = tableView.dequeueReusableCell(withIdentifier: "areaviewcell", for: indexPath)as! AreaTableViewCell
       cell.clipsToBounds = true

       cell.labelArea.text = arr_areaValues[indexPath.row] as String
     
       return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       let selectedCell = tableView.cellForRow(at: indexPath) as! AreaTableViewCell
       labelAreaType.text = arr_areaValues[indexPath.row]
       strAreaKey = arr_areaKeys[indexPath.row] as String

       CloseAction()
   }
}

//MARK:- PickerView Delegates

extension RoomReserveVC: UIPickerViewDelegate,UIPickerViewDataSource {
     
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if int_type == 1{
              return array_seatCapacity.count
         }
         else{
             return array_bookingType.count
         }
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if int_type == 2{
             let pickerText = array_bookingType[row]
             return pickerText
             
         }else {
             let pickerText = array_seatCapacity[row] + " Seats"
             return pickerText
             
         }
         
     }
     
     func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
         return 50
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if int_type == 2{
             let bookTypeText = ("\(array_bookingType[row]) ")
             labelTimeSlot.text=bookTypeText
             strBookingType = bookTypeText
         }else{
             let capacityText = ("\(array_seatCapacity[row]) Seats")
             labelRoom.text=capacityText
             strSeatCapacity = "\(array_seatCapacity[row])"
         }
     }
}


