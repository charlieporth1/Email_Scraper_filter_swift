//
//  emailListObject.swift
//  filter
//
//  Created by Charlie  Porth on 5/19/20.
//  Copyright © 2020 Charlie  Porth. All rights reserved.
//

import Foundation

class EmailListObject: NSObject {
    var email: String?
    var biz: String?
    var num: Int?

    convenience init(email: String?, biz: String?) {
        self.init()
        self.email = email
        self.biz = biz
    }

    var isComplete: Bool? {
        return (email != nil && biz != nil)
    }

}
