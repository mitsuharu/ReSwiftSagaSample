Sample Project for Redux Saga with ReSwift
==

- [Redux Saga](https://redux-saga.js.org/) を Swift で再現したサンプルプロジェクトです。
- 完全再現ではなく、設計思想を参考にしつつ、一部機能を再現しています
- このサンプルコードは、MVVM + Redux Saga を採用しています

## Develop

- Xcode 14.3.1


## EFFECTS

現在、下記の effect をサポートしています。

- put
- selector
- call
- fork
- take
- takeEvery
- takeLatest
- takeLeading


## USAGE

### Redux

- [ReSwift](https://github.com/ReSwift/ReSwift) 6.1.1 を利用しています。
- Store の生成時に `createSagaMiddleware` で生成した middleware を追加します。

```swift
func makeAppStore() -> Store<AppState> {
    
    // Saga 用の middeware を生成する
    let sagaMiddleware: Middleware<AppState> = createSagaMiddleware()
    
    let store = Store<AppState>(
        reducer: appReducer,
        state: AppState.initialState(),
        middleware: [sagaMiddleware]
    )
    return store
}
```


### Action

- Action は class で生成します


```swift
class UserAction: SagaAction {}

class RequestUser: UserAction {
    let userID: String
    init(userID: String) {
        self.userID = userID
    }
}

class StoreUserName: UserAction {
    let name: String
    init(name: String) {
        self.name = name
    }
}
```

### Saga

```swift
let userSaga: Saga = { _ in
    takeEvery(RequestUser.self, saga: requestUserSaga)
}

let requestUserSaga: Saga = { action async in
    guard let action = action as? RequestUser else {
        return
    }
    
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    let name = "dummy-user-" + String( Int.random(in: 0..<100))
    put(StoreUserName(name: name))
}
```


### dispatch

```swift
import Foundation
import ReSwift

final class UserViewModel: ObservableObject, StoreSubscriber {
    @Published private(set) var name: String = ""

    init() {
        appStore.subscribe(self) {
            $0.select { selectUserName(store: $0) }
        }
    }

    deinit {
        appStore.unsubscribe(self)
    }

    internal func newState(state: String) {
        self.name = state
    }
    
    public func requestUser() {
        appStore.dispatch(RequestUser(userID: "1234"))
    }    
}
```

