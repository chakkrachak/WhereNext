import Foundation
import UIKit

@objc(NavitiaAccessCordova) class NavitiaAccessCordova : CDVPlugin {
    @objc(echo:)
    func echo(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )

        let msg = command.arguments[0] as? String ?? ""

        if msg.characters.count > 0 {
            let toastController: UIAlertController =
                UIAlertController(
                    title: "",
                    message: msg,
                    preferredStyle: .alert
            )

            self.viewController?.present(
                toastController,
                animated: true,
                completion: nil
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                toastController.dismiss(
                    animated: true,
                    completion: nil
                )
            }

            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }

        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    let searchSchedulesViewController = SearchSchedulesViewController()

    @objc(SearchSchedulesViewControllerWrapper:)
    func SearchSchedulesViewControllerWrapper(command: CDVInvokedUrlCommand) {
        var storyBoard:UIStoryboard? = nil
        storyBoard = UIStoryboard(name: "Main", bundle: nil)

        if let sb = storyBoard {

            // step 3. create new window
            var window = UIWindow(frame: UIScreen.main.bounds)

            // step 4. start view controller
            window.rootViewController = sb.instantiateInitialViewController()! as UIViewController

            // step 5. make key window & visible
            window.makeKeyAndVisible()

            searchSchedulesViewController.launchView(into: window.rootViewController!)

        }
    }
}