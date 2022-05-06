//
//  HabitsDetailViewController.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 18.04.2022.
//

import UIKit

class HabitDetailViewController: UIViewController {
    weak var delegate:HabitsViewController?
    
    var habit: Habit?
    var editCompletion: (() -> Void)?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.toAutoLayout()
        
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: StyleStuct.ReuseIdentifier.habitDetail)
        
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    func configure(with habit: Habit) {
        self.habit = habit
        title = habit.name
    }
    
    
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit(_:)))
        
        view.addSubview(tableView)
        view.backgroundColor = StyleStuct.Color.lightGray
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    
    @objc private func editHabit(_ sender: Any) {
        guard let habit = habit else { return }
        let habitVc = HabitsViewController()
        habitVc.timePicker.date = habit.date
        habitVc.configure(with: habit)
        habitVc.completion = { [weak self] in
            
            guard let self = self else { return }
            
            self.title = habit.name
            
            if let editCompletion = self.editCompletion {
                editCompletion()
            }

            if !HabitsStore.shared.habits.contains(habit) {
                self.navigationController?.popViewController(animated: true)
            }
        }
       let navigationVC = UINavigationController(rootViewController: habitVc)

       navigationController?.present(navigationVC, animated: true, completion: nil)
    }
}

extension HabitDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: StyleStuct.ReuseIdentifier.habitDetail)
        let date = HabitsStore.shared.dates.reversed()[indexPath.row]
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.doesRelativeDateFormatting = true

        cell.textLabel?.text = formatter.string(from: date)
        
        if let habit = habit {
            if HabitsStore.shared.habit(habit, isTrackedIn: date) {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Активность"
    }
    
}
