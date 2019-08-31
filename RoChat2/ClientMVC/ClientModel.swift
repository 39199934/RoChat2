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
    //func client
    func clientModelMessageIsChanged(clientModel: ClientModel)
}
class ClientModel{
    var clients: ClientsModel?
    typealias messageDatabaseType = (isSender: Bool,photo: UIImage?,type: MessageModelType,content: Any,name: String)
    var remoteUser: UserModel
    var messages: [MessageModel]  {
        didSet{
            messageDatabase = getMessageList()
            delegate?.clientModelMessageIsChanged(clientModel: self)
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
        let mineMac = appDelegate.setting.userInfo.macAddress
        var rtMsgDatabase = [messageDatabaseType]()
        for msg in messages{
            let isSend = mineMac == msg.body!.reciver.macAddress ? true : false
            let msgPhoto = isSend ? appDelegate.setting.userInfo.getPhoto() : remoteUser.getPhoto()
            let msgType = msg.body?.type
            let msgContent  = msg.body?.messageContent
            let msgName = isSend ? appDelegate.setting.userInfo.name : remoteUser.name
            rtMsgDatabase.append((isSend,msgPhoto,msgType!,msgContent,msgName))
        }
        return rtMsgDatabase
    }
    func sendMessage(by message: String)
    {
        clients?.sendMessage(to: self, by: message)
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
            if msg.body!.messageUuid == uuid{
                return true
            }
            return false
            
        }
        return rtIndex
    }
    
    func updateMessage(from newMessage:MessageModel,toReplace oldMessage:MessageModel){
        let index = searchMessage(by: oldMessage.body!.messageUuid)
        if index != nil{
            messages[index!] = newMessage
        }
    }
    
}
extension ClientModel{
    static func MakeServerClient() -> ClientModel{
        return ClientModel(remoteUser: UserModel.MakeServerUser())
    }
}
