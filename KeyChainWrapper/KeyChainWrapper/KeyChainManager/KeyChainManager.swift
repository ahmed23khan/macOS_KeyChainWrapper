//
//  KeyChainManager.swift
//  KeyChainWrapper
//
//  Created by Khan, Tauqeer - Dell Team on 21/04/20.
//  Copyright © 2020 RSA. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case itemMissing
}

public protocol KeychainManagerProtocol {
    func save(key: String, data: Data) -> OSStatus
    func load(key: String) -> Data?
    func delete(key: String, data: Data) throws -> OSStatus
    func delete(key: String) throws -> OSStatus
    func update(key: String, data: Data)
}

class KeyChainManager: KeychainManagerProtocol {
    
    private let keychain: KeyChainProtocol
    
    init(_ keychain: KeyChainProtocol ) {
        self.keychain = keychain
    }
    
    func update(key: String, data: Data) {
        let query : [String : Any] = [kSecClass as String       : kSecClassGenericPassword as String,
                                    kSecAttrAccount as String : key,]

        
        let attributes : [String : Any] = [kSecAttrAccount as String: key,
        kSecValueData as String: data]
        
        
         _ = keychain.update(query, with: attributes)
    }

    
    func delete(key: String) throws -> OSStatus {
        if let data = load(key: key) {
            let query = createSaveQuery(key: key, data: data )
            return keychain.delete(query)
        }
        throw KeychainError.itemMissing
    }
    
    func delete(key: String, data: Data) throws -> OSStatus {
        let query = createSaveQuery(key: key, data: Data.init() )
        return keychain.delete(query)
    }
    
    func save(key: String, data: Data) -> OSStatus {
        let query = createSaveQuery(key: key, data: data)
        return keychain.add(query)
    }
    
    func load(key: String) -> Data? {
        let query = createSearchQuery(key: key)
        return keychain.search(query)
    }
    
    func createSaveQuery(key: String, data: Data) -> [String: Any] {
        // Build the query to be used in Saving Data
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ]
            as [String : Any]
        return query
    }
    
    func createSearchQuery(key: String) -> [String: Any] {
        // Build the query to be used in Loading Data
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ]
            as [String : Any]
        return query
    }
}
