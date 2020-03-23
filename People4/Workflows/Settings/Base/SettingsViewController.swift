import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private var displayTimeTextField: UITextField!
    @IBOutlet private var displayTimeStepper: UIStepper!
    @IBOutlet private var refreshRateTextField: UITextField!
    @IBOutlet private var refreshRateStepper: UIStepper!
    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties

    var viewModel: ISettingsViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    
    @objc func viewDidTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func saveButtonDidTapped() {
        viewModel.saveAction(displayLimit: Int(displayTimeStepper.value), refreshRate: Int(refreshRateStepper.value), selectedIndexes: tableView.indexPathsForSelectedRows ?? [])
    }
    
    @objc func cancelButtonDidTapped() {
        viewModel.cancelAction()
    }
    
    @objc func displayTimeTextFieldEditingChanged(_ textField: UITextField) {
        displayTimeStepper.value = Double(textField.text ?? "0") ?? 0
    }
    
    @objc func refreshRateTextFieldEditingChanged(_ textField: UITextField) {
        refreshRateStepper.value = Double(textField.text ?? "0") ?? 0
    }
    
    @IBAction func displayTimeStepperValueChanged(_ sender: UIStepper) {
        displayTimeTextField.text = String(describing: Int(sender.value))
    }
    
    @IBAction func refreshRateStepperValueChanged(_ sender: UIStepper) {
        refreshRateTextField.text = String(describing: Int(sender.value))
    }
    
    // MARK: - Private
    
    private func bindToViewModel() {
        let settings = viewModel.settings
        refreshRateTextField.text = String(describing: settings.refreshRate)
        refreshRateStepper.value = Double(settings.refreshRate)
        displayTimeTextField.text = String(describing: settings.displayLimit)
        displayTimeStepper.value = Double(settings.displayLimit)
        viewModel.getSelectedIndexes().forEach { [weak self] in
            self?.tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
        }
    }

    private func setupViews() {
        let cellNib = UINib(nibName: CategoryTableViewCell.identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = true
        displayTimeTextField.addTarget(self, action: #selector(displayTimeTextFieldEditingChanged(_:)), for: .editingChanged)
        refreshRateTextField.addTarget(self, action: #selector(refreshRateTextFieldEditingChanged(_:)), for: .editingChanged)
        navigationItem.leftBarButtonItem = .init(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonDidTapped))
        navigationItem.rightBarButtonItem = .init(title: "Save", style: .done, target: self, action: #selector(saveButtonDidTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell
        if let item = viewModel.itemForIndexPath(indexPath) {
            cell?.configure(with: item)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryTableViewCell.height
    }
}
