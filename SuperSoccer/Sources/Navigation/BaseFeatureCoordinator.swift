//
//  BaseFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

protocol CoordinatorResult {}

protocol BaseFeatureCoordinatorType: AnyObject {
    var parentCoordinator: (any BaseFeatureCoordinatorType)? { get set }
    func start()
}

class BaseFeatureCoordinator<Result: CoordinatorResult>: BaseFeatureCoordinatorType {
    weak var parentCoordinator: (any BaseFeatureCoordinatorType)?
    private var childCoordinators: [any BaseFeatureCoordinatorType] = []
    
    // The magic closure that handles results and cleanup
    var onFinish: ((Result) -> Void)?
    
    // Automatic child management
    func startChild<ChildResult: CoordinatorResult>(
        _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
        onFinish: @escaping (ChildResult) -> Void
    ) {
        childCoordinators.append(childCoordinator)
        childCoordinator.parentCoordinator = self
        childCoordinator.onFinish = { [weak self, weak childCoordinator] result in
            onFinish(result)
            // Automatic cleanup!
            if let child = childCoordinator {
                self?.removeChild(child)
            }
        }
        childCoordinator.start()
    }
    
    // Called by the coordinator when it's done
    func finish(with result: Result) {
        onFinish?(result)
        // Parent will automatically remove this coordinator
    }
    
    private func removeChild(_ child: any BaseFeatureCoordinatorType) {
        childCoordinators.removeAll { $0 === child }
        child.parentCoordinator = nil
    }
    
    // Subclasses implement this
    func start() {
        fatalError("Subclasses must implement start()")
    }
}

#if DEBUG
extension BaseFeatureCoordinator {
    var testChildCoordinators: [any BaseFeatureCoordinatorType] { childCoordinators }
}
#endif
