//
//  SocketModel.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/26.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import UIKit
//import <SystemConfiguration/CaptiveNetwork.h>
import SystemConfiguration.CaptiveNetwork
//#import <SystemConfiguration/CaptiveNetwork.h>
import NetworkExtension

protocol SocketModelDelegate {
    func socketModel(_ sock: SocketModel, didConnectToHost host: String, port: UInt16)
    func socketModelDidDisconnect(_ sock: SocketModel, withError err: Error?)
    func socketModel(_ sock: SocketModel, messageModelReadyRead: MessageModel)
    func socket(_ sock: SocketModel,messageModelWritten: MessageModel)
    //func SocketModel(didUpdateMessages messages:[MessageModel])
    //func SocketModel(didAppend newMessage: MessageModel)
}




class SocketModel : NSObject{
    
    //static let ServerUserModel = UserModel.MakeServerUser()
    
    private var socket : GCDAsyncSocket
    let TAG = 801103
    let HEADSENDTAG = 324252
    let BODYSENDTAG = 897987
    var msg: MessageModel?
    var msgBody: MessageBodyModel?
    var msgHead: MessageHeadStruct?
    var messageBodyReadFinish: Bool = true
    var recvData = Data()
    var socketModelDelegate: SocketModelDelegate?
//    var socketTagName: String
    static let ServerMacAddress = "11111"
    var catchModel :MessageModelCatch
    
    override init() {
        catchModel = MessageModelCatch()
        socket = GCDAsyncSocket()
        
        super.init()
        catchModel.delegate = self
        socket.delegate = self
        socket.delegateQueue = DispatchQueue.global()
        
        
    }
   
//    init(tagName: String) {
//        self.socketTagName = tagName
//        super.init()
//        self.delegate = self
//        self.delegateQueue = DispatchQueue.global()
//        //self.init(delegate: self, delegateQueue: DispatchQueue.global())
//
//    }
    //var delegate:
    
    //var socket = GCDAsyncSocket()
//    override init() {
//        //super.init(socketQueue: DispatchQueue.global())
//        //delegate = self
//        //delegateQueue = DispatchQueue.global()
//        super.init()
//    }
//    override init(socketQueue sq: DispatchQueue?) {
//        super.init(socketQueue: sq)
//    }
//    override init(delegate aDelegate: GCDAsyncSocketDelegate?, delegateQueue dq: DispatchQueue?) {
//        super.init(delegate: aDelegate, delegateQueue: dq)
//    }
//    
    
//    override init() {
//
//
//        super.init()
//        delegate = self
//        delegateQueue = DispatchQueue.global()
//    }
    
    lazy var settingInfo = {
        return appDelegate.setting
    }()
    public func getConnectStatus() ->Bool{
        return socket.isConnected
    }
    public func connectToHost(){
        do{
            
            //print( self.delegate ?? "Nil delegate")
            try socket.connect(toHost: settingInfo.serverAddress, onPort: UInt16(settingInfo.port))
            socket.readData(withTimeout: -1, tag: TAG)
            
           
            
        }catch{
            print(error.localizedDescription)
        }
    }
   
//    init() {
//        super.init()
//        super.delegate = self
//        super.delegateQueue = DispatchQueue.global()
//    }
    public func disConnectToHost(){
        socket.disconnect()
        
    }
    public func send(by data:Data){
        
        socket.write(data, withTimeout: -1, tag: TAG)
    //write
    }
    public func send(byMessageModel msg:MessageModel){
        if msg.isEmpty{
            return
        }
        self.msg = msg
        msgHead = msg.head
        msgBody = msg.body
        socket.write(msg.headData!,withTimeout: -1,tag: HEADSENDTAG)
    }
    
    
    //get mac and ip
    static func getLocalIDFV() -> String{
        let s = UIDevice.current.identifierForVendor?.uuidString
        //.identifierForVendor.uuidString
        if let idfv = s{
            return idfv
        }else{
            return "55555"
        }
        
    }
    
    static func getLocalIpAddress() -> String{
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses.first ?? "0.0.0.0"
    }
    
   
  
}


extension SocketModel:GCDAsyncSocketDelegate{
   
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
//        socket.readData(withTimeout: -1, tag: TAG)
        
        self.socketModelDelegate?.socketModel(self, didConnectToHost: host, port: port)
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        //isConnected = false
       // delegate?.clinetsLinkChanged(isConnected: false)
        self.socketModelDelegate?.socketModelDidDisconnect(self, withError: err)
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        if ((tag == HEADSENDTAG || tag == BODYSENDTAG || tag == 0) && data.count == 1){
            return
        }
        catchModel.append(data: data)
        socket.readData(withTimeout: -1, tag: tag)
        
       
    }
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        if (tag == HEADSENDTAG){
            socket.write(msg?.bodyData, withTimeout: -1, tag: BODYSENDTAG)
            
            socket.readData(withTimeout: -1, tag: HEADSENDTAG)
        }
        if (tag == BODYSENDTAG){
            socketModelDelegate?.socket(self, messageModelWritten: msg!)
            socket.readData(withTimeout: -1, tag: BODYSENDTAG)
        }
//        super.readData(withTimeout: -1, tag: TAG)
//        self.readData(withTimeout: -1, tag: TAG)
//        socket.readData(withTimeout: -1, tag: BODYSENDTAG)
    }
    //socket
    
    
    
}


extension SocketModel: MessageModelCatchDelegate{
    func messageModelCatchDidStartReading(modelCatch: MessageModelCatch) {
        return
    }
    
    func messageModelCatchDidReadHead(modelCatch: MessageModelCatch) {
        return
    }
    
    func messageModelCatchDidReadBody(modelCatch: MessageModelCatch) {
        return
    }
    
    func messageModelCatchDidFinish(modelCatch: MessageModelCatch, messageModel: MessageModel) {
        self.socketModelDelegate?.socketModel(self, messageModelReadyRead: messageModel)
    }
    
    
}
