//
//  ChatMessageViewController.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/28.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //var datasource:
    @IBOutlet weak var cTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clientModel == nil{
            return 0
        }
        return (clientModel?.messages.count)!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.cellForRow(at: indexPath)
//        if cell != nil{
//            if cell!.frame.height < 85{
//                return 85
//            }else{
//                return cell!.frame.height
//            }
//        }else{
//            return 85
//        }
//        
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: ClientSendCell
        
        let msg = clientModel?.messageDatabase[indexPath.row]
        if msg!.isSender{
            cell = tableView.dequeueReusableCell(withIdentifier: "IdChatCellSendForSend")! as! ClientSendCell
            
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "IdChatCellSendForSend")! as! ClientSendCell
        }
        cell.viewMsg(msg: (clientModel?.messageDatabase[indexPath.row])!)
        
       
        
        return cell
    }
    //return cell
    
  

    @IBAction func onSendMessageEditingDidEnd(_ sender: UITextField) {
//        if let msg = cSendMessage.text{
//            clientModel?.sendMessage(by: msg)
//            cSendMessage.text = ""
//            cChatMessageTable.reloadData()
        
//        }
    }
    
    var clientModel: ClientModel?
    @IBOutlet weak var cChatMessageTable: UITableView!
    @IBOutlet weak var cSendMessage: UITextField!
    @IBAction func onClickedPlus(_ sender: UIButton) {
        cSendMessage.text = "511111111111111111111111111111111111112222222222222222222222222222222233333333333333333333333333333333333334444444444444444444444444445"
        onClickedBtnSend(sender)
    }
    @IBAction func onClickedBtnSend(_ sender: UIButton) {
        if let msg = cSendMessage.text{
            clientModel?.sendMessage(by: msg)
            cSendMessage.text = ""
            cChatMessageTable.reloadData()
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        clientModel?.delegate = self
        // Do any additional setup after loading the view.
        self.navigationItem.title = clientModel?.remoteUser.name
//        cTable.estimatedRowHeight = 120
//        cTable.rowHeight = UITableView.automaticDimension
        //cTable.backgroundColor = UIColor.blue
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
extension ClientViewController: ClientModelDelegate{
    func clientModel(clientModel: ClientModel, sendBy message: String) {
        return
    }
    
    func clientModelMessageIsChanged(clientModel: ClientModel) {
        DispatchQueue.main.async {
            self.cTable.reloadData()
        }
        
    }
    
    
}
