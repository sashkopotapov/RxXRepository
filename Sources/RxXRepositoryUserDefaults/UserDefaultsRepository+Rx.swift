//
//  UserDefaultsRepository+Rx.swift
//  RxCocoa
//
//  Created by Sashko Potapov on 21.12.2021.
//

import Foundation
import XRepository
import XRepositoryUserDefaults
import RxXRepository
import RxSwift
import RxCocoa

extension UserDefaultsRepository: RxRepository {
  public func observeAll() -> Observable<AnyRandomAccessCollection<Model>> {
    return userDefault.rx
      .observe(Data.self, key)
      .compactMap({ $0 })
      .compactMap({ [weak self] in
        guard let weakself = self else { return nil }
        return AnyRandomAccessCollection(Array(try weakself.decoder.decode(Set<Model>.self, from: $0)))
      })
      .share(replay: 1)
  }
  
  public func observeElement<Id>(withId id: Id) -> Observable<Model> {
    return observeAll()
      .compactMap({ collection in
        guard let correctId = id as? Model.Identifier else { return nil }
        return collection.filter({ $0.id == correctId }).first
      })
      .share(replay: 1)
  }
  
  public func observeElements(filteredBy filter: Query<Model>?, sortedBy sortKeyPath: ComparableKeyPath<Model>?, distinctUsing distinctMode: HashableKeyPath<Model>?) -> Observable<AnyRandomAccessCollection<Model>> {
    return observeAll()
      .compactMap({ collection in
        var collection = collection
        if let query = filter {
          let result = collection.filter({ query.evaluate($0) })
          collection = AnyRandomAccessCollection(result)
        }
        
        if let sortKeyPath = sortKeyPath {
          let result = collection.sorted(by: sortKeyPath.isSmaller)
          collection = AnyRandomAccessCollection(result)
        }
        
        if let distinctKeyPath = distinctMode {
          let grouped = Dictionary(grouping: collection, by: distinctKeyPath.hashValue)
          let result = grouped.values.compactMap(\.first)
          collection = AnyRandomAccessCollection(result)
        }
        
        return AnyRandomAccessCollection(collection)
      })
      .share(replay: 1)
  }
  
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
  
  public func create(_ models: [Model]) -> Single<[Model]> {
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
  
  public func update(_ model: Model) -> Single<Model> {
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

public enum ReferenceError: Error {
  case weakReferenceNil
}
