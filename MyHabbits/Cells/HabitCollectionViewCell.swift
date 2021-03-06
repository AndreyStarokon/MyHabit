//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Ffhh Qerg on 14.04.2022.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HabitCollectionViewCell"
    
    var trackCompletion: (() -> Void)?
    
    private var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            habitColor = habit.color
            isTracked = habit.isAlreadyTakenToday
            
            setupTick()
            
            habitTitleLabel.text = habit.name
            habitTimeLabel.text = habit.dateString

            guard let streakText = streakText() else { return }
            habitRepeatLabel.text = streakText
            
        }
    }
    
    private var isTracked: Bool = false

    private var habitColor: UIColor? {
        didSet {
            guard let habitColor = habitColor else { return }
            habitTitleLabel.textColor = habitColor
            habitTrackTick.layer.borderColor = habitColor.cgColor

            if isTracked {
                habitTrackTick.backgroundColor = habitColor
            }
        }
    }

    
    private let habitTitleLabel: UILabel = {
        let habitTitleLabel = UILabel()
        
        habitTitleLabel.toAutoLayout()
        
        habitTitleLabel.font = StyleStuct.Font.headline
        habitTitleLabel.numberOfLines = 2
        
        return habitTitleLabel
    }()
    
    private let habitTimeLabel: UILabel = {
        let habitTimeLabel = UILabel()
        
        habitTimeLabel.toAutoLayout()
        
        habitTimeLabel.textColor = StyleStuct.Color.gray
        habitTimeLabel.font = StyleStuct.Font.caption
        
        return habitTimeLabel
    }()
    
    private let habitRepeatLabel: UILabel = {
        let habitRepeatLabel = UILabel()
        
        habitRepeatLabel.toAutoLayout()
        
        habitRepeatLabel.textColor = StyleStuct.Color.darkGray
        habitRepeatLabel.font = StyleStuct.Font.footnote
        
        return habitRepeatLabel
    }()
    
    private lazy var habitTrackTick: UIView = {
        let habitTrackTick = UIView()
        
        habitTrackTick.toAutoLayout()
        
        habitTrackTick.clipsToBounds = true
        habitTrackTick.layer.cornerRadius = StyleStuct.Size.habitTrackTickSize / 2
        
        habitTrackTick.isUserInteractionEnabled = true
        
        let tickImageView = UIImageView()
        tickImageView.image = #imageLiteral(resourceName: "tick_icon")
        tickImageView.backgroundColor = .clear
        
        tickImageView.toAutoLayout()
        
        habitTrackTick.addSubview(tickImageView)
        
        let constraints = [
            tickImageView.centerYAnchor.constraint(equalTo: habitTrackTick.centerYAnchor),
            tickImageView.centerXAnchor.constraint(equalTo: habitTrackTick.centerXAnchor),
            tickImageView.heightAnchor.constraint(equalToConstant: 15),
            tickImageView.widthAnchor.constraint(equalToConstant: 15)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTick(_:)))
        habitTrackTick.addGestureRecognizer(tapGestureRecognizer)
        
        return habitTrackTick
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    func configure(with habit: Habit) {
        self.habit = habit
    }
    
    private func streakText() -> String? {
        guard let habit = habit else { return nil }
        return "????????????: \(habit.trackDates.count)"
    }
    
    private func setupTick() {
        if isTracked {
            habitTrackTick.backgroundColor = habitColor
            habitTrackTick.layer.borderWidth = .zero
        } else {
            habitTrackTick.backgroundColor = .white
            habitTrackTick.layer.borderWidth = StyleStuct.Size.habitTrackTickBorder
        }

    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = StyleStuct.Radius.large
        
        contentView.addSubview(habitTitleLabel)
        contentView.addSubview(habitTimeLabel)
        contentView.addSubview(habitRepeatLabel)
        contentView.addSubview(habitTrackTick)
        
        let constraints = [
            habitTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleStuct.Margin.Habit.normal),
            habitTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleStuct.Margin.Habit.normal),
            habitTimeLabel.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: StyleStuct.Spacing.smallest),
            habitTimeLabel.leadingAnchor.constraint(equalTo: habitTitleLabel.leadingAnchor),
            habitTimeLabel.trailingAnchor.constraint(equalTo: habitTitleLabel.trailingAnchor),
            habitRepeatLabel.leadingAnchor.constraint(equalTo: habitTitleLabel.leadingAnchor),
            habitRepeatLabel.trailingAnchor.constraint(equalTo: habitTitleLabel.trailingAnchor),
            habitRepeatLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleStuct.Margin.Habit.normal),
            habitTrackTick.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleStuct.Margin.large),
            habitTrackTick.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            habitTrackTick.widthAnchor.constraint(equalToConstant: StyleStuct.Size.habitTrackTickSize),
            habitTrackTick.heightAnchor.constraint(equalToConstant: StyleStuct.Size.habitTrackTickSize),
            habitTrackTick.leadingAnchor.constraint(greaterThanOrEqualTo: habitTitleLabel.trailingAnchor, constant: StyleStuct.Margin.Habit.giant)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    @objc private func tapTick(_ sender: Any) {
        
        guard !isTracked else { return }
        
        isTracked = true
        
        habitTrackTick.backgroundColor = habitColor?.withAlphaComponent(0)
        UIView.animate(withDuration: 0.2) {
            self.habitTrackTick.backgroundColor = self.habitColor?.withAlphaComponent(1)
            self.habitTrackTick.layer.borderWidth = .zero
        }

        
        guard let habit = habit else { return }
        HabitsStore.shared.track(habit)

        guard let streakText = streakText() else { return }
        habitRepeatLabel.setText(streakText, animated: true)

        trackCompletion?()
        
    }
}
