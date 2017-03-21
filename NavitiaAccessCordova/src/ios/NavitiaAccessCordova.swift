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

    var searchSchedulesViewController:SearchSchedulesViewController?
    @objc(SearchSchedulesViewControllerWrapper:)
    func SearchSchedulesViewControllerWrapper(command: CDVInvokedUrlCommand) {
        if (self.searchSchedulesViewController == nil) {
            self.searchSchedulesViewController = SearchSchedulesViewController()            
        }

        if (self.viewController != nil && self.searchSchedulesViewController != nil) {
            self.searchSchedulesViewController!.launchView(into: self.viewController!)
        } 
    }
}