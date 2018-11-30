//
//  ViewController.swift
//  TestePairingProject
//
//  Created by Luciano Pezzin on 01/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {

    var centralManager = CBCentralManager()
    var miband: CBPeripheral?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
        
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name?.lowercased() == "mi band 2" {
            self.miband = peripheral
            self.centralManager.connect(self.miband!, options: nil)
        }
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        central.stopScan()
        print("stop scan")
        print(peripheral.name!)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("desconectado de ",peripheral.name!)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print(service)
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("unknow")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print(peripheral.state)
    }

}

