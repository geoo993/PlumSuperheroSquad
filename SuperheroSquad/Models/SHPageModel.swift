//
//  SHPageModel.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 12/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import SHData

protocol SHPageModel {
    associatedtype T
    var isLoading: Bool { get set }
    var isLoadingNextPage: Bool { get set }
    var pagination: SHPagination? { get set }
    func fetchPage()
    func fetchNextPage()
    func update(marvelData: [T], and pagination: SHPagination, isNextPage: Bool)
    func updateStatus()
}
