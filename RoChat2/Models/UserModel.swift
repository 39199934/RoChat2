//
//  UserModel.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/30.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//


import Foundation
import UIKit


let UNKNOWUUID = UUID()
enum UserModelType:String, Codable{
    case normal = "normal"
    case admin = "admin"
    case guest = "guest"
}
struct UserModelSendStruct : Codable{
    var name: String
    var ipAddress: String
    var type: UserModelType = .normal
    var password: String = "123456"
    var macAddress :String = "55555"
}
struct UserModel: Codable{
    var name: String
    var ipAddress: String
    var type: UserModelType = .normal
    var photo: Data = UIImage(named: "head")?.pngData() ?? Data()
    var password: String = "123456"
    var macAddress :String = "55555"
    //"55555"获取失败 “11111”服务器默认
    //var uuid = UUID()
    //    {
    //        didSet{
    //            self.userName = self.userUUID.uuidString
    //        }
    //    }
    
    //取得服务器User
    static func MakeServerUser() -> UserModel{
        var serverModel = UserModel()
        serverModel.name = "server"
        serverModel.ipAddress = ""
        serverModel.macAddress = SocketModel.ServerMacAddress
        serverModel.type = .admin
        return serverModel;
        
       
    }
    //取得本地用户user
    static func MakeLocalUser() -> UserModel{
        var localUser = UserModel()
        localUser.name = "userMySelf"
        localUser.ipAddress = SocketModel.getLocalIpAddress()
        localUser.macAddress = SocketModel.getLocalIDFV()
        localUser.type = .normal
        localUser.photo = UIImage(named: "head")?.pngData() ?? Data()
        return localUser;
        
        
    }
    
    //取得发送所需的用户信息
    func getSendUserStruct() -> UserModelSendStruct{
        let sendStruct = UserModelSendStruct(name: self.name, ipAddress: self.ipAddress, type: self.type, password: self.password, macAddress: self.macAddress)
        return sendStruct
    }
    
    //取得本用户的照片
    func getPhoto() -> UIImage{
        return UIImage(data: self.photo) ?? UIImage()
    }
    init(){
        self.name = "unknow"
        self.ipAddress = SocketModel.getLocalIpAddress()
        self.type = .guest
        self.photo = UIImage(named: "head")?.pngData() ?? Data()
        self.password = ""
        self.macAddress = SocketModel.getLocalIDFV()
//        let mac = SocketModel.getMAC()
//        if mac.success{
//            self.macAddress = mac.mac;
//        }else{
//            self.macAddress = "55555"
//        }
        //self.uuid = UUID()
    }
    init( name: String,type: UserModelType,photo: UIImage,password: String)
    {
        self.name = name
        self.ipAddress = SocketModel.getLocalIpAddress()
        self.type =  type
        self.photo = photo.pngData() ?? Data()
        self.password = password
        self.macAddress = SocketModel.getLocalIDFV()
    }
    
    /*
    init(sendMsg: SendMessageStruct){
        self.name = "unknow"
        self.ipAddress = SocketModel.getLocalIpAddress()
        self.type = .guest
        self.photo = UIImage(named: "head")?.pngData() ?? Data()
        self.password = ""
       self.macAddress = SocketModel.getLocalIDFV()
    }*/
    
}

extension UserModel{
    
    static var UserModelEmpty : UserModel{
        let um = UserModel(name: "", type: .guest, photo: UIImage(), password: "")
        return um;
    }
}
