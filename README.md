<p align="center">
<br>
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchO-333333.svg" alt="Supported Platforms: iOS, macOS, tvOS, watchOS" />
<br/>
<a><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
<a><img src="https://img.shields.io/badge/License-MIT-yellow.svg" /></a>
</p>

**RxXRepository** is reactive extension for [XRepository](https://github.com/sashkopotapov/XRepository). This extension allows implementations of Repository pattern become rx-compatable and adds observing methods to CRUD operations.

## 👋🏻  Getting started
Cornerstone of this project is `RxRepository`  protocol.
```swift
protocol RxRepository {
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
```

Than you have `AnyRxRepository` class to abstragate implementation of `Repository & RxRepository` from its consumers. `AnyRxRepository` has the same semantic as its interface. It consumes implementation of both `Repository & RxRepository`.

```swift
final class AnyRxRepository<Model>: Repository {
  ...
  init <A: Repository & RxRepository>(_ repository: A) where A.Model == Model { ... }
  ...
}
```
## 🔧 Usage
Since **RxXRepository**  is an extension of  **XRepository**, you can extend functionality of existing  `Repository` implementation. Right now you get out-of-the-box extension for `UserDefaultsRepository`. But you can create your own implementation. While non-reactive interface has not changed from  **XRepository**, you get access to rx methods by subscripting repository instance with `rx`.
Usage is simple:
```swift
class ChurchesViewModel {
  ...
  let churchesRepository: AnyRxRepository<Church>
  ...

  func foo() {
  let result = churchesRepository.getAll()
  let rxResult = churchesRepository.rx.getAll()
  }
}

let churchesStorage = AnyRxRepository(UserDefaultsRepository<Church>())
let churchesViewModel = ChurchesViewModel(churchesRepository: churchesStorage)
```

If you want  a pure reactive repository implementations for popular storages, check my latest project: [ReactiveXRepository](https://github.com/sashkopotapov/ReactiveXRepository.git)

## 👤 Author
This framework is created by Sashko Potapov.

## 📃 License

XCoordinator is released under an MIT license. See [License.md](https://github.com/sashkopotapov/XRepository/blob/main/LICENSE) for more information.
