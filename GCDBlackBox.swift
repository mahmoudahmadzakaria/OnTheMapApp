//
//  GCDBlackBox.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 11/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
