//
//  MessageModel.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/30.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import Foundation
import UIKit
let MESSAGE_ENCODING = String.Encoding.utf8

enum MessageModelType: String,Codable{
    case message = "message"
    case command = "command"
    case image = "image"
    case link = "link"
    case error = "error"
    
}
struct SendMessageStruct: Codable{
    //var senderUuid = UUID()
    //var reciverUuid = UUID()
    var senderMac = "55555"
    var reciverMac = "55555"
    var date = Date()
    var type = MessageModelType.message
    var messageContent = String()
    
    var messageUuid = UUID()
    init(){
        
    }
}
struct MessageModel: Codable{
    
   
    var date: Date
    var isUsed: Bool = false
    var sender: UserModel
    var reciver: UserModel
    var type: MessageModelType = .message
    var messageContent: String = String("empty message")//.data(using: MESSAGE_ENCODING)!
    var messageUuid: UUID
    
    init(from: UserModel = appDelegate.settingInfo.userInfo,to: UserModel,byData content:String,use type:MessageModelType)
    {
        self.date = Date()
        self.isUsed = false
        self.sender = from
        self.reciver = to
        self.type = type
        self.messageContent = content
        self.messageUuid = UUID()
        
    }
    //初始化为消息
    init(from: UserModel = appDelegate.settingInfo.userInfo,to: UserModel,byMessage content:String){
        self.date = Date()
        self.isUsed = false
        self.sender = from
        self.reciver = to
        self.type = .message
        self.messageContent = content
         self.messageUuid = UUID()
        
        
    }
    init(from: UserModel = appDelegate.settingInfo.userInfo,to: UserModel,byCommand content:String){
        self.date = Date()
        self.isUsed = false
        self.sender = from
        self.reciver = to
        self.type = .command
       self.messageContent = content
        
         self.messageUuid = UUID()
        
        
    }
    init(from: UserModel = appDelegate.settingInfo.userInfo,to: UserModel,byLink content:String){
        self.date = Date()
        self.isUsed = false
        self.sender = from
        self.reciver = to
        self.type = .link
        self.messageContent = content
         self.messageUuid = UUID()
        
        
    }
    init(from: UserModel = appDelegate.settingInfo.userInfo,to: UserModel,byImage content:UIImage){
        self.date = Date()
        self.isUsed = false
        self.sender = from
        self.reciver = to
        self.type = .image
        self.messageContent = String(data: (content.pngData() ?? UIImage().pngData()!), encoding: String.Encoding.utf8) ?? String()
            
         self.messageUuid = UUID()
        
        
    }
    init(){
        self.date = Date()
        self.isUsed = false
        self.sender =  appDelegate.settingInfo.userInfo
        self.reciver = UserModel()
        self.type = .link
        self.messageContent = String()
         self.messageUuid = UUID()
    }
    
  
}

