//
//  UserProfileController.swift
//  SACDigital
//
//  Created by Bruno Vieira on 29/11/2018.
//  Copyright © 2018 Bruno Vieira. All rights reserved.
//

import UIKit

class UserProfileController: UITableViewController {
    
    var friend: Friend? {
        didSet {
            
        }
    }
    var dataTable =
        [
            [
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "recent-1"), title: "", color: UIColor()),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "recent-1"), title: "", color: UIColor()),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "recent-1"), title: "", color: UIColor())
            ],
            [
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "like"), title: "FeedBack", color: UIColor(red: 0/255, green: 94/255, blue: 184/255, alpha: 1.0)),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "message"), title: "Messenger", color: UIColor(red: 252/255, green: 159/255, blue: 91/255, alpha: 1.0)),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "info"), title: "Sobre", color: UIColor(red: 242/255, green: 100/255, blue: 25/255, alpha: 1.0)),
                ConfigureCellAtendimento(image: #imageLiteral(resourceName: "sair"), title: "Sair", color: UIColor(red: 45/255, green: 216/255, blue: 129/255, alpha: 1.0)),
                ]
        ]
    
    var cellid = "perfilcell"
    let perfilCell = "perfilcellasd"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect(), style: .grouped)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(ProfileViewCell.self, forCellReuseIdentifier: perfilCell)
        self.tableView.register(OptionsViewCell.self, forCellReuseIdentifier: cellid)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataTable.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
//        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
//
//        let label = UILabel()
//        label.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
//        label.textColor = .darkGray
//        label.text = "CONTA"
//        view.addSubview(label)
//
//        let lineviewbottom = UIView()
//        lineviewbottom.backgroundColor = .lightGray
//        view.addSubview(lineviewbottom)
//        lineviewbottom.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(), size: .init(width: 0, height: 0.5))
//
//        let lineviewtop = UIView()
//        lineviewtop.backgroundColor = .lightGray
//        view.addSubview(lineviewtop)
//        lineviewtop.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(), size: .init(width: 0, height: 0.5))
//
//        label.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 5, right: 0) )
//        if section != 0 {
//            return view
//        }
//        return UIView()
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTable[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row < 1 {
                return 400
            } else {
                return 60
            }
        case 1:
            return 45
        default:
            return 45
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.perfilCell, for: indexPath) as! ProfileViewCell
            switch indexPath.row {
            case 0:
                cell.setupImageProfile()
                cell.user = friend
                return cell
            case 1:
                cell.user = friend
                cell.setupDados()
                return cell
            case 2:
                
                
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! OptionsViewCell
            let dataCell = dataTable[indexPath.section][indexPath.row]
            
            cell.setImageAndTitle(dataCell.image!, dataCell.title!, color: dataCell.color!)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
