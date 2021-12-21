//
//  RxRepositoryWrapper.swift
//  RxXRepository
//
//  Created by Oleksandr Potapov on 21.12.2021.
//

import Foundation
import XRepository
import RxSwift

public final class RxRepositoryWrapper<Model>: RxRepository {

  private let _observeAll: () -> Observable<AnyRandomAccessCollection<Model>>
  private let _observeElement: (Any) -> Observable<Model>
  private let _observeElemenets: (Query<Model>?, ComparableKeyPath<Model>?, HashableKeyPath<Model>?) -> Observable<AnyRandomAccessCollection<Model>>
  
  private let _getAll: () -> Single<AnyRandomAccessCollection<Model>>
  private let _getElement: (Any) -> Single<Model?>
  private let _getElements: (Query<Model>?, ComparableKeyPath<Model>?, HashableKeyPath<Model>?) -> Single<AnyRandomAccessCollection<Model>>

  private let _create: (Model) -> Single<Model>
  private let _createMultiple: ([Model]) -> Single<[Model]>

  private let _update: (Model) -> Single<Model>

  private let _delete: (Model) -> Completable
  private let _deleteMultiple: ([Model]) -> Completable
  private let _deleteAll: () -> Completable

  private let _performTransaction: (@escaping () -> Void) -> Completable


  public init<A: RxRepository>(_ repository: A) where A.Model == Model {
    _observeAll = repository.observeAll
    _observeElement = repository.observeElement
    _observeElemenets = repository.observeElements
    _getAll = repository.getAll
    _getElement = repository.getElement
    _getElements = repository.getElements
    _create = repository.create
    _createMultiple = repository.create
    _update = repository.update
    _delete = repository.delete
    _deleteMultiple = repository.delete
    _deleteAll = repository.deleteAll
    _performTransaction = repository.performTransaction
  }

  public func observeAll() -> Observable<AnyRandomAccessCollection<Model>> {
    return _observeAll()
  }

  public func observeElement<Id>(withId id: Id) -> Observable<Model> {
    return _observeElement(id)
  }

  public func observeElements(filteredBy filter: Query<Model>?, sortedBy sortKeyPath: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) -> Observable<AnyRandomAccessCollection<Model>> {
    return _observeElemenets(filter, sortKeyPath, distinctMode)
  }

  public func getAll() -> Single<AnyRandomAccessCollection<Model>> {
    return _getAll()
  }

  public func getElement<Id>(withId id: Id) -> Single<Model?> {
    return _getElement(id)
  }

  public func getElements(filteredBy filter: Query<Model>?, sortedBy sortMode: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) -> Single<AnyRandomAccessCollection<Model>> {
    return _getElements(filter, sortMode, distinctMode)
  }

  public func create(_ model: Model) -> Single<Model> {
    return _create(model)
  }

  public func create(_ models: [Model]) -> Single<[Model]> {
    return _createMultiple(models)
  }

  public func update(_ model: Model) -> Single<Model> {
    return _update(model)
  }

  public  func delete(_ model: Model) -> Completable {
    return _delete(model)
  }

  public func delete(_ models: [Model]) -> Completable {
    return _deleteMultiple(models)
  }

  public func deleteAll() -> Completable {
    return _deleteAll()
  }

  public func performTransaction(_ transaction: @escaping () -> Void) -> Completable {
    return _performTransaction(transaction)
  }
}

