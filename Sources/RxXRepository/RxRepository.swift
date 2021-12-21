//
//  RxRepository.swift
//  RxXRepository
//
//  Created by Oleksandr Potapov on 21.12.2021.
//

import Foundation
import XRepository
import RxSwift

public protocol RxRepository {
  associatedtype Model
  
  func observeAll() -> Observable<AnyRandomAccessCollection<Model>>
  func observeElement<Id>(withId id: Id) -> Observable<Model>
  func observeElements(filteredBy filter: Query<Model>?, sortedBy sortKeyPath: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) ->  Observable<AnyRandomAccessCollection<Model>>
  
  func getAll() -> Single<AnyRandomAccessCollection<Model>>
  func getElement<Id>(withId id: Id) -> Single<Model?>
  func getElements(filteredBy filter: Query<Model>?, sortedBy sortMode: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) -> Single<AnyRandomAccessCollection<Model>>
  
  func create(_ model: Model) -> Single<Model>
  func create(_ models: [Model]) -> Single<[Model]>
  
  func update(_ model: Model) -> Single<Model>
  
  func delete(_ model: Model) -> Completable
  func delete(_ models: [Model]) -> Completable
  func deleteAll() -> Completable
  
  func performTransaction(_ transaction: @escaping () -> Void) -> Completable
}

extension RxRepository {
  public  func observeElements<T: Comparable, U: Hashable>(filteredBy filter: Query<Model>? = nil, sortedBy sortKeyPath: KeyPath<Model, T>? = nil, distinctUsing distinctKeyPath: KeyPath<Model, U>? = nil) -> Observable<AnyRandomAccessCollection<Model>> {
    return observeElements(filteredBy: filter, sortedBy: sortKeyPath.map(ComparableKeyPath.init), distinctUsing: distinctKeyPath.map(HashableKeyPath.init))
  }
  
  public  func observeElements<P: Predicate>(filteredByPredicate predicate: @autoclosure () -> P) -> Observable<AnyRandomAccessCollection<Model>> where P.ResultType == Model {
    let filter = Query(predicate())
    return observeElements(filteredBy: filter, sortedBy: nil, distinctUsing: nil)
  }
  
  public func observeElements<P: Predicate, T: Comparable>(filteredByPredicate predicate: @autoclosure () -> P, sortedBy sortKeyPath: KeyPath<Model, T>) -> Observable<AnyRandomAccessCollection<Model>> where P.ResultType == Model {
    let filter = Query(predicate())
    let sortMode = ComparableKeyPath(sortKeyPath)
    return observeElements(filteredBy: filter, sortedBy: sortMode, distinctUsing: nil)
  }
  
  public func observeElements<T: Comparable>(sortedBy sortKeyPath: KeyPath<Model, T>) -> Observable<AnyRandomAccessCollection<Model>> {
    let sortMode = ComparableKeyPath(sortKeyPath)
    return observeElements(filteredBy: nil, sortedBy: sortMode, distinctUsing: nil)
  }
  
  public func observeElements<U: Hashable>(distinctUsing distinctKeyPath: KeyPath<Model, U>) -> Observable<AnyRandomAccessCollection<Model>> {
    let distinctMode = HashableKeyPath(distinctKeyPath)
    return observeElements(filteredBy: nil, sortedBy: nil, distinctUsing: distinctMode)
  }
  
  public func observeElements<P: Predicate, T: Comparable, U: Hashable>(filteredByPredicate predicate: @autoclosure () -> P, sortedBy sortKeyPath: KeyPath<Model, T>, distinctUsing distinctKeyPath: KeyPath<Model, U>) -> Observable<AnyRandomAccessCollection<Model>> where P.ResultType == Model {
    let filter = Query(predicate())
    let sortMode = ComparableKeyPath(sortKeyPath)
    let distinctMode = HashableKeyPath(distinctKeyPath)
    return observeElements(filteredBy: filter, sortedBy: sortMode, distinctUsing: distinctMode)
  }
}

extension RxRepository {
  public func getElements<T: Comparable, U: Hashable>(filteredBy filter: Query<Model>? = nil, sortedBy sortKeyPath: KeyPath<Model, T>? = nil, distinctUsing distinctKeyPath: KeyPath<Model, U>? = nil) -> Single<AnyRandomAccessCollection<Model>> {
    return getElements(filteredBy: filter, sortedBy: sortKeyPath.map(ComparableKeyPath.init), distinctUsing: distinctKeyPath.map(HashableKeyPath.init))
  }
  
  public func getElements<P: Predicate>(filteredByPredicate predicate: @autoclosure () -> P) -> Single<AnyRandomAccessCollection<Model>> where P.ResultType == Model {
    let filter = Query(predicate())
    return getElements(filteredBy: filter, sortedBy: nil, distinctUsing: nil)
  }
  
  public func getElements<P: Predicate, T: Comparable>(filteredByPredicate predicate: @autoclosure () -> P, sortedBy sortKeyPath: KeyPath<Model, T>) -> Single<AnyRandomAccessCollection<Model>> where P.ResultType == Model {
    let filter = Query(predicate())
    let sortMode = ComparableKeyPath(sortKeyPath)
    return getElements(filteredBy: filter, sortedBy: sortMode, distinctUsing: nil)
  }
  
  public func getElements<T: Comparable>(sortedBy sortKeyPath: KeyPath<Model, T>) -> Single<AnyRandomAccessCollection<Model>> {
    let sortMode = ComparableKeyPath(sortKeyPath)
    return getElements(filteredBy: nil, sortedBy: sortMode, distinctUsing: nil)
  }
  
  public func getElements<U: Hashable>(distinctUsing distinctKeyPath: KeyPath<Model, U>) -> Single<AnyRandomAccessCollection<Model>> {
    let distinctMode = HashableKeyPath(distinctKeyPath)
    return getElements(filteredBy: nil, sortedBy: nil, distinctUsing: distinctMode)
  }
  
  public func getElements<P: Predicate, T: Comparable, U: Hashable>(filteredByPredicate predicate: @autoclosure () -> P, sortedBy sortKeyPath: KeyPath<Model, T>, distinctUsing distinctKeyPath: KeyPath<Model, U>) -> Single<AnyRandomAccessCollection<Model>> where P.ResultType == Model {
    let filter = Query(predicate())
    let sortMode = ComparableKeyPath(sortKeyPath)
    let distinctMode = HashableKeyPath(distinctKeyPath)
    return getElements(filteredBy: filter, sortedBy: sortMode, distinctUsing: distinctMode)
  }
}
