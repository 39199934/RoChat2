//
//  ClientsViewController.swift
//  RoChat2
//
//  Created by rolodestar on 2019/8/22.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import UIKit

class ClientsViewController: UIViewController {

    var clientsModel: ClientsModel!
    var actionMenu: UIAlertController!
    
    
    
    @IBOutlet weak var cClientsTable: UITableView!
    @IBAction func onClickedLink(_ sender: UIBarButtonItem) {
        //let ti = self.navigationController?.navigationItem.title ?? ""
        //sender.style = .
        switch clientsModel.isConnected {
        case true:
            
            clientsModel.disConnectToHost()
        case false:
           
            clientsModel.connectToHost()
        
        }
        
    }
    @IBAction func onClickedSearch(_ sender: UIBarButtonItem) {
    }
    @IBAction func onClickedAction(_ sender: UIBarButtonItem) {
        self.present(actionMenu, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientsModel = ClientsModel()
        clientsModel.delegate = self
        actionMenu = UIAlertController(title: "发送命令", message: "请选择命令类别", preferredStyle: .actionSheet)
        
        actionMenu.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        let requestClientsAction = UIAlertAction(title: "请求刷新客户端列表", style: .default) { (action) in
            let cmd = CommandModel.MakeRequestClientsCommand()
            let msgBody = MessageBodyModel(byCommand: cmd)
            let msg = MessageModel(byBody: msgBody)
            self.clientsModel.sendMessage(by: msg)
        }
        let requestUpdateMyselfAction = UIAlertAction(title: "请求更新本人信息", style: .default) { (action) in
            let cmd = CommandModel.MakeRequestUpdateSelfInfoCommand()
            let msgBody = MessageBodyModel(byCommand: cmd)
            let msg = MessageModel(byBody: msgBody)
            self.clientsModel.sendMessage(by: msg)
        }
        actionMenu.addAction(requestClientsAction)
        actionMenu.addAction(requestUpdateMyselfAction)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //refreshConnectStatus()
    }
    func refreshConnectStatus(){
        DispatchQueue.main.async {
            let isConnect = self.clientsModel!.isConnected
            if isConnect{
                DispatchQueue.main.async {
                    let str = " (\(self.clientsModel.clients.count)人)"
                    self.navigationItem.title = "信息" + str + ""
                }
            }else{
                DispatchQueue.main.async {
                    let str = " (\(self.clientsModel.clients.count)人)"
                    self.navigationItem.title = "信息" + str + " [未连接]"
                }
            }
            self.viewDidAppear(true)
        }
    }
//    func refreshConnectStatus(){
//
//            let isConnect = self.clientsModel!.isConnected
//            if isConnect{
//
//                    let str = " (\(self.clientsModel.clients.count)人)"
//                    self.navigationItem.title = "信息" + str + ""
//
//            }else{
//
//                    let str = " (\(self.clientsModel.clients.count)人)"
//                    self.navigationItem.title = "信息" + str + " [未连接]"
//
//            }
//            self.viewDidAppear(true)
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClientsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientsModel.clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdClientsCell")
        let cli =  clientsModel.clients[indexPath.row]
        cell?.textLabel?.text = cli.remoteUser.name
        return cell!
    }
    
    
}
extension ClientsViewController: ClientsModelDelegate{
    
    
    func clinetsLinkChanged(isConnected: Bool) {
        
      refreshConnectStatus()
    
    }
    
    func clientsModel(didAppend client: ClientModel) {
        return
    }
    
    func clientsListChanged() {
        cClientsTable.reloadData()
    }
    
  
    
}

extension ClientsViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "IdSegueShowClientView"){
            let des = segue.destination as! ClientViewController
            if let row = cClientsTable.indexPathForSelectedRow?.row{
                des.clientModel = clientsModel.clients[row]
            }
        }
    }
}
