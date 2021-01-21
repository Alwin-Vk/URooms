//
//  filterAreaListVC.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 29/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit


protocol findAreaProtocol : class {
    
    func slideTheMenu()
    func showViewController(_ viewController : UIViewController)
}
class filterAreaListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var tableView_ResultData: UITableView!
    var delegate : findAreaProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- Button Actions
    
    @IBAction func buttonClosePressed(_ sender: Any) {
        delegate.slideTheMenu()
       }
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findTableVC", for: indexPath)as! findTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
        
    }
}
