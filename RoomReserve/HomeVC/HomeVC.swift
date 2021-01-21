//
//  HomeVC.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 22/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class HomeVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeSearchBar: UISearchBar!
    @IBOutlet weak var constraintHeightReports: NSLayoutConstraint!
    @IBOutlet weak var viewReports: UIView!
    @IBOutlet weak var buttonBookRoom: UIButton!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var constraintBottomFilterContainer: NSLayoutConstraint!
    
    // MARK: - Variables
    var menuVC = DrawerMenuViewController()
    var ref: DatabaseReference!
    var databaseHandle : DatabaseHandle!
    var roomTypesRef: DatabaseReference!
    var bookingsData: [BookingsListModel] = [BookingsListModel]()
    var filteredData: [BookingsListModel] = [BookingsListModel]()

    private var roomsAvailable: Set = Set<String>()
    private var modulesAvailable: Set = Set<String>()
    private var lecturersAvailable: Set = Set<String>()
    private var selectedIndex = -1
    private var filterPickerData: [String] = [String]()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        roomTypesRef  = Database.database().reference().child("Bookings")
        addMenuView()
        setUserType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRoomType()
    }
    
    // MARK: - Custom Functions
    func setUserType() {
        if let userType = UserDefaults.standard.value(forKey: Key.Keys.k_User_Type) as? String {
            if userType == "student" {
                buttonBookRoom.isHidden = true
               // viewReports.isHidden = true
               // constraintHeightReports.constant = 0
            }
        }

    }
    
    func addMenuView() {
        menuVC = UIStoryboard.RoomBooking.DrawerMenuVC() as! DrawerMenuViewController
        menuVC.view.frame = self.view.frame
        self.view.addSubview(menuVC.view)
    }

    func getRoomType() {
        SwiftLoader.show(animated: true)
        self.bookingsData.removeAll()
        roomsAvailable.removeAll()
        modulesAvailable.removeAll()
        lecturersAvailable.removeAll()
        self.homeTableView.reloadData()
        var tempData = [BookingsListModel]()
        var handle: UInt = 0
        handle =  roomTypesRef.observe(.value, with: { snapshot in
            SwiftLoader.hide()
            if let datas = snapshot.value as? [String: [String: AnyObject]] {
                for data in datas {
                    let tempValue = BookingsListModel(data.value, bookingID: data.key)
                    tempData.append(tempValue)
                    self.roomsAvailable.insert(tempValue.className)
                    self.modulesAvailable.insert(tempValue.module)
                    self.lecturersAvailable.insert(tempValue.lecturer)
                }
            }
            tempData.sort(){$0.dateObject! < $1.dateObject!}
            self.bookingsData = tempData.filter(){$0.dateObject! > Calendar.current.date(byAdding: .day, value: 0, to: Date())!}
            self.filteredData = self.bookingsData
            self.homeTableView.reloadData()
            self.roomTypesRef.removeObserver(withHandle: handle)
        }) { (error) in
            SwiftLoader.hide()
             print(error.localizedDescription)
        }
    }
    
    func showPicker() {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomFilterContainer.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissPicker() {
        UIView.animate(withDuration: 0.3) {
            self.constraintBottomFilterContainer.constant = -1500
            self.view.layoutIfNeeded()
        }
    }
    
    func resetData() {
        selectedIndex = -1
        filteredData = bookingsData
        homeTableView.reloadData()
        homeCollectionView.reloadData()
    }
        
    // MARK: - Button Actions

    @IBAction func menuButtonAction(_ sender: UIButton) {
        menuVC.menuTapped()
    }
    
    @IBAction func ButtonBookNowPressed(_ sender: Any) {
        let roomReserveVC = UIStoryboard.RoomBooking.MakeBookingVC()
        self.navigationController?.pushViewController(roomReserveVC, animated: true)

    }
    
    @IBAction func getReportButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if selectedIndex == 0 {
                resetData()
                return
            }
            selectedIndex = 0
            filterPickerData = Array(roomsAvailable)
            filterPicker.reloadAllComponents()
            showPicker()
        case 1:
            if selectedIndex == 1 {
                resetData()
                return
            }
            selectedIndex = 1
            filterPickerData = Array(modulesAvailable)
            filterPicker.reloadAllComponents()
            showPicker()
        case 2:
            if selectedIndex == 2 {
                resetData()
                return
            }
            selectedIndex = 2
            filterPickerData = Array(lecturersAvailable)
            filterPicker.reloadAllComponents()
            showPicker()
        default:
            return
        }
    }
    
    @IBAction func dismissFilterButtonAction(_ sender: UIButton) {
        dismissPicker()
    }
    
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let selectValue = filterPickerData[filterPicker.selectedRow(inComponent: 0)]
        dismissPicker()
        
        switch selectedIndex {
        case 0:
            filteredData = bookingsData.filter(){$0.className == selectValue}
            homeTableView.reloadData()
            homeCollectionView.reloadData()
        case 1:
            filteredData = bookingsData.filter(){$0.module == selectValue}
            homeTableView.reloadData()
            homeCollectionView.reloadData()
        case 2:
            filteredData = bookingsData.filter(){$0.lecturer == selectValue}
            homeTableView.reloadData()
            homeCollectionView.reloadData()
        default:
            return
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Schedules", for: indexPath) as! SchedulesTableViewCell
        let data = filteredData[indexPath.row]
        cell.nameLabel.text = data.purpose
        cell.roomNumberLabel.text = data.className
        cell.timeLabel.text = data.time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filteredData[indexPath.row]
        let bookingDetailVC = UIStoryboard.RoomBooking.BookingDetailsVC() as! BookingDetailsViewController
        bookingDetailVC.data = data
        self.navigationController?.pushViewController(bookingDetailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReportData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reports", for: indexPath) as! ReportsCollectionViewCell
        let data = ReportData[indexPath.row]
        cell.reportIconImageView.image = UIImage(named: data.icon)
        cell.reportNameLabel.text = data.type
        cell.reportButton.tag = indexPath.row
        
        if selectedIndex == indexPath.row {
            cell.viewContainer.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.8392156863, blue: 0.6549019608, alpha: 1)
        } else {
            cell.viewContainer.backgroundColor = .white
        }
        return cell
    }
        
}

extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterPickerData[row]
    }
}
