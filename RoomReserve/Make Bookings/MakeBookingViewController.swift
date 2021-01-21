//
//  MakeBookingViewController.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SkyFloatingLabelTextField

class MakeBookingViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var labelAreaType: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRoom: UILabel!
    @IBOutlet weak var labelTimeSlot: UILabel!
    @IBOutlet weak var viewTimeSlot: UIView!
    @IBOutlet weak var viewRoom: UIView!
    @IBOutlet weak var constraintBottomDateContainer: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomAreaContainer: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableViewArea: UITableView!
    @IBOutlet weak var buttonBooking: UIButton!
    @IBOutlet weak var constraintBottomTimeSlotContainer: NSLayoutConstraint!
    @IBOutlet weak var pickerTimeSlot: UIPickerView!

    @IBOutlet weak var labelModule: UILabel!
    @IBOutlet weak var textFieldPurpose: SkyFloatingLabelTextField!
    
    @IBOutlet weak var viewPurpose: UIView!
    @IBOutlet weak var viewModel: UIView!
    
    // MARK: - Variables
    var databaseRef: DatabaseReference!
    var bookRoomRef: DatabaseReference!
    
    var unfilteredRoomsData: [String: [[String: AnyObject]]] = [String: [[String: AnyObject]]]()
    var roomsData: [String: [RoomsModel]] = [String: [RoomsModel]]()
    var areaTypes: [String] = [String]()
    var selectedRoomData: RoomsModel?
    private var timeSlots = [
        "7:00 AM - 8:00 AM",
        "8:00 AM - 9:00 AM",
        "9:00 AM - 10:00 AM",
        "10:00 AM - 11:00 AM",
        "11:00 AM - 12:00 PM",
        "12:00 PM - 1:00 PM",
        "1:00 PM - 2:00 PM",
        "2:00 PM - 3:00 PM",
        "3:00 PM - 4:00 PM",
        "4:00 PM - 5:00 PM",
        "5:00 PM - 6:00 PM",
    ]
    
    private var userModules = [String]()
    private var pickerData = [String]()
    private var filteredSlots: [String] = [String]()
    private var isSlotsSelected = false
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef  = Database.database().reference().child("Room")
        bookRoomRef  = Database.database().reference().child("Bookings")
        getRooms()
        initialConfigurations()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Functions
    
    func initialConfigurations() {
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        viewRoom.isHidden = true
        viewTimeSlot.isHidden = true
        buttonBooking.isEnabled = false
        
        textFieldPurpose.styleField2()
        
        if let modules = UserDefaults.standard.stringArray(forKey: Key.Keys.k_User_Modules) {
            userModules = modules
        }
        
    }
    
    func getRooms() {
        areaTypes.removeAll()
        roomsData.removeAll()
        var handle: UInt = 0
        handle =  databaseRef.observe(.value, with: { snapshot in
            if let datas = snapshot.value as? [String: [[String: AnyObject]]] {
                let keys: [String] = datas.map({ $0.key })
                self.unfilteredRoomsData = datas
                self.areaTypes = keys
                for data in datas {
                    var roomData = [RoomsModel]()

                    for room in data.value {
                        roomData.append(RoomsModel(room))
                    }
                    self.roomsData[data.key] = roomData
                }
            }
            self.tableViewArea.reloadData()
            self.databaseRef.removeObserver(withHandle: handle)
        }) { (error) in
             print(error.localizedDescription)
        }
    }
    
    func dismissAreaView() {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomAreaContainer.constant = 1500
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissDateView() {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomDateContainer.constant = -1500
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissTimeSlot() {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomTimeSlotContainer.constant = 1500
            self.view.layoutIfNeeded()
        }
    }

    
    func setDate() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "dd-MM-yyyy"

        labelDate.text = dateFormatter.string(from: datePicker.date)
    }

    // MARK: - Functions
    func validateFields() -> Bool {
        self.dismissKeyboard()
        var validation = true
        if labelModule.text!.isEmpty || labelModule.text == "Select Module" {
            validation = false
            SCLAlertView().showError("Fill all details", subTitle: "Please select a module")
        } else if labelTimeSlot.text!.isEmpty || labelTimeSlot.text == "Select Time Slot" {
            validation = false
            SCLAlertView().showError("Fill all details", subTitle: "Please select a time slot")
        }
        else if labelDate.text!.isEmpty || labelDate.text == "Select Date" {
            validation = false
            SCLAlertView().showError("Fill all details", subTitle: "Please select a Date ")
        }
        if ((textFieldPurpose.text?.isEmpty)!) {
            textFieldPurpose.setError("Please enter purpose")
            validation = false
        }
        return validation
    }
    
    func getRoomDetailsForDatabaseInsert() -> [String: AnyObject]? {
        if let existingBookingData = selectedRoomData?.bookings {
            var tempExstData = selectedRoomData
            var status = 0
            for bookDatas in existingBookingData {
                if bookDatas.key == labelDate.text! {
                    status = 1
                    var newBookData = existingBookingData
                    if var updatedData = bookDatas.value as? [String] {
                        updatedData.append(labelTimeSlot.text!)
                        newBookData[bookDatas.key] = updatedData as AnyObject
                        return newBookData
                    }
                }
            }
            if status == 0 {
                var newBookData = existingBookingData
                newBookData[labelDate.text!] = [
                    labelTimeSlot.text!
                ] as AnyObject
                return newBookData
            }
        } else {
            let bookingData = [
                labelDate.text!: [
                    labelTimeSlot.text!
                ]
            ]
            return bookingData as [String : AnyObject]
        }
        return nil
    }

    func updateTimeSlots() {
        filteredSlots.removeAll()
        filteredSlots = timeSlots
        if let bookingData = selectedRoomData?.bookings as? [String: [String]] {
            for booking in bookingData {
                if (booking.key == labelDate.text!) {
                    for slot in booking.value {
                        for unfilteredSlot in timeSlots {
                            if slot == unfilteredSlot {
                                filteredSlots.removeAll(where: {$0 == slot})
                            }
                        }
                    }
                }
            }

        }
        pickerTimeSlot.reloadComponent(0)
    }

    // MARK: - Button Actions
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseAreaTypeAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomAreaContainer.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func chooseDateButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomDateContainer.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func chooseRoomButtonAction(_ sender: UIButton) {
        if let roomData = roomsData[labelAreaType.text ?? ""] {
            let roomSelectVC = UIStoryboard.RoomBooking.ChooseRoomVC() as! ChooseRoomViewController
            roomSelectVC.roomDatas = roomData
            roomSelectVC.delegate = self
            self.navigationController?.pushViewController(roomSelectVC, animated: true)
        }
    }
    
    @IBAction func chooseTimeSlot(_ sender: Any) {
        pickerData = filteredSlots
        isSlotsSelected = true
        pickerTimeSlot.reloadAllComponents()
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomTimeSlotContainer.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func makeBookingButtonAction(_ sender: UIButton) {
        if let userID = UserDefaults.standard.value(forKey: Key.Keys.k_User_Type_ID) as? String, let userName = UserDefaults.standard.value(forKey: Key.Keys.k_UserName) as? String {
            if validateFields() {
                SwiftLoader.show(animated: true)
                let bookingDetails = [
                    "lecturerID": userID,
                    "lecturerName": userName,
                    "module": labelModule.text!,
                    "purpose": textFieldPurpose.text!,
                    "areaType": labelAreaType.text ?? "",
                    "room": selectedRoomData?.roomID,
                    "time": labelTimeSlot.text ?? "",
                    "date": labelDate.text ?? "",
                    "seats": selectedRoomData?.capacity ?? ""
                ]
                
                guard let path = labelAreaType.text else { return }
                let index = roomsData[path]?.firstIndex{$0.roomID == selectedRoomData?.roomID}
                var tempData = unfilteredRoomsData[labelAreaType.text!]
                if let newData = getRoomDetailsForDatabaseInsert(), index != nil, tempData != nil {
                    tempData![index!]["bookings"] = newData as AnyObject
                    databaseRef.child(path).setValue(tempData)
                }
                
                bookRoomRef.childByAutoId().setValue(bookingDetails) {
                  (error:Error?, ref:DatabaseReference) in
                    SwiftLoader.hide()
                    if let error = error {
                        SCLAlertView().showError("Error", subTitle: error.localizedDescription, closeButtonTitle: "Ok")
                    } else {
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.addButton("Ok") {
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertView.showSuccess("Room booked successfully", subTitle: "Room \(self.selectedRoomData?.roomID ?? "") booked for \(self.labelDate.text ?? "") from \(self.labelTimeSlot.text ?? "")")
                    }
                }

            }
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        dismissAreaView()
        dismissDateView()
        dismissTimeSlot()
    }
    
    @IBAction func selectDateButton(_ sender: Any) {
        setDate()
        dismissDateView()
        selectedRoomData = nil
        labelRoom.text = "Select Room"
        labelTimeSlot.text = "Select Time Slot"
        viewTimeSlot.isHidden = true
        buttonBooking.isEnabled = false
    }
    
    @IBAction func timeSlotButtonAction(_ sender: UIButton) {
        if isSlotsSelected {
            labelTimeSlot.text = filteredSlots[pickerTimeSlot.selectedRow(inComponent: 0)]
            buttonBooking.isEnabled = true
        } else {
            labelModule.text = userModules[pickerTimeSlot.selectedRow(inComponent: 0)]
        }
        dismissTimeSlot()
    }
    
    @IBAction func selectModuleButtonAction(_ sender: UIButton) {
        pickerData = userModules
        pickerTimeSlot.reloadAllComponents()
        isSlotsSelected = false
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomTimeSlotContainer.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - TableView Delegates

extension MakeBookingViewController: UITableViewDataSource, UITableViewDelegate {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaTypes.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaviewcell", for: indexPath)as! AreaTableViewCell
        cell.clipsToBounds = true
        cell.labelArea.text = areaTypes[indexPath.row]
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        labelAreaType.text = areaTypes[indexPath.row]
        dismissAreaView()
        selectedRoomData = nil
        labelRoom.text = "Select Room"
        labelTimeSlot.text = "Select Time Slot"
        viewTimeSlot.isHidden = true
        buttonBooking.isEnabled = false
        viewRoom.isHidden = false
    }
}

extension MakeBookingViewController: RoomsBookingDelegate {
    func selectedRoom(_ room: RoomsModel) {
        labelRoom.text = room.roomID
        selectedRoomData = room
        viewTimeSlot.isHidden = false
        labelTimeSlot.text = "Select Time Slot"
        buttonBooking.isEnabled = true
        self.updateTimeSlots()
    }
}

extension MakeBookingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

// MARK: - TextField Delegates

extension MakeBookingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let myField = textField as? SkyFloatingLabelTextField {
            myField.setError("")
        }
    }
}
