//
//  SettingViewController.swift
//  RoChat2
//
//  Created by rolodestar on 2019/8/23.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    //var setting : SettingModel!
    @IBOutlet weak var cSettingTable: UITableView!
    
    
    private  let CellTypeNumber: Int = 2
    var settingSegue: [Int: (title: String,id: String)] = [
         0:("本地用记信息设置","IdSettingLocalUserCell"),
        1:("地址端口设置","IdSettingSocketCell"),//: "IdSegueIpPort",
        2:("其他设置","IdSettingSocketCell")//: "IdSegueOther"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting = appDelegate.setting

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        cSettingTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingSegue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let segue = settingSegue[indexPath.row]!
            let id = segue.id
            let cellOri = (tableView.dequeueReusableCell(withIdentifier: id))
            let cell = cellOri as! SettingLocalUserCell
            cell.cUserImage.image = appDelegate.setting.userInfo.getPhoto()
            cell.cUserName.text = appDelegate.setting.userInfo.name
            cell.cUserIp.text = appDelegate.setting.userInfo.macAddress
            cell.cUserImage.contentMode = .scaleAspectFit
            cell.accessoryType  = .disclosureIndicator
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: settingSegue[indexPath.row]!.id)
            cell?.textLabel?.text = settingSegue[indexPath.row]!.title
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 150
        }else{
            return 50
        }
    }
    
}
