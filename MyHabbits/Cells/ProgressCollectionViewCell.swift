//
//  ProgressCollectionViewCell.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 18.04.2022.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    static let reuseIdentifier = "ProgressCollectionViewCell"
    
    private let motivationLabel: UILabel = {
        let motivationLabel = UILabel()
        
        motivationLabel.toAutoLayout()
        
        motivationLabel.font = StyleStuct.Font.footnoteStatus
        motivationLabel.textColor = StyleStuct.Color.darkGray
        
        return motivationLabel
    }()

    private let progressLabel: UILabel = {
        let progressLabel = UILabel()
        
        progressLabel.toAutoLayout()
        
        progressLabel.font = StyleStuct.Font.footnoteStatus
        progressLabel.textColor = StyleStuct.Color.darkGray
        
        return progressLabel
    }()
    
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        
        progressBar.toAutoLayout()
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = StyleStuct.Radius.small
        progressBar.backgroundColor = StyleStuct.Color.lightGray
        
        return progressBar
    }()
    
   
    
    func configure(with progress: Float) {
        
        motivationLabel.text = motivationalText(for: progress)
        progressBar.progress = progress
        progressLabel.text = progressLabelText(for: progress)
    }
    
    func resetProgress(with progress: Float) {
        
        let oldProgress = progressBar.progress

        if oldProgress == 0 || progress == 1 {
            motivationLabel.setText(motivationalText(for: progress), animated: true)
        }
        
        progressLabel.setText(progressLabelText(for: progress), animated: true)
        progressBar.setProgress(progress, animated: true)
    }
    
    
    private func motivationalText(for progress: Float) -> String {
        if progress == 0 {
            return StyleStuct.MotivationalSpeeches.start
        } else if progress < 1 {
            return StyleStuct.MotivationalSpeeches.inProgress
        } else {
            return StyleStuct.MotivationalSpeeches.finished
        }
    }
    
    private func progressLabelText(for progress: Float) -> String {
        return "\(Int(progress * 100))%"
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = StyleStuct.Radius.large
        
        contentView.addSubview(motivationLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressBar)
        
        let constraints = [
            motivationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleStuct.Margin.Inner.small),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleStuct.Margin.Inner.normal),
            progressLabel.topAnchor.constraint(equalTo: motivationLabel.topAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleStuct.Margin.Inner.normal),
            progressBar.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: StyleStuct.Margin.Inner.small),
            progressBar.leadingAnchor.constraint(equalTo: motivationLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: progressLabel.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: StyleStuct.Size.progressBarHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
