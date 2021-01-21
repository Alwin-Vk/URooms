//
//  BookingDetailsViewController.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class BookingDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet weak var buttonCancel: UIButton!
    
    // MARK: - Variables
    var data: BookingsListModel?
    var ref: DatabaseReference!
    var bookingDetails = [[String: String]]()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingTableView.tableFooterView = UIView(frame: .zero)
        bookingDetails.removeAll()
        ref  = Database.database().reference().child("Bookings")
        buttonCancel.isHidden = true
        
        if let allDetails = data {

            bookingDetails.append(["Booking ID :" : String(allDetails.bookingID)])
            bookingDetails.append(["Room Number :" : String(allDetails.className)])
            bookingDetails.append(["Time :" : allDetails.time])
            bookingDetails.append(["Booked By :" : String(allDetails.lecturer)])
            bookingDetails.append(["Lecturer ID:" : String(allDetails.lecturerId)])
            bookingDetails.append(["Purpose :" : String(allDetails.purpose)])
            bookingDetails.append(["No. of attendees :" : String(allDetails.noOfSeats)])
            bookingDetails.append(["Booked Date:" : String(allDetails.date)])
            
            if let userID = UserDefaults.standard.value(forKey: Key.Keys.k_User_Type_ID) as? String {
                if (allDetails.lecturerId == userID) {
                    buttonCancel.isHidden = false
                }
            }
        }
    }
    

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBookingButtonAction(_ sender: UIButton) {
        SwiftLoader.show(animated: true)
        ref.child(data?.bookingID ?? "").removeValue() {
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
                alertView.showSuccess("Removed", subTitle: "Your booking has been removed")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BookingDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetails", for: indexPath) as! BookingDetailsTableViewCell
        let bookingData = bookingDetails[indexPath.row]
        for detail in bookingData {
            cell.labelName.text = detail.key
            cell.labelDetail.text = detail.value
        }
        return cell
    }
}
