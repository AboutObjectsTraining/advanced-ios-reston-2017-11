import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        configureAppearance()
    }
}

// TODO: Global Appearance Configuration
extension AppDelegate
{
    func configureAppearance() {
        UIView.appearance().tintColor = UIColor.purple
        UITableViewCell.appearance().backgroundColor = UIColor.tableCellBackground
        UILabel.appearance(whenContainedInInstancesOf: [BookDetailController.self, ReadingListController.self]).defaultTextColor = UIColor.labelColor
    }
}

// UIResponder Methods - Global Behaviors
extension AppDelegate
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UILabel {
    @objc var defaultTextColor: UIColor {
        get { return textColor }
        set { textColor = newValue }
    }
}

extension UIColor {
    class var tableCellBackground: UIColor {
        return UIColor(red: 1, green: 0.99, blue: 0.98, alpha: 1)
    }
    
    class var labelColor: UIColor {
        return UIColor(red: 0.25, green: 0.15, blue: 0, alpha: 1)
    }
}
