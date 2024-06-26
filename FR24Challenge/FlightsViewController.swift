//
//  FlightsViewController.swift
//  FR24Challenge
//

import UIKit

final class FlightsViewController: UIViewController {
    
    private let flightsLoader: FlightsLoader!
    
    // MARK: - Subviews
    
    private lazy var flightsView = FlightsView()

    // MARK: - Initialiser
    
    init(
        flightsLoader: FlightsLoader
    ) {
        self.flightsLoader = flightsLoader
        self.state = .initial()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycke
    
    override func loadView() {
        view = flightsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        flightsView.loadButton.addTarget(self, action: #selector(loadFlights), for: .touchUpInside)
        flightsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        flightsView.tableView.dataSource = self
        updateWithState(state)
    }
    
    // MARK: - Load flights

    @objc
    private func loadFlights() {
        state = .loading()
        flightsLoader.loadFlights { [weak self] flights in
            Task { @MainActor in
                self?.state = .loaded(flights: flights)
            }
        }
    }

    // MARK: - State
    
    fileprivate struct State {
        let loadButtonHidden: Bool
        let progressIndicatorHidden: Bool
        let tableViewHidden: Bool
        let flights: [String]

        static func initial() -> State {
            State(
                loadButtonHidden: false,
                progressIndicatorHidden: true,
                tableViewHidden: true,
                flights: []
            )
        }
        static func loading() -> State {
            State(
                loadButtonHidden: true,
                progressIndicatorHidden: false,
                tableViewHidden: true,
                flights: []
            )
        }
        static func loaded(flights: [String]) -> State {
            State(
                loadButtonHidden: true,
                progressIndicatorHidden: true,
                tableViewHidden: false,
                flights: flights
            )
        }
    }

    private var state = State.initial() {
        didSet {
            updateWithState(state)
        }
    }

    @MainActor
    private func updateWithState(
        _ state: State
    ) {
        flightsView.loadButton.isHidden = state.loadButtonHidden
        flightsView.progressIndicator.isHidden = state.progressIndicatorHidden
        flightsView.tableView.isHidden = state.tableViewHidden
        flightsView.tableView.reloadData()
    }
}

extension FlightsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        state.flights.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = String(localized: "Flight: \(state.flights[indexPath.row])")
        return cell
    }
}

private final class FlightsView: UIStackView {

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        axis = .vertical
        loadButton.setTitle(String(localized: "Load flights"), for: .normal)
        progressIndicator.startAnimating()
        progressIndicator.style = .medium
        [loadButton, progressIndicator, tableView].forEach { view in
            addArrangedSubview(view)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let loadButton = UIButton(type: .system)
    let progressIndicator = UIActivityIndicatorView()
    let tableView = UITableView()
}
