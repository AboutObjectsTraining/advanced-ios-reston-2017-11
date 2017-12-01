import UIKit

extension UIStoryboardSegue
{
    open var realDestination: UIViewController? {
        guard let navController = destination as? UINavigationController else { return destination }
        return navController.viewControllers.first
    }
}
