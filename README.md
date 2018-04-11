# MVVM_Coordinator_Binding

![image](https://user-images.githubusercontent.com/8204242/38104138-4e2b55e0-3356-11e8-9a8a-8ff8ace76919.png)


# Usage 
## NavigationControllerCoordinator

```
class FlowCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    
    //NavigationControllerCoordinator Protocol Requirements
    var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    var navigationControllerCoordinatorDelegate: NavigationControllerCoordinatorDelegate { return NavigationControllerCoordinatorDelegate(coordinator: self)
    }

    init() {
        navigationController.delegate = navigationControllerCoordinatorDelegate
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension FlowCoordinator: NavigationControllerCoordinator {
    func start() {
        print("✅ Starting FlowCoordinator")
        showMainViewController()
    }
}

//MARK:- Private Methods
private extension FlowCoordinator {
    func showMainViewController() {
        let childCoordinator = MainCoordinator() { [unowned self] in
            self.showDetail()
        }
        push(childCoordinator, animated: true)
    }
    
    func showDetail() {
        let childCoordinator = DetailCoordinator()
        childCoordinator.onClose = { [unowned childCoordinator] in
            childCoordinator.didFinish?()
        }
        push(childCoordinator, animated: true)
    }
}
```
## TabBarControllerCoordinator
```
class MainTabBarCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    
    // TabBarControllerCoordinator Protocol Requirements
    let tabBarController: UITabBarController = UITabBarController(nibName: nil, bundle: nil)
    
    // Private variables
    var onExit: (()->())!
    
    init() {
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension MainTabBarCoordinator: TabBarControllerCoordinator {
    func start() {
        let flowCoordinator = FlowCoordinator()
        let exitCoordinator = ExitCoordinator() { [unowned self] in
            self.onExit()
        }
        
        add(childCoordinators: [flowCoordinator, exitCoordinator])
    }
}
```
