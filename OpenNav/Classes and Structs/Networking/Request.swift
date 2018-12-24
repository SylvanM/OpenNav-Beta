//
//  Request.swift
//  OpenNav
//
//  Created by Sylvan Martin on 12/22/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation

protocol Request {
    var arguments: [String : String] { get set }
    var url: URL { get }
}
