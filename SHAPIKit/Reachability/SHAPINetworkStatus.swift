//
//  SHAPINetworkStatus.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 05/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import Network

// MARK: - SHAPINetworkStatus

enum SHAPINetworkStatus {
    
    case online
    case offline
}

// MARK: - SHAPINetworkStatusMonitor

final class SHAPINetworkStatusMonitor {
    
    // MARK: - Properties
    
    private(set) var status: SHAPINetworkStatus? = nil
    private let networkStatusListener: SHAPINetworkStatusListenable?
    
    // MARK: - Singleton
    
    static let shared = SHAPINetworkStatusMonitor()
    
    // MARK: - Initializer
    
    private init() {
        networkStatusListener = {
            if #available(iOSApplicationExtension 12.0, *) {
                let monitor = NWPathMonitor()
                let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.geo-games.SHAPIKit"
                monitor.start(queue: DispatchQueue(label: "\(bundleIdentifier).NetworkMonitor"))
                return monitor
            } else {
                let reachability = Reachability()
                try? reachability?.startNotifier()
                return reachability
            }
        }()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        networkStatusListener?.onNetworkStatusUpdate { [weak self] (status) in
            self?.status = status
        }
    }
    
    public var isConnected: Bool {
        guard let status = status else { return false }
        return status == .online
    }
}

// // MARK: - SHAPINetworkStatusListenable

protocol SHAPINetworkStatusListenable: class {
    
    func onNetworkStatusUpdate(_ closure: @escaping (SHAPINetworkStatus) -> Void)
}

extension Reachability: SHAPINetworkStatusListenable {

    func onNetworkStatusUpdate(_ closure: @escaping (SHAPINetworkStatus) -> Void) {
        whenReachable = { _ in
            closure(.online)
        }
        whenUnreachable = { _ in
            closure(.offline)
        }
        closure(connection == .none ? .offline : .online)
    }
}

@available(iOSApplicationExtension 12.0, *)
extension NWPathMonitor: SHAPINetworkStatusListenable {
    
    func onNetworkStatusUpdate(_ closure: @escaping (SHAPINetworkStatus) -> Void) {
        pathUpdateHandler = { (path) in
            let status: SHAPINetworkStatus = path.status == .satisfied ? .online : .offline
            closure(status)
        }
    }
}

