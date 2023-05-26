//
//  Functions.swift
//  StatMe
//
//  Created by spiiral no on 5/12/23.
//

import Foundation

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()
