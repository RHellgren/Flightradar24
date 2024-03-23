//
//  RouteViewController.swift
//  FR24Challenge
//

import UIKit

final class RouteViewController: UIViewController {
    
    private var flightsLoader = FlightsLoader()
    
    private lazy var loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var progressIndicator = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private lazy var originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var originButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = UIMenu(
            options: .displayInline,
            children: [UIAction(title: "---", handler: {_ in })]
        )
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    private lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var destinationButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = UIMenu(
            options: .displayInline,
            children: [UIAction(title: "---", handler: {_ in })]
        )
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        make()
    }
    
    private func make() {
        makeInstall()
        makeConstraints()
        makeStyle()
        makeInteraction()
    }
    
    private func makeInstall() {
        view.addSubview(loadButton)
        view.addSubview(progressIndicator)
        view.addSubview(originLabel)
        view.addSubview(originButton)
        view.addSubview(destinationLabel)
        view.addSubview(destinationButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            loadButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            
            progressIndicator.topAnchor.constraint(
                equalTo: loadButton.bottomAnchor),
            progressIndicator.bottomAnchor.constraint(
                equalTo: originLabel.topAnchor),
            progressIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            
            originLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -Constants.insets.top),
            originLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.insets.left),
            
            originButton.leadingAnchor.constraint(
                equalTo: originLabel.trailingAnchor,
                constant: Constants.spacing),
            originButton.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -Constants.insets.right),
            originButton.topAnchor.constraint(
                equalTo: originLabel.topAnchor),
            originButton.widthAnchor.constraint(
                equalToConstant: Constants.buttonWidth),
            
            destinationLabel.topAnchor.constraint(
                equalTo: originLabel.bottomAnchor,
                constant: Constants.insets.top),
            destinationLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.insets.left),
            
            destinationButton.leadingAnchor.constraint(
                equalTo: destinationLabel.trailingAnchor,
                constant: Constants.spacing),
            destinationButton.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -Constants.insets.right),
            destinationButton.topAnchor.constraint(
                equalTo: destinationLabel.topAnchor),
            destinationButton.widthAnchor.constraint(
                equalToConstant: Constants.buttonWidth)
        ])
    }
    
    private func makeStyle() {
        loadButton.setTitle(String(localized: "Load flights"), for: .normal)
        
        originLabel.text = String(localized: "Origin IATA")
        originButton.setTitle("---", for: .normal)
        
        destinationLabel.text = String(localized: "Destination IATA")
        destinationButton.setTitle("---", for: .normal)
    }
    
    private func makeInteraction() {
        loadButton.addTarget(self, action: #selector(
            loadData), for: .touchUpInside)
    }
    
    @objc
    private func loadData() {
        progressIndicator.startAnimating()
        flightsLoader.loadIATAs { [weak self] iatas in
            Task { @MainActor in
                guard let self else { return }
                self.progressIndicator.stopAnimating()
                self.loadButton.isHidden = true
                
                var originMenu: [UIMenuElement] = [UIAction(title: "---", handler: {_ in })]
                iatas.from.forEach { from in
                    originMenu.append(
                        UIAction(title: from, handler: self.didSelectOrigin)
                    )
                }
                self.originButton.menu = UIMenu(options: .displayInline, children: originMenu)
                
                var destinationMenu: [UIMenuElement] = [UIAction(title: "---", handler: {_ in })]
                iatas.to.forEach { to in
                    destinationMenu.append(
                        UIAction(title: to, handler: self.didSelectDestination)
                    )
                }
                self.destinationButton.menu = UIMenu(options: .displayInline, children: destinationMenu)
            }
        }
    }
    
    @objc
    private func didSelectOrigin(
        _ action: UIAction
    ) {
        // TODO: Find route
    }
    
    @objc
    private func didSelectDestination(
        _ action: UIAction
    ) {
        // TODO: Find route
    }
}

extension RouteViewController {
    struct Constants {
        static let insets = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
        static let spacing: CGFloat = 12
        static let buttonWidth: CGFloat = 150
    }
}
