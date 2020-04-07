//
//  SHPagination.swift
//  SuperheroSquad
//
//  Created by GEORGE QUENTIN on 06/04/2020.
//  Copyright © 2020 GEORGE QUENTIN. All rights reserved.
//

import Foundation

public struct SHPagination {

    public let count: Int
    public let limit: Int
    public let offset: Int
    public let total: Int

}

extension SHPagination: Decodable {
    
    enum PaginationCodingKeys: String, CodingKey {
        case count = "count"
        case limit = "limit"
        case offset = "offset"
        case total = "total"
    }
    
    // MARK: - Initializer
    
    public init(from decoder: Decoder) throws {
        let paginationContainer = try decoder.container(keyedBy: PaginationCodingKeys.self)
        count = try paginationContainer.decode(Int.self, forKey: .count)
        limit = try paginationContainer.decode(Int.self, forKey: .limit)
        offset = try paginationContainer.decode(Int.self, forKey: .offset)
        total = try paginationContainer.decode(Int.self, forKey: .total)
    }
}

// MARK: -

extension SHPagination {
    
    public var isNextListAvailable: Bool {
        if count < limit {
            return offset + count <= total
        } else {
            return offset + limit <= total
        }
    }
    
    public var itemsToLoadIndexed: Int {
        return offset + count - 1
    }
    
}

// MARK: -

extension SHPagination: Equatable {
    
    // MARK: - Equatable

    public static func == (lhs: SHPagination, rhs: SHPagination) -> Bool {
        return (
                lhs.offset == rhs.offset    &&
                lhs.limit == rhs.limit      &&
                lhs.count == rhs.count      &&
                lhs.total == rhs.total
        )
    }
}
