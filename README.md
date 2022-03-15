<p align="center">
<br>
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchO-333333.svg" alt="Supported Platforms: iOS, macOS, tvOS, watchOS" />
<br/>
<a><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
<a><img src="https://img.shields.io/badge/License-MIT-yellow.svg" /></a>
</p>
<p align="center">
<font size="24">🍊 + 🍬</font>
</p>


**RxXRepository** is reactive extension for [XRepository](https://github.com/sashkopotapov/XRepository). This extension allows implementations of Repository pattern become rx-compatable and adds observing methods to CRUD operations.

##  Getting started
To make your Repository reactive, simply conform it to `RxRepository`  protocol and implement three following methods, because all CRUD methods has default implementatons accesible throug `repository.rx.getAll()` signature.
<p align="center">
  <img src="snippetOne.png"/>
</p>



And you have to change `AnyRepository` to `AnyRxRepository`. Thats all. Your repository is rx-compatible.


## Usage
Usage is simple, as we are using abstract `AnyRxRepository`:
<p align="center">
  <img src="snippetTwo.png"/>
</p>

You have default implementation or all your CRUD operations and all the great sugar from `Repository` also comes to observing methods:

<p align="center">
  <img src="snippetThree.png"/>
</p>

## 👤 Author
This framework is created by Sashko Potapov.

## 📃 License

XCoordinator is released under an MIT license. See [License.md](https://github.com/sashkopotapov/XRepository/blob/main/LICENSE) for more information.
