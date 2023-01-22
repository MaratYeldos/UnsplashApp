//
//  Throttler.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 07.01.2023.
//

import UIKit

final class TypingThrottler {
    
    typealias Handler = (String) -> Void
    
    let interval: TimeInterval
    
    let handler: Handler
    
    init(interval: TimeInterval = 0.6, handler: @escaping Handler) {
        self.interval = interval
        self.handler = handler
    }
    
    private var workItem: DispatchWorkItem?
    
    func handleTyping(with text: String) {
        workItem?.cancel()
        
        workItem = DispatchWorkItem { [weak self] in
            self?.handler(text)
        }
        
        if let workItem = self.workItem {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: workItem)
        }
    }
}
