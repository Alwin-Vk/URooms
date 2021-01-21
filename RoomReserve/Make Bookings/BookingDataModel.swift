//
//  BookingDataModel.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import Foundation

struct RoomsModel {
    var roomID: String
    var capacity: String
    var description: String
    var image: String
    var bookings: [String: AnyObject]?
    
    init(_ details: [String: AnyObject]) {
        self.roomID = Utils.sharedInstance.getStringValue("name", dictionary: details)
        self.capacity = Utils.sharedInstance.getStringValue("capacity", dictionary: details)
        self.description = Utils.sharedInstance.getStringValue("description", dictionary: details)
        self.image = Utils.sharedInstance.getStringValue("image", dictionary: details)
        if let bookedSlots = details["bookings"] as? [String: AnyObject] {
            self.bookings = bookedSlots
        }
    }
}
