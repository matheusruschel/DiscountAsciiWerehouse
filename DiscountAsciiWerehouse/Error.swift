//
//  Error.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

enum Error : ErrorType {
    
    case ErrorWithMsg(msg: String)
    case JSONNotRecognizedError
    case CouldNotCreateObjectWithDataFile
}