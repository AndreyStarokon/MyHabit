//
//  InfoViewController.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 14.04.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    private let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private let textLabel: UILabel = {
       let text = UILabel()
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = StyleStuct.Font.title3
        text.text = "Привычка за 21 день"
        
        text.numberOfLines = 0
        return text
    }()
    
    private let textView: UILabel = {
       let text = UILabel()
        
        text.text = """
        Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:
        
        1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.

        2. Выдержать 2 дня в прежнем состоянии самоконтроля.
        
        3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.

        4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

        5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

        6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.

        Источник: psychbook.ru
        """
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = StyleStuct.Font.body
        text.adjustsFontSizeToFitWidth = true
        text.numberOfLines = 0
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrains()
        view.backgroundColor = .white
        title = "Информация"
    
    }
    
    private func setupConstrains() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
         scrollView.addSubview(contentView)
        
        
        NSLayoutConstraint.activate([
          contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
          contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
          contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
          contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
          contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
   
        contentView.addSubview(textView)
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        textView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ])
       
    }
}


 
