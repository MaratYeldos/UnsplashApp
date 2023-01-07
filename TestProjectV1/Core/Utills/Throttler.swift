//
//  Throttler.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 07.01.2023.
//

import UIKit

final class Throttler {
    static let shared = Throttler()
    private var task: DispatchWorkItem?

    func throttle(timeInterval: TimeInterval, block: @escaping () -> Void) {
        task?.cancel()

        let task = DispatchWorkItem { block() }

        self.task = task

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: task)
    }
}
