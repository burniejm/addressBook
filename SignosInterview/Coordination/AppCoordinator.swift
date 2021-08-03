//
//  AppCoordinator.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()

    var window: UIWindow?
    var rootViewController: UIViewController?

    public init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        setupUI()
        showMainScreen()
    }

    func setupUI() {
        // Set transparrent nav bar background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
    }
}

private extension AppCoordinator {
    func showMainScreen() {
        let coordinator = MainCoordinator(delegate: self)
        setRootCoordinator(coordinator)
    }

    func setRootCoordinator(_ coordinator: Coordinator) {
        addChildCoordinator(coordinator)
        coordinator.start()
        window?.rootViewController = coordinator.rootViewController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Main Coordinator Delegate

extension AppCoordinator: MainCoordinatorDelegate {
}
