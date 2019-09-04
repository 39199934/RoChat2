//
//  ClientsModel.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/30.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import Foundation
import CocoaAsyncSocket



protocol ClientsModelDelegate {
    func clientsModel(didAppend client: ClientModel)
    func clientsListChanged()
    func clinetsLinkChanged(isConnected :Bool)
}
class ClientsModel:NSObject{
    var socketModel : SocketModel!
    
    var clients = [ClientModel](){
        didSet{
            delegate?.clientsListChanged()
        }
    }
    var delegate : ClientsModelDelegate?
    
    
    //长消息发送接收所需变量
    var msgTemp: MessageModel?
    var dataCatch: Data?
    //“”var is
    
    override init() {
        //init()
        //socket = SocketModel()
        
        super.init()
        socketModel = SocketModel()
        socketModel.socketModelDelegate = self
        //socketModel.max
        socketModel.connectToHost()
        clearAllClients()
        
        //
    }
    var isConnected:Bool {
        get{
            return socketModel.isConnected
        }
    }
    
    
    
}

extension ClientsModel{
    public func connectToHost(){
        socketModel.connectToHost()
    }
    public func disConnectToHost(){
        socketModel.disConnectToHost()
    }
    
}
//clients socket 代理操作
extension ClientsModel: SocketModelDelegate{
    func socketModel(_ sock: SocketModel, didConnectToHost host: String, port: UInt16) {
        delegate?.clinetsLinkChanged(isConnected: true)
    }
    
    func socketModelDidDisconnect(_ sock: SocketModel, withError err: Error?) {
        delegate?.clinetsLinkChanged(isConnected: false)
    }
    
    func socketModel(_ sock: SocketModel, messageModelReadyRead: MessageModel) {
        //let msg = MessageModel.MakeMessageModel(byData: data)
        //continue ......
        let client = searchClient(byRemoteMacAddress: (messageModelReadyRead.body?.sender.macAddress)!)
        client?.appendMessage(msg: messageModelReadyRead)
    }
    
    func socket(_ sock: SocketModel, messageModelWritten: MessageModel) {
        let client = searchClient(byRemoteMacAddress: (messageModelWritten.body?.reciver.macAddress)!)
        client?.appendMessage(msg: messageModelWritten)
    }
    
    
}
/*extension ClientsModel:GCDAsyncSocketDelegate{
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        //isConnected = true
        
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        //isConnected = false
        
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
    }
    //socket
    func socket(_ sock: GCDAsyncSocket, didWritePartialDataOfLength partialLength: UInt, tag: Int) {
        print ("partial length = \(partialLength).the tag =\(tag)")
    }
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print ("did write data .the tag =\(tag),")
    }
    
    
}*/
//用于客户端的收发信息
extension ClientsModel{
    func sendMessage(to client:ClientModel,by msg:String){
        let msgBody = MessageBodyModel(from: appDelegate.setting.userInfo.getSendUserStruct(), to: client.remoteUser.getSendUserStruct(), byMessageContent: msg, useType: .message,useBak: "");
        print(msgBody.messageContent)
        let msgModel = MessageModel(byBody: msgBody)
        //client.messages.append(msgModel)
        socketModel.send(byMessageModel: msgModel)
    }
    func sendMessage(by msg:MessageModel)
    {
//        if let client = searchClient(byUserMac: (msg.body?.reciver.macAddress)!){
//            client.appendMessage(msg: msg.getMessageSendStruct())
//            socketModel.write(by: msg.encodingMessageSendStruct())
//        }
        socketModel.send(byMessageModel: msg)
        
    }
}
//对客户端进行增删改查操作
extension ClientsModel{
    func appendClient(client: ClientModel){
        if client.clients == nil{
            client.clients = self
        }
        self.clients.append(client)
        //client.delegate = self
        //client.delegate = self
        delegate?.clientsModel(didAppend: client)
        
    }
    func removeClient(client:ClientModel){
        let index = searchClient(byClient: client)
        if index != nil{
            clients.remove(at: index!)
        }
        
    }
    func searchClient(byClient client: ClientModel) -> Array<ClientModel>.Index?{
        return clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.macAddress == client.remoteUser.macAddress{
                return true
            }
            else {
                return false
            }
        })
    }
    func searchClient(byUser user: UserModel) -> ClientModel?{
        
        let index = clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.macAddress == user.macAddress{
                return true
            }
            else {
                return false
            }
        })
        if index != nil{
            return clients[index!]
        }else{
            return nil
        }
    }
    func searchClient(byRemoteMacAddress address: String) -> ClientModel?{
        
        let index = clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.macAddress == address{
                return true
            }
            else {
                return false
            }
        })
        if index != nil{
            return clients[index!]
        }else{
            return nil
        }
    }
    /*func searchClient(byUserUuid uuid: UUID) -> ClientModel?{
        
        let index = clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.uuid == uuid{
                return true
            }
            else {
                return false
            }
        })
        if index != nil{
            return clients[index!]
        }else{
            return nil
        }
    }*/
    func searchClient(byUserMac mac_address: String) -> ClientModel?{
        
        let index = clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.macAddress == mac_address{
                return true
            }
            else {
                return false
            }
        })
        if index != nil{
            return clients[index!]
        }else{
            return nil
        }
    }
    /*
    func searchClient(byUser user: UserModel) -> ClientModel?{
        
        let index = clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.uuid == user.uuid{
                return true
            }
            else {
                return false
            }
        })
        if index != nil{
            return clients[index!]
        }else{
            return nil
        }
    }
    func searchClient(byUserUuid uuid: UUID) -> ClientModel?{
        
        let index = clients.firstIndex(where: { (cli) -> Bool in
            if cli.remoteUser.uuid == uuid{
                return true
            }
            else {
                return false
            }
        })
        if index != nil{
            return clients[index!]
        }else{
            return nil
        }
    }*/
    func updateClient(client: ClientModel){
        let index = searchClient(byClient: client)
        if index != nil{
            clients[index!] = client
        }
    }
    func refreshAllClients(clients: [ClientModel]){
        self.clients.removeAll()
        self.clients = clients
        let serverClient = ClientModel.MakeServerClient()
        serverClient.clients = self
        appendClient(client: serverClient)
        //self.clients.append(ClientModel.MakeServerClient())
//        for i in 0 ..< self.clients.count{
//            //self.clients[i].delegate = self
//        }
    }
    func clearAllClients(){
        self.clients.removeAll()
        //self.clients = clients
        let serverClient = ClientModel.MakeServerClient()
        serverClient.clients = self
        appendClient(client: serverClient)
        //        for i in 0 ..< self.clients.count{
        //            //self.clients[i].delegate = self
        //        }
    }
    
}


//继承想着委托
//extension ClientsModel: ClientModelDelegate{
//    func clientModel(clientModel: ClientModel, sendBy message: String) {
//        socket.writeMessge(by: message, to: clientModel.remoteUser)
//    }
//
//
//}
//extension ClientsModel: SocketModelDelegate{
//    func SocketModel(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
//        isConnected = true
//    }
//
//    func SocketModel(didUpdateMessages messages: [MessageModel]) {
//        return
//    }
//
//    func SocketModel(didAppend newMessage: MessageModel) {
//
//        let sen = searchClient(byUser: newMessage.reciver)
//        if sen != nil
//        {
//            sen?.appendMessage(msg: newMessage)
//        }
//        let rec = searchClient(byUser: newMessage.sender)
//        if rec != nil{
//            rec?.appendMessage(msg: newMessage)
//        }
//    }
//
//
//}
