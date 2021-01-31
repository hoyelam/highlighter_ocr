//
//  AppOSLog.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 28/01/2021.
//

import Foundation
import os.log

final class AppOSLog {
    static func logError(class: AnyClass, error: Error) {
        os_log("Error: %{public}@",
               log: .default,
               type: .fault,
               String(describing: error))
    }
    
    static func logError(class: AnyClass, error: String) {
        os_log("Error: %{public}@",
               log: .default,
               type: .fault,
               error)
    }
}
