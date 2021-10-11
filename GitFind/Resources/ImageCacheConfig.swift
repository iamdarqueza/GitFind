//
//  ImageCacheConfig.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/12/21.
//

import Foundation

struct ImageCacheConfig {
    let countLimit: Int
    let memoryLimit: Int

    static let defaultConfig = ImageCacheConfig(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
}
