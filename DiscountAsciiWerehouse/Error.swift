//
//  Error.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/1/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

enum ErrorCode: ErrorType {
    case CanceledTask, JSONNotRecognizedError, CouldNotCreateObjectWithDataFile, CoreDataAddError
}

enum Error : ErrorType {
    case ErrorWithCode(errorCode:ErrorCode)
    case ErrorWithMsg(msg: String)
}

struct ErrorHandler {
    
    static func handleErrorFromServer(errorCode:Int) -> Error {
        
        switch errorCode {
        case -999:
            return Error.ErrorWithCode(errorCode: .CanceledTask)
        default:
            return Error.ErrorWithMsg(msg: "Oops, something went wrong")
        }
        
    }
}