//
//  ChooseRoomViewController.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit

protocol RoomsBookingDelegate: AnyObject {
    func selectedRoom(_ room: RoomsModel)
}

class ChooseRoomViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var chooseRoomTableView: UITableView!
    
    // MARK: - Variables
    var roomDatas: [RoomsModel] = [RoomsModel]()
    var delegate: RoomsBookingDelegate!

    // Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Button Actions

}


extension ChooseRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Room", for: indexPath) as! RoomTableViewCell
        let data = roomDatas[indexPath.row]
        cell.imageViewRoom.setImage(data.image, placeholder: #imageLiteral(resourceName: "icon"))
        cell.roomNumber.text = data.roomID
        cell.noOfSeats.text = data.capacity
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectedRoom(roomDatas[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
