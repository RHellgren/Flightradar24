//
//  AppDelegate.swift
//  FR24Challenge
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        let flightsLoader = FlightsLoader()

        let flightsViewController = FlightsViewController(
            flightsLoader: flightsLoader
        )
        flightsViewController.tabBarItem = UITabBarItem(
            title: "Flights",
            image: UIImage(systemName: "airplane.circle"),
            selectedImage: nil
        )

        let routeViewController = RouteViewController(
            flightsLoader: flightsLoader
        )
        routeViewController.tabBarItem = UITabBarItem(
            title: "Route",
            image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up"),
            selectedImage: nil
        )

        let tabBarController = UITabBarController()
        
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = UITabBarAppearance()
            tabBarController.tabBar.standardAppearance = UITabBarAppearance()
        }

        tabBarController.setViewControllers(
            [flightsViewController, routeViewController],
            animated: false
        )
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}

