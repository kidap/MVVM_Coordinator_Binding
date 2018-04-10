//
//  ChildViewControllers.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import CoreData

//----------------------------------------------------------------------
//    LEFT
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class LeftViewModel {
    struct State {
        var text: Observable<String?>
        var textOnViewContext: Observable<String?>
    }
    
    var state: State = State(text: Observable(""), textOnViewContext: Observable(""))
    
    private let person: Person
    private let container: NSPersistentContainer
    private var observer: NSObjectProtocol?
    private let context: NSManagedObjectContext = {
        let context = CoreDataManager.newMainContext()
        context.automaticallyMergesChangesFromParent = true
       return context
    }()
    
    init(container: NSPersistentContainer = CoreDataManager.container) {
        self.container = container
        
        person = CoreDataManager.person(in: container)
        state = State(text: Observable(person.name), textOnViewContext: Observable(person.name))
        
        _ = state.text.observeNext(with: self.saveOnChange)
        _ = state.textOnViewContext.observeNext { (text) in
            self.person.name = text
        }
    }
    
    func saveOnChange(_ name: String?) {
        guard let name = name else { return  }
        
        let objectID: NSManagedObjectID = self.person.objectID
        
        observer = context.performBlockAndUpdate(notificationCenter: NotificationCenter.default) { [unowned context] in
            let person = context.object(with: objectID) as! Person
            
            person.name = name
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func saveViewContext() {
        do {
            try CoreDataManager.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    deinit {
        print("☠️deallocing \(self)")
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class LeftViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldOnViewContext: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: LeftViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: LeftViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = viewModel.state.text.value
        textFieldOnViewContext.text = viewModel.state.textOnViewContext.value
        setupBindings()
    }
    
    func setupBindings() {
        textField.reactive.text.bind(to: viewModel.state.text).dispose(in: disposeBag)
        textFieldOnViewContext.reactive.text.bind(to: viewModel.state.textOnViewContext).dispose(in: disposeBag)
        saveButton.reactive.tap.observeNext(with: viewModel.saveViewContext).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

//----------------------------------------------------------------------
//    RIGHT
//----------------------------------------------------------------------

//------------------
// VIEW MODEL
//------------------
class RightViewModel {
    struct State {
        var text: Observable<String?>
    }
    
    var state: State
    var onDetail: (() -> ())
    var onPopup: (() -> ())
    
    private let person: Person
    private let container: NSPersistentContainer
    
    init(text: String, container: NSPersistentContainer = CoreDataManager.container, onDetail: @escaping () -> (), onPopup: @escaping () -> ()) {
        self.container = container
        self.onDetail = onDetail
        self.onPopup = onPopup
        
        person = CoreDataManager.person(in: container)
        state = State(text: Observable(person.name))

        let context = container.viewContext
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: NSNotification.Name.NSManagedObjectContextWillSave, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        print("---------------------------------------")
        print("RightViewModel")
        print("---------------------------------------")
        print("managedObjectContextObjectsDidChange")
        
        // Changes on the backgroundContext after a save
        let refreshed: Set<NSManagedObject> = notification.userInfo?["refreshed"] as? Set<NSManagedObject> ?? []
        
        //Changes on the viewContext even if it's not yet saved
        let updated: Set<NSManagedObject> = notification.userInfo?["updated"] as? Set<NSManagedObject> ?? []
        
        let objectsThatChanged = refreshed.union(updated)
        print(objectsThatChanged)
        
        objectsThatChanged
            .filter(byEntityName: Person.entity().name!)
            .forEach {
                state.text.value = $0.value(forKey: "name") as? String
            }
    }
    
    @objc func managedObjectContextWillSave(notification: NSNotification) {
        print("managedObjectContextWillSave")
    }
    
    @objc func managedObjectContextDidSave(notification: NSNotification) {
        print("managedObjectContextDidSave")
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class RightViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var showDetailButton: UIButton!
    @IBOutlet weak var showPopupButton: UIButton!
    var viewModel: RightViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: RightViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.state.text.bind(to: label.reactive.text).dispose(in: disposeBag)
        showDetailButton.reactive.tap.observeNext(with: viewModel.onDetail).dispose(in: disposeBag)
        showPopupButton.reactive.tap.observeNext(with: viewModel.onPopup).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

//----------------------------------------------------------------------
//    BOTTOM LEFT
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class BottomLeftViewModel {
    let collapseTitle = "Collapse"
    let expandTitle = "Expand"
    let collapseHeight = CGFloat(50)
    let expandHeight = CGFloat(100)
    
    struct State {
        var text: Observable<String?>
        var isExpanded: Observable<Bool>
        var expandButtonTitle: Observable<String?>
        var height: Observable<CGFloat>
    }
    var state: State
    let onDetail: (() -> ())
    private let container: NSPersistentContainer
    var person: Person
    
    init(text: String, isExpanded: Bool, container: NSPersistentContainer = CoreDataManager.container, onDetail: @escaping () -> ()) {
        self.container = container
        self.onDetail = onDetail
        person = CoreDataManager.person(in: container)
        
        state = State(text: Observable(text), isExpanded: Observable(isExpanded), expandButtonTitle: Observable(expandTitle), height: Observable(collapseHeight))
        
        
        let context = container.viewContext
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: NSNotification.Name.NSManagedObjectContextWillSave, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        print("---------------------------------------")
        print("BottomLeftViewModel")
        print("---------------------------------------")
        print("managedObjectContextObjectsDidChange")
        
        // Changes on the backgroundContext after a save
        let refreshed: Set<NSManagedObject> = notification.userInfo?["refreshed"] as? Set<NSManagedObject> ?? []
        
        //Changes on the viewContext even if it's not yet saved
        let updated: Set<NSManagedObject> = notification.userInfo?["updated"] as? Set<NSManagedObject> ?? []
        
        let objectsThatChanged = refreshed.union(updated)
        print(objectsThatChanged)
        
        objectsThatChanged
            .filter(byEntityName: Person.entity().name!)
            .forEach {
                state.text.value = $0.value(forKey: "name") as? String
        }
    }
    
    @objc func managedObjectContextWillSave(notification: NSNotification) {
        print("managedObjectContextWillSave")
    }
    
    @objc func managedObjectContextDidSave(notification: NSNotification) {
        print("managedObjectContextDidSave")
    }
    
    func toggleViewSize() {
        state.isExpanded.value = !state.isExpanded.value
        state.expandButtonTitle.value = state.isExpanded.value ? collapseTitle : expandTitle
        state.height.value = state.isExpanded.value ? expandHeight : collapseHeight
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class BottomLeftViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var showDetailButton: UIButton!
    var viewModel: BottomLeftViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: BottomLeftViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        expandButton.reactive.tap.observeNext(with: viewModel.toggleViewSize).dispose(in: disposeBag)
        showDetailButton.reactive.tap.observeNext(with: viewModel.onDetail).dispose(in: disposeBag)
        viewModel.state.text.bind(to: label).dispose(in: disposeBag)
        viewModel.state.expandButtonTitle.bind(to: expandButton.reactive.title).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}
