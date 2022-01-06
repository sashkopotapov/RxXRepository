//
//  RxRepositoryExtensions.swift
//  RxXRepository
//
//  Created by Oleksandr Potapov on 06.01.2022.
//

import Foundation
import RxSwift
import XRepository

extension RxRepository where Self: AnyObject, Self: Repository, Self.Model: Hashable {
    
  public func getAll() -> Single<AnyRandomAccessCollection<Model>> {
    return Single.create { [weak self] single -> Disposable in
      let models = self?.getAll() ?? AnyRandomAccessCollection([])
      single(.success(models))
      return Disposables.create()
    }
  }
  
  public func getElement<Id>(withId id: Id) -> Single<Model?> {
    return Single.create { [weak self] single -> Disposable in
      let model = self?.getElement(withId: id)
      single(.success(model))
      return Disposables.create()
    }
  }
  
  public func getElements(filteredBy filter: Query<Model>?, sortedBy sortMode: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) -> Single<AnyRandomAccessCollection<Model>> {
    return Single.create { [weak self] single -> Disposable in
      let models = self?.getElements(filteredBy: filter, sortedBy: sortMode, distinctUsing: distinctMode) ?? AnyRandomAccessCollection([])
      single(.success(models))
      return Disposables.create()
    }
  }
  
  public func create(_ model: Model) -> Single<Model> {
    return Single.create { [weak self] single -> Disposable in
      let result: RepositoryEditResult = self?.create(model) ?? .error(RxRepositoryError.weakReferenceAppearedNil)
      switch result {
      case .success(let model):
        single(.success(model))
      case .error(let error):
        single(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func create(_ models: [Model]) -> Single<[Model]> {
    return Single.create { [weak self] single -> Disposable in
      let result: RepositoryEditResult = self?.create(models) ?? .error(RxRepositoryError.weakReferenceAppearedNil)
      switch result {
      case .success(let models):
        single(.success(models))
      case .error(let error):
        single(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func update(_ model: Model) -> Single<Model> {
    return Single.create { [weak self] single -> Disposable in
      let result: RepositoryEditResult = self?.update(model) ?? .error(RxRepositoryError.weakReferenceAppearedNil)
      switch result {
      case .success(let model):
        single(.success(model))
      case .error(let error):
        single(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  public func delete(_ model: Model) -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      if let error = self?.delete(model) {
        completable(.error(error))
      } else {
        completable(.completed)
      }
      
      return Disposables.create()
    }
  }
  
  public func delete(_ models: [Model]) -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      if let error = self?.delete(models) {
        completable(.error(error))
      } else {
        completable(.completed)
      }
      
      return Disposables.create()
    }
  }
  
  public func deleteAll() -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      if let error = self?.deleteAll() {
        completable(.error(error))
      } else {
        completable(.completed)
      }
      
      return Disposables.create()
    }
  }
  
  public func performTransaction(_ transaction: @escaping () -> Void) -> Completable {
    return Completable.create { completable -> Disposable in
      transaction()
      completable(.completed)
      return Disposables.create()
    }
  }
}

enum RxRepositoryError: Error {
  case weakReferenceAppearedNil
}
