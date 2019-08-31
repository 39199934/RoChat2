//
//  ClientModel.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/30.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import Foundation
import UIKit

protocol ClientModelDelegate {
    func clientModel(clientModel: ClientModel,sendBy message: String)
}
class ClientModel{
    typealias messageDatabaseType = (isSender: Bool,photo: UIImage?,type: MessageModelType,content: Any,name: String)
    var remoteUser: UserModel
    var messages: [MessageModel]  {
        didSet{
            messageDatabase = getMessageList()
        }
    }
    var delegate: ClientModelDelegate?
    var messageDatabase: [messageDatabaseType]
    init(remoteUser: UserModel) {
        self.remoteUser = remoteUser
        messages = [MessageModel]()
        delegate = nil
        messageDatabase = [messageDatabaseType]()
    }
    private func getMessageList() -> [messageDatabaseType]{
        let mineMac = appDelegate.settingInfo.userInfo.macAddress
        var rtMsgDatabase = [messageDatabaseType]()
        for msg in messages{
            let isSend = mineMac == msg.sender.macAddress ? true : false
            let msgPhoto = isSend ? UIImage(data: msg.sender.photo) : UIImage(data: msg.reciver.photo)
            let msgType = msg.type
            let msgContent  = msg.messageContent
            let msgName = isSend ? msg.sender.name : msg.reciver.name
            rtMsgDatabase.append((isSend,msgPhoto,msgType,msgContent,msgName))
        }
        return rtMsgDatabase
    }
    func sendMessage(by message: String)
    {
        delegate?.clientModel(clientModel: self,sendBy: message)
    }
    
    func appendMessage(msg: MessageModel){
        messages.append(msg)
    }
    func removeMessage(by uuid: UUID){
        let index = searchMessage(by: uuid)
        if index != nil{
            messages.remove(at: index!)
        }
        
    }
    func searchMessage(by uuid:UUID) -> Array<MessageModel>.Index?{
        let rtIndex = messages.lastIndex { (msg) -> Bool in
            if msg.messageUuid == uuid{
                return true
            }
            return false
            
        }
        return rtIndex
    }
    
    func updateMessage(from newMessage:MessageModel,toReplace oldMessage:MessageModel){
        let index = searchMessage(by: oldMessage.messageUuid)
        if index != nil{
            messages[index!] = newMessage
        }
    }
    
}
