//
//  UserDefaultsRepository+Rx.swift
//  RxXRepositoryUserDefaults
//
//  Created by Oleksandr Potapov on 21.12.2021.
//

import Foundation
import XRepository
import XRepositoryUserDefaults
import RxXRepository
import RxSwift
import RxCocoa

extension UserDefaultsRepository: ReactiveRepository {
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
}

