//
//  RxRepository+Default.swift
//  RxXRepository
//
//  Created by Oleksandr Potapov on 21.12.2021.
//

import Foundation
import XRepository
import RxSwift

// Default implementations
public extension RxRepository where Self: AnyObject, Self: Repository {
  func getAll() -> Single<AnyRandomAccessCollection<Model>> {
    return Single.create { [weak self] single -> Disposable in
      let models = self?.getAll() ?? AnyRandomAccessCollection([])
      single(.success(models))
      return Disposables.create()
    }
  }
  
  func getElement<Id>(withId id: Id) -> Single<Model?> {
    return Single.create { [weak self] single -> Disposable in
      let model = self?.getElement(withId: id)
      single(.success(model))
      return Disposables.create()
    }
  }
  
  func getElements(filteredBy filter: Query<Model>?, sortedBy sortMode: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) -> Single<AnyRandomAccessCollection<Model>> {
    return Single.create { [weak self] single -> Disposable in
      let models = self?.getElements(filteredBy: filter, sortedBy: sortMode, distinctUsing: distinctMode) ?? AnyRandomAccessCollection([])
      single(.success(models))
      return Disposables.create()
    }
  }
  
  func create(_ model: Model) -> Single<Model> {
    return Single.create { [weak self] single -> Disposable in
      let result: RepositoryEditResult = self?.create(model) ?? .error(ReferenceError.weakReferenceNil)
      switch result {
      case .success(let model):
        single(.success(model))
      case .error(let error):
        single(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  func create(_ models: [Model]) -> Single<[Model]> {
    return Single.create { [weak self] single -> Disposable in
      let result: RepositoryEditResult = self?.create(models) ?? .error(ReferenceError.weakReferenceNil)
      switch result {
      case .success(let models):
        single(.success(models))
      case .error(let error):
        single(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  func update(_ model: Model) -> Single<Model> {
    return Single.create { [weak self] single -> Disposable in
      let result: RepositoryEditResult = self?.update(model) ?? .error(ReferenceError.weakReferenceNil)
      switch result {
      case .success(let model):
        single(.success(model))
      case .error(let error):
        single(.failure(error))
      }
      
      return Disposables.create()
    }
  }
  
  func delete(_ model: Model) -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      if let error = self?.delete(model) {
        completable(.error(error))
      } else {
        completable(.completed)
      }
      
      return Disposables.create()
    }
  }
  
  func delete(_ models: [Model]) -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      if let error = self?.delete(models) {
        completable(.error(error))
      } else {
        completable(.completed)
      }
      
      return Disposables.create()
    }
  }
  
  func deleteAll() -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      if let error = self?.deleteAll() {
        completable(.error(error))
      } else {
        completable(.completed)
      }
      
      return Disposables.create()
    }
  }
  
  func performTransaction(_ transaction: @escaping () -> Void) -> Completable {
    return Completable.create { completable -> Disposable in
      transaction()
      completable(.completed)
      return Disposables.create()
    }
  }
}

public enum ReferenceError: Error {
  case weakReferenceNil
}
