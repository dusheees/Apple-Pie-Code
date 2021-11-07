//
//  ViewController.swift
//  Apple Pie Code
//
//  Created by Андрей on 07.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UIProperties
    let buttonsStackView = UIStackView()
    let correctWordLabel = UILabel()
    var letterButtons = [UIButton]()
    let scoreLabel = UILabel()
    let stackView = UIStackView()
    let topStackView = UIStackView()
    let treeImageView = UIImageView()
    
    // MARK: - Properties
    var currentGame: Game! //опциональное значение
    let incorrectMovesAllowed = 7
    var listOfWords = [
        "Александрия",
        "Атланта",
        "Ахмедабад",
        "Багдад",
        "Бангалор",
        "Бангкок",
        "Барселона",
        "Белу-Оризонти",
        "Богота",
        "Буэнос-Айрес",
        "Вашингтон",
        "Гвадалахара",
        "Гонконг",
        "Гуанчжоу",
        "Дакка",
        "Даллас",
        "Далянь",
        "Дар-эс-Салам",
        "Дели",
        "Джакарта",
        "Дунгуань",
        "Йоханнесбург",
        "Каир",
        "Калькутта",
        "Карачи",
        "Киншаса",
        "Куала Лумпур",
        "Лагос",
        "Лахор",
        "Лима",
        "Лондон",
        "Лос-Анджелес",
        "Луанда",
        "Мадрид",
        "Майами",
        "Манила",
        "Мехико",
        "Москва",
        "Мумбаи",
        "Нагоя",
        "Нанкин",
        "Нью-Йорк",
        "Осака",
        "Париж",
        "Пекин",
        "Пуна",
        "Рио-де-Жанейро",
        "Сан-Паулу",
        "Санкт-Петербург",
        "Сантьяго",
        "Сеул",
        "Сиань",
        "Сингапур",
        "Стамбул",
        "Сурат",
        "Сучжоу",
        "Тегеран",
        "Токио",
        "Торонто",
        "Тяньцзинь",
        "Ухань",
        "Филадельфия",
        "Фошань",
        "Фукуока",
        "Хайдарабад",
        "Ханчжоу",
        "Харбин",
        "Хартум",
        "Хошимин",
        "Хьюстон",
        "Цзинань",
        "Циндао",
        "Ченнай",
        "Чикаго",
        "Чунцин",
        "Чэнду",
        "Шанхай",
        "Шэньчжэнь",
        "Шэньян",
        "Эр-Рияд",
        "Янгон",
    ].shuffled()    // случайный порядок
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    // MARK: - Methods
    func enabledButtons(_ enable: Bool = true) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func newRound() {
        guard !listOfWords.isEmpty else {
            enabledButtons(false)
            updateUI()
            return
        }
        let newWord = listOfWords.removeFirst()
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed)
        updateUI()
        enabledButtons()
    }
    
    func updateWordLabel() {
        var displayWord: [String] = []
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    func updateState() {
        if currentGame.incorrectMovesRemaining < 1 { // или == 0
            totalLosses += 1
        } else if currentGame.guessedWord == currentGame.word {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
        //let imageNumber = movesRemaining < 0 ? 0 : movesRemaining < 8 ? movesRemaining : 7 // двойной тернарный оператор
        let imageNumber = (movesRemaining + 64) % 8
        let image = "Tree\(imageNumber)"
        treeImageView.image = UIImage(named: image)
        updateWordLabel()
        scoreLabel.text = ("Выигрыши: \(totalWins), проигрыши: \(totalLosses)")
    }
    
    // MARK: - UIMethods
    @objc func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = sender.title(for: .normal)!
        currentGame.playerGuest(letter: Character(letter))
        updateState()
    }
    
    func initLatterButtons(fontSize: CGFloat = 17) {
        
        // init letter buttons
        let buttonTitles = "ЙЦУКЕНГШЩЗХЪЁ_ФЫВАПРОЛДЖЭ___ЯЧСМИТЬБЮ__"
        for buttonTitle in buttonTitles {
            let title: String = buttonTitle == "_" ? "" : String(buttonTitle)
            let button = UIButton()
            if buttonTitle != "_"{
                button.addTarget(self, action: #selector(letterButtonPressed(_:)), for: .touchUpInside)
            }
            button.setTitle(title, for: [])
            button.setTitleColor(.systemGray, for: .disabled)
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.systemTeal, for: .highlighted)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            letterButtons.append(button)
        }
        
        let buttonRows = [UIStackView(), UIStackView(), UIStackView()]
        let rowCount = letterButtons.count / 3
        for row in 0 ..< buttonRows.count {
            for index in 0 ..< rowCount {
                buttonRows[row].addArrangedSubview(letterButtons[row * rowCount + index])
            }
            buttonRows[row].distribution = .fillEqually
            buttonsStackView.addArrangedSubview(buttonRows[row])
        }
    }
    
    func updateUI(to size: CGSize) {
        topStackView.axis = size.height < size.width ? .horizontal : .vertical
        topStackView.frame = CGRect(x: 8, y: 8, width: size.width - 16, height: size.height - 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.bounds.size
        let factor = min(size.height, size.width)
        
        // Setup buttons stack view
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .vertical
        
        // Setup correct word label
        correctWordLabel.font = UIFont.systemFont(ofSize: factor / 12)
        correctWordLabel.text = "Word"
        correctWordLabel.textAlignment = .center
        
        // Setup letter buttons
        initLatterButtons(fontSize: factor / 20)
        
        // Setup score label
        scoreLabel.font = UIFont.systemFont(ofSize: factor / 16)
        scoreLabel.text = "Score"
        scoreLabel.textAlignment = .center
        
        // Setup stack view
        stackView.addArrangedSubview(buttonsStackView)
        stackView.addArrangedSubview(correctWordLabel)
        stackView.addArrangedSubview(scoreLabel)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        // Setup top stack view
        topStackView.addArrangedSubview(treeImageView)
        topStackView.addArrangedSubview(stackView)
        topStackView.distribution = .fillEqually
        topStackView.spacing = 16
        
        // Setup tree image view
        treeImageView.contentMode = .scaleAspectFit
        treeImageView.image = UIImage(named: "Tree3")
        
        // Setup view
        view.backgroundColor = .white
        view.addSubview(topStackView)
        
        updateUI(to: view.bounds.size)
        
        newRound()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        topStackView.axis = size.height < size.width ? .horizontal : .vertical
        topStackView.frame = CGRect(x: 8, y: 8, width: size.width - 16, height: size.height - 16)
    }
    
    
}

