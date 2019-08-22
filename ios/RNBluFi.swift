//
//  RNBluFi.swift
//  RNBluFi
//
//  Created by Tuan PM on 2/28/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import BluFi

@objc(RNBluFi)
class RNBluFi: RCTEventEmitter {
    private var bluFi: BluFiMangager?
    @objc
    override func constantsToExport() -> [AnyHashable : Any]! {
        return ["initialCount": 0]
    }
    @objc
    override static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    override func supportedEvents() -> [String]! {
        return ["onData"]
    }
    
    @objc
//    func setup(_ callback: @escaping RCTResponseSenderBlock) {
    func setup() {
        if (bluFi != nil) {
            print("dispose")
            bluFi = nil
        }
        bluFi = BluFiMangager(writeToBluetooth: { (data) in
            let resultBytes:[UInt8] = Array(UnsafeBufferPointer(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count))
            self.sendEvent(withName: "onData", body: resultBytes)
        })
    }
    
    @objc
    func inputData(_ data: NSArray) {
        bluFi?.read(data as! [UInt8])
    }
    @objc
    func negotiate(_ callback: @escaping RCTResponseSenderBlock) {
        bluFi?.negotiate().done({ (success) in
            callback([success])
        })
    }
    
    @objc
    func negotiate(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
        ) -> Void {
        bluFi?.negotiate().done({ (success) in
            if success {
                resolve(success)
            } else {
                let error = NSError(domain: "", code: -1, userInfo: nil)
                reject("E_COUNT", "Error negotiate", error)
            }
        })
    }
    
    @objc
    func writeData(
        _ data: NSArray,
        timeout timeout_sec: Int,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
        ) -> Void {
        
        bluFi?.writeCustomData(data as! [UInt8], timeout_sec).done({ (resp) in
            resolve(resp)
        }).catch({ (err) in
            reject("E_COUNT", "Error write data", err)
        })
        
    }
}

