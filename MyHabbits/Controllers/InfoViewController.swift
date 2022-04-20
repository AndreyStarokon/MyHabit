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
    
    private let textView: UILabel = {
       let text = UILabel()
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Привычка формируется в процессе неоднократного выполнения действия до той стадии его освоения, когда при его исполнении уже не возникает к.-л. трудностей волевого или познавательного характера. Здесь идет речь о привыкании — прекращение или снижение остроты реагирования на ещё продолжающий действовать раздражитель, который вызывает эмоционально положительные состояния в период реализации привычки и, напротив, рождает отрицательные переживания в обстоятельствах, мешающих её осуществлению. Однажды выработанная, привычка часто продолжает оставаться и после устранения причинных факторов, приведших к её развитию. Поведенческая психотерапия основывается на положении, что деструктивные привычки путём обучения могут быть заменены на более адекватные[5] Привычка формируется в процессе неоднократного выполнения действия до той стадии его освоения, когда при его исполнении уже не возникает к.-л. трудностей волевого или познавательного характера. Здесь идет речь о привыкании — прекращение или снижение остроты реагирования на ещё продолжающий действовать раздражитель, который вызывает эмоционально положительные состояния в период реализации привычки и, напротив, рождает отрицательные переживания в обстоятельствах, мешающих её осуществлению. Однажды выработанная, привычка часто продолжает оставаться и после устранения причинных факторов, приведших к её развитию. Поведенческая психотерапия основывается на положении, что деструктивные привычки путём обучения могут быть заменены на более адекватные[5]"
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
        
        NSLayoutConstraint.activate([
        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
        ])
       
    }
}
