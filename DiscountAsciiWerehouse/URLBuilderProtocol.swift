//
//  URLBuilderProtocol.swift
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/18/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol URLBuilderProtocol {
    static func buildUrl(forParameters parameters:[PARAM:AnyObject]) -> NSURL?
    static func getPartialUrlForParameter(paramType: PARAM, value:AnyObject) -> String
}

enum PARAM : String {
    case SearchTerm = "q", Skip = "skip", OnlyInStock = "onlyInStock", Limit = "limit"
}