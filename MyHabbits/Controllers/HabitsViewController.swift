//
//  HabbitsViewController.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 14.04.2022.
//

import UIKit

class HabitsViewController: UIViewController {
    
    var completion: (() -> Void)?
    private var habit: Habit?
    private var actionType: StyleStuct.ActionType = .create
    private var habitTitle: String?
    private var habitColor: UIColor = StyleStuct.Defaults.habitColor {
        didSet {
            colorIndicator.backgroundColor = habitColor
            titleTextField.textColor = habitColor
        }
    }
    
     var habitTime: Date? {
        didSet {
            
            guard let habitTime = habitTime else { return }
            
            let formatter = DateFormatter()
            
            formatter.dateStyle = .none
            formatter.timeStyle = .short

            timeIndicatorLabel.text = formatter.string(from: habit?.date ?? habitTime)
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.toAutoLayout()
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        
        contentView.toAutoLayout()
        
        return contentView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel.titleFor(input: "Название")
        
        titleLabel.toAutoLayout()
        
        return titleLabel
    }()
    
    private lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()
        
        titleTextField.toAutoLayout()
        titleTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        titleTextField.textColor = habitColor
        titleTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(textFieldEditindDidBegin(_:)), for: .editingDidBegin)
        titleTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        return titleTextField
    }()
    
    private let colorLabel: UILabel = {
        let colorLabel = UILabel.titleFor(input: "Цвет")
        
        colorLabel.toAutoLayout()
        
        return colorLabel
    }()
    
    private lazy var colorIndicator: UIView = {
        let colorIndicator = UIView()
        
        colorIndicator.toAutoLayout()

        colorIndicator.clipsToBounds = true
        colorIndicator.layer.cornerRadius = StyleStuct.Size.habitColorIndicator / 2
        
        colorIndicator.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapColor(_:)))
        colorIndicator.addGestureRecognizer(tapGestureRecognizer)
        
        return colorIndicator
    }()
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel.titleFor(input: "Время")
        
        timeLabel.toAutoLayout()
        
        return timeLabel
    }()
    
    private let timeIndicatorPrefix: UILabel = {
        let timeIndicatorPrefix = UILabel()
        
        timeIndicatorPrefix.toAutoLayout()
        timeIndicatorPrefix.text = "Каждый день в "
        timeIndicatorPrefix.font = StyleStuct.Font.body
        
        return timeIndicatorPrefix
    }()
    
    private let timeIndicatorLabel: UILabel = {
        let timeIndicatorLabel = UILabel()
        
        timeIndicatorLabel.toAutoLayout()
        timeIndicatorLabel.textColor = StyleStuct.Color.accent
        timeIndicatorLabel.font = StyleStuct.Font.body
        
        return timeIndicatorLabel
    }()
    
   lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        
        timePicker.toAutoLayout()
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        timePicker.addTarget(self, action: #selector(pickerSet(sender:)), for: .valueChanged)
        
        
        return timePicker
    }()
    
    private lazy var colorPickerVc: UIColorPickerViewController = {
        let colorPickerVc = UIColorPickerViewController()
        
        colorPickerVc.delegate = self
        colorPickerVc.supportsAlpha = false
        
        return colorPickerVc
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        
        deleteButton.toAutoLayout()
        deleteButton.setTitle("Удалить привычку", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        
        deleteButton.addTarget(self, action: #selector(deleteHabit(_:)), for: .touchUpInside)
        
        return deleteButton
    }()
    
    private lazy var deleteButtonPrimaryBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(
            item: self.deleteButton,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.view.safeAreaLayoutGuide,
            attribute: .bottom,
            multiplier: 1,
            constant: -StyleStuct.Margin.normal / 2
        )
        return constraint
    }()
    
    private lazy var deleteButtonSecondaryBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(
            item: self.deleteButton,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .bottom,
            multiplier: 1,
            constant: -StyleStuct.Margin.normal / 2
        )
        return constraint
    }()

 
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            switch actionType {
            case .create:
                scrollView.contentInset.bottom = keyboardSize.height
                scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            case .edit:
                deleteButtonPrimaryBottomConstraint.isActive = false
                deleteButtonSecondaryBottomConstraint.isActive = true
                self.deleteButtonSecondaryBottomConstraint.constant = -keyboardSize.height
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutSubviews()
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        switch actionType {
        case .create:
            scrollView.contentInset.bottom = .zero //insetAdjustment
            scrollView.verticalScrollIndicatorInsets = .zero //UIEdgeInsets(top: 0, left: 0, bottom: insetAdjustment, right: 0)
        case .edit:
            deleteButtonSecondaryBottomConstraint.isActive = false
            deleteButtonPrimaryBottomConstraint.isActive = true
        }
    }
    
    
    @objc private func textFieldEditindDidBegin(_ sender: Any) {
        titleTextField.font = StyleStuct.Font.body
        
    }
    
    @objc private func textFieldEditingDidEnd(_ sender: Any) {
        if let habitTitle = habitTitle,
           habitTitle.count > 0 {
            titleTextField.font = StyleStuct.Font.headline
        } else {
            titleTextField.font = StyleStuct.Font.body
        }
    }

    
    func configure(with habit: Habit) {
        actionType = .edit
        self.habit = habit
        habitTitle = habit.name
        habitTime = habit.date
        habitColor = habit.color
        
        titleTextField.text = habit.name
        titleTextField.font = StyleStuct.Font.headline
    }
    
    private func setupUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit(_:)))
        
        switch actionType {
        case .create:
            title = "Создать"
        case .edit:
            title = "Править"
        }
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorIndicator)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeIndicatorPrefix)
        contentView.addSubview(timeIndicatorLabel)
        contentView.addSubview(timePicker)
        
        var constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleStuct.Margin.large),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleStuct.Margin.normal),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: StyleStuct.Margin.normal),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: StyleStuct.Spacing.small),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleStuct.Margin.normal),
            
            colorLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: StyleStuct.Spacing.large),
            colorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            colorIndicator.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: StyleStuct.Spacing.small),
            colorIndicator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            colorIndicator.widthAnchor.constraint(equalToConstant: StyleStuct.Size.habitColorIndicator),
            colorIndicator.heightAnchor.constraint(equalToConstant: StyleStuct.Size.habitColorIndicator),
            
            timeLabel.topAnchor.constraint(equalTo: colorIndicator.bottomAnchor, constant: StyleStuct.Spacing.large),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            timeIndicatorPrefix.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: StyleStuct.Spacing.small),
            timeIndicatorPrefix.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            timeIndicatorLabel.topAnchor.constraint(equalTo: timeIndicatorPrefix.topAnchor),
            timeIndicatorLabel.leadingAnchor.constraint(equalTo: timeIndicatorPrefix.trailingAnchor),
            timeIndicatorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            timePicker.topAnchor.constraint(equalTo: timeIndicatorPrefix.bottomAnchor, constant: StyleStuct.Spacing.large),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        

        switch actionType {
        
        case .create:
            constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
            
        case .edit:
            view.addSubview(deleteButton)
            constraints.append(contentsOf: [
                deleteButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteButtonPrimaryBottomConstraint
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
        
        colorIndicator.backgroundColor = habitColor
    }

    
    @objc private func pickerSet(sender: UIDatePicker) {
        self.setTime(from: sender)
    }
    
     func setTime(from timePicker: UIDatePicker) {
         
                habitTime = timePicker.date
     }
    @objc private func saveHabit(_ sender: Any) {
        
        guard let habitTitle = habitTitle,
              !habitTitle.isEmpty,
              let habitTime = habitTime else {
            
            let alertVC = UIAlertController(title: "Невозможно сохранить привычку!", message: "Для сохранения проивычки все поля должны быть заполнены", preferredStyle: .alert)
            let alertOkAction = UIAlertAction(title: "Понятно", style: .default, handler: nil)
            alertVC.addAction(alertOkAction)
            navigationController?.present(alertVC, animated: true, completion: nil)
            
            return
        }
        let newHabit = Habit(name: habitTitle,
                             date: habitTime,
                             color: habitColor)

        switch actionType {
        case .create:
            let store = HabitsStore.shared
            store.habits.append(newHabit)
        case .edit:
            guard let oldHabit = habit else {
                print("Возникла ошибка при редактировании привычки")
                return
            }
            
            if  oldHabit != newHabit {
                oldHabit.name = habitTitle
                oldHabit.date = habitTime
                oldHabit.color = habitColor
                HabitsStore.shared.save()
            }
        }
        
        self.close(sender)
        
    }
   
        
        
    @objc private func deleteHabit(_ sender: Any) {
        guard let habit = habit else { return }
        let alertVC = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(habit.name)\"?", preferredStyle: .alert)
        let alertDeleteAction = UIAlertAction(title: "Удалить", style: .destructive) { action in
            guard let index = HabitsStore.shared.habits.firstIndex(of: habit) else {
                print("Возникла ошибка при редактировании привычки")
                return
            }
            
            HabitsStore.shared.habits.remove(at: index)
            
            self.close(sender)
        
        }
        let alertCancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertVC.addAction(alertCancelAction)
        alertVC.addAction(alertDeleteAction)
        navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: completion)
    }
    
    @objc private func tapColor(_ sender: Any) {
        colorPickerVc.selectedColor = habitColor
        navigationController?.present(colorPickerVc, animated: true, completion: nil)
    }
    
    @objc private func textFieldEditingChanged(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        habitTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
   
}

extension HabitsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        habitColor = viewController.selectedColor
    }
}


