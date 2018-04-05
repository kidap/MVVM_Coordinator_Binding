# MVVM_Coordinator_Binding

![image](https://user-images.githubusercontent.com/8204242/38104138-4e2b55e0-3356-11e8-9a8a-8ff8ace76919.png)


# Usage 
## NavigationControllerCoordinator

```
class FlowCoordinator: NSObject {
    
    //Coordinator Protocol Requirements
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController { return navigationController }
    
    //NavigationControllerCoordinator Protocol Requirements
    var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    
    override init() {
        super.init()
        navigationController.delegate = self
    }
}

//MARK:- Coordinator
extension FlowCoordinator: NavigationControllerCoordinator {
    func start() {
        showMainViewController()
    }
    
    // UINavigationControllerDelegate - required in classes that conform to NavigationControllerCoordinator *boilerplate*
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationControllerTransitioned(navigationController, didShow: viewController, animated: animated)
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
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController { return tabBarController }
    
    // TabBarControllerCoordinator Protocol Requirements
    let tabBarController: UITabBarController = UITabBarController(nibName: nil, bundle: nil)
}

//MARK:- Coordinator
extension MainTabBarCoordinator: TabBarControllerCoordinator {
    func start() {
        let flowCoordinator = FlowCoordinator()
        let exitCoordinator = ExitCoordinator() { [unowned self] in
            self.didFinish?()
        }
        
        add(childCoordinators: [flowCoordinator, exitCoordinator])
    }
}
```
