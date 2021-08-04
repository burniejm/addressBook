//
//  MainCoordinator.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
}

final class MainCoordinator: Coordinator {

    weak var delegate: MainCoordinatorDelegate?

    var childCoordinators = [Coordinator]()
    var rootViewController: UIViewController? {
        return rootNavController
    }

    lazy var rootNavController: UINavigationController? = {
        return UIStoryboard.main.instantiateInitialViewController() as? UINavigationController
    }()

    var addressListViewController: AddressListViewController {
        let viewController: AddressListViewController = UIStoryboard.main.getVC()
        viewController.viewModel = AddressListViewModel(delegate: self, persistanceProvider: PlacesPersistanceProviderUserDefaults())
        return viewController
    }

    public init(delegate: MainCoordinatorDelegate?) {
        self.delegate = delegate
    }

    func start() {
        restart()
    }

    private func showNewAddress() {
        let controller: SearchAddressViewController = UIStoryboard.main.getVC()
        controller.viewModel = SearchAddressViewModel()
        rootNavController?.pushViewController(controller, animated: true)
    }

    private func restart() {
        self.rootNavController?.viewControllers = [self.addressListViewController]
    }
}

extension MainCoordinator: AddressListViewModelDelegate {
    func didSelectNewAddress() {
        showNewAddress()
    }
}
