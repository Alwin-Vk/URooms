//
//  HomeModel.swift
//  RoomReserve
//
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import Foundation

struct BookingsListModel {
    var module: String
    var purpose: String
    var areaType: Int
    var time: String
    var lecturer: String
    var lecturerId: String
    var noOfSeats: String
    var className: String
    var date: String
    var bookingID: String
    var dateObject: Date?
    
    init(_ data: [String: AnyObject], bookingID: String) {
        self.module = Utils.sharedInstance.getStringValue("module", dictionary: data)
        self.purpose = Utils.sharedInstance.getStringValue("purpose", dictionary: data)
        self.areaType = Utils.sharedInstance.getIntegerValue("areaType", dictionary: data)
        self.lecturer = Utils.sharedInstance.getStringValue("lecturerName", dictionary: data)
        self.time = Utils.sharedInstance.getStringValue("time", dictionary: data)
        self.lecturerId = Utils.sharedInstance.getStringValue("lecturerID", dictionary: data)
        self.noOfSeats = Utils.sharedInstance.getStringValue("seats", dictionary: data)
        self.className = Utils.sharedInstance.getStringValue("room", dictionary: data)
        self.date = Utils.sharedInstance.getStringValue("date", dictionary: data)
        self.bookingID = bookingID
        self.dateObject = getDateFromString(self.date)
    }
    
    
    func getDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString)
    }
    
}

struct ReportsModel {
    var type: String
    var icon: String
    var id: Int
    
    init(type: String, icon: String, id: Int) {
        self.type = type
        self.icon = icon
        self.id = id
    }
}

let ReportData = [
    ReportsModel(type: "By Room", icon: "roomIcon", id: 1),
//    ReportsModel(type: "By Course", icon: "courseIcon", id: 2),
    ReportsModel(type: "By Module", icon: "moduleIcon", id: 3),
    ReportsModel(type: "By Lecturer", icon: "lecturerIcon", id: 4),
]



