//
//  DomainProtocols.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/17/22.
//

import Foundation
import Combine

/// Empty enum indicating an identifier is not necessary to make a request
enum NoArguments {}
/// Use case that retrieves a data model from memory or sync calls.
protocol SyncEntity {
    /// Arguments used to request a specific entity.
    associatedtype Arguments
    /// Returns Entity that conforms to SyncEntity. Nil if not found.
    static func syncRequest(arguments: Arguments?) -> Self?
}

/// Use case that retrieves a data model asynchronously.
protocol AsyncEntity {
    /// Error type originated in the Domain layer. Specific to this Project.
    associatedtype DomainError: Error
    /// Arguments used to request a specific entity.
    associatedtype Arguments
    
    /// Closure that passes argument Result<Self, DomainError>
    typealias ResultHandler = (Result<Self,DomainError>) -> Void
    
    /// Fetch entity from repository or manager and call handler with result.
    /// - Parameters:
    ///   - identifier: String unique to this entity, e.g.: Test Case identifier.
    ///   - handler: Closure containing the entity if .success or DomainError if .failure
    static func asyncRequest(arguments: Arguments?, handler: @escaping ResultHandler)
}

/// Use case that observes an entity
/// Entity can be cached with an EntityPublisher.Cached or use EntityPublisher.Passthrough instead to avoid caching its value.
/// Returned AnyCancellable object can be owned by the class calling subscribe() so it can cancel its subscription once it no longer needs updates from that entity.
protocol ObservableEntity {
    /// Domain layer error explaining why the entity failed to be retrieved.
    associatedtype DomainError: Error
    /// Arguments used to request a specific entity.
    associatedtype Arguments
    
    /// Result to be used by combine subjects
    typealias EntityResult = Result<Self, DomainError>
    /// Closure that passes argument Result<Self, DomainError>
    typealias ResultHandler = (EntityResult) -> Void
    
    static func subscribe(arguments: Arguments?, updateHandler: @escaping ResultHandler) -> AnyCancellable?
}

/// Use case to create, update or delete a cached entity
protocol MutableLocalEntity {
    associatedtype DomainError: Error
    /// Arguments used to request a specific entity.
    associatedtype Arguments
    func syncMutate(arguments: Arguments?, mutationKind: MutationKind) -> DomainError?
}

/// Use case to create, update or delete an entity asynchronously
protocol MutableAsyncEntity {
    associatedtype DomainError: Error
    /// Arguments used to request a specific entity.
    associatedtype Arguments
    typealias ResultHandler = (Result<Self, DomainError>) -> Void
    func asyncMutate(arguments: Arguments?,
                     mutationKind: MutationKind,
                     handler: @escaping ResultHandler)
}

/// Mutation kind used by Mutable Entities to indicate which CRUD (-R) operation should be performed.
enum MutationKind {
    /// If such object already exitsts, it is expected to be completely replaced.
    case create
    /// Use to update specific properties of an existing entity.
    case update
    /// Delete object for provided key.
    case delete
}

/// Meant for running multiple entities and report once completed or if an error was thrown.
/// Ownership: Should be owned by the class calling it.
protocol EntityBundle {
    /// Arguments necessary to execute this bundle
    associatedtype Arguments
    /// Expected output from this bundle. Usually an enum listing the entities ran and their results.
    associatedtype BundleOutput
    func execute(arguments: Arguments?, handler: @escaping (BundleOutput) -> Void)
}

// MARK: - Publisher Aliases, used by Observable Entities.
enum EntityPublisher {
    typealias Passthrough<Entity: ObservableEntity> = PassthroughSubject<Entity.EntityResult, Error>
    typealias Cached<Entity: ObservableEntity> = CurrentValueSubject<Entity.EntityResult, Error>
}

// MARK: - Data Decodable Entities
protocol DataDecodableEntity: Decodable {
  static func fromData(_ data: Data) -> Self?
}

extension DataDecodableEntity {
  static func fromData(_ data: Data) -> Self? {
    do {
      let entity = try JSONDecoder().decode(Self.self, from: data)
      return entity
    } catch {
      print("[\(String(describing: Self.self))] failed to parse entity because of: \(error)")
      return nil
    }
  }
}
