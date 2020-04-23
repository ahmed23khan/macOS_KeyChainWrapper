//
//  AESProtocols.swift
//  AES
//
//  Created by Khan, Tauqeer - Dell Team on 21/04/20.
//  Copyright © 2020 RSA. All rights reserved.
//

import Foundation


protocol Randomizer {
    static func randomIv() -> Data
    static func randomSalt() -> Data
    static func randomData(length: Int) -> Data
}

protocol Crypter {
    func encrypt(_ digest: Data) throws -> Data
    func decrypt(_ encrypted: Data) throws -> Data
}
