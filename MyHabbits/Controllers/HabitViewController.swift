//
//  HabitViewController.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 18.04.2022.
//

import UIKit

class HabitViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.toAutoLayout()
        collectionView.backgroundColor = StyleStuct.Color.lightGray
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.reuseIdentifier)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private var progressCell: ProgressCollectionViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Сегодня"
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidChangeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
        
    @objc private func deviceDidChangeOrientation() {

        collectionView.reloadData()
    }
    private func setupUI() {
   
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit(_:)))
        
        view.addSubview(collectionView)
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    
    @objc private func addHabit(_ sender: Any) {
        
        let habitVC = HabitsViewController()
        habitVC.completion = { [weak self] in
            self?.collectionView.insertItems(at: [IndexPath(item: HabitsStore.shared.habits.count - 1, section: 1)])
            self?.progressCell?.resetProgress(with: HabitsStore.shared.todayProgress)
        }
        let navigationHabitVC = UINavigationController(rootViewController: habitVC)

        navigationController?.present(navigationHabitVC, animated: true, completion: nil)
        
    }

}

extension HabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return HabitsStore.shared.habits.count
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.reuseIdentifier, for: indexPath) as? ProgressCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(with: HabitsStore.shared.todayProgress)
            
            progressCell = cell
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.reuseIdentifier, for: indexPath) as? HabitCollectionViewCell,
                  HabitsStore.shared.habits.indices.contains(indexPath.item) else { return UICollectionViewCell() }
            
            let habit = HabitsStore.shared.habits[indexPath.item]
            cell.configure(with: habit)
            cell.trackCompletion = { [weak self] in
                self?.progressCell?.resetProgress(with: HabitsStore.shared.todayProgress)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension HabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: StyleStuct.Margin.large, left: StyleStuct.Margin.normal + view.safeAreaInsets.left, bottom: StyleStuct.Margin.small, right: StyleStuct.Margin.normal + view.safeAreaInsets.right)
        default:
            return UIEdgeInsets(top: StyleStuct.Spacing.normal, left: StyleStuct.Margin.normal + view.safeAreaInsets.left, bottom: StyleStuct.Margin.large, right: StyleStuct.Margin.normal + view.safeAreaInsets.right)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        StyleStuct.Spacing.normal
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        StyleStuct.Spacing.normal
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width: CGFloat
        var height: CGFloat
        
        let totalWidth = collectionView.bounds.width

        let horizontalInsets = 2 * StyleStuct.Margin.normal + view.safeAreaInsets.right + view.safeAreaInsets.left
        
        switch indexPath.section {
        
        case 0:
            height = StyleStuct.Size.progressCellHeight
            width = totalWidth - horizontalInsets
            
        default:
            height = StyleStuct.Size.habitCellHeight
            
            let numberOfColumns = Int(totalWidth / StyleStuct.Size.minimumColumnWidth)
            guard numberOfColumns > 0 else { return .zero }
            
            width = ( totalWidth - horizontalInsets - CGFloat(numberOfColumns - 1) * StyleStuct.Spacing.normal) / CGFloat(numberOfColumns)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard HabitsStore.shared.habits.indices.contains(indexPath.item) else { return }
        if indexPath.section > 0 {
        let vc = HabitDetailViewController()
        vc.editCompletion = { [weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: 1))
            self?.progressCell?.resetProgress(with: HabitsStore.shared.todayProgress)
        }
        let habit = HabitsStore.shared.habits[indexPath.item]
        vc.configure(with: habit)
        navigationController?.pushViewController(vc, animated: true)
        }
    }
}
