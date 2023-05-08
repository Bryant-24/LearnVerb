//
//  TrainViewController.swift
//  LearnVerb
//
//  Created by Ruslan Galiev on 4/21/23.
//

import UIKit
import SnapKit

final class TrainViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false

        return view
    }()
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var scoreTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Score:"
        
        return label
    }()
    
    private lazy var scoreCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = String(score)
        
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "0 of 0"
        
        return label
    }()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()
    
    private lazy var pastSimpleLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Simple"

        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Participle"

        return label
    }()
    
    private lazy var pastSimpleTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(toggleButton), for: .editingChanged)

        return textField
    }()
    
    private lazy var participleTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(toggleButton), for: .editingChanged)

        return textField
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray5
        button.setTitle("Check", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Properties
    private let edgeInsets = 30
    private let dataSource = IrregularVerbs.shared.selectedVerbs
    private var score = 0
    private var isPreviousAnswerCorrect = true
    private var currentVerb: Verb? {
        guard dataSource.count > count else { return nil }
        return dataSource[count]
    }
    private var count = 0 {
        didSet {
            infinitiveLabel.text = currentVerb?.infinitive
            pastSimpleTextField.text = ""
            participleTextField.text = ""
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Train Verbs"
        
        setupUI()
        
        
        hideKeyboardWhenTappedAround()
        
        infinitiveLabel.text = dataSource.first?.infinitive
        writeProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Private Methods
    private func writeProgress() {
        progressLabel.text = "\(count) of \(dataSource.count)"
    }
    
    @objc
    private func toggleButton() {
        checkButton.backgroundColor = .systemGray5
        checkButton.setTitle("Check", for: .normal)
    }
    
    @objc
    private func checkAction() {
        if checkAnswers() {
            if currentVerb?.infinitive == dataSource.last?.infinitive {
                let alert = UIAlertController(title: "Well done!",
                                              message: "Your score: \(score + 1)",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                present(alert, animated: true, completion: { () in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            } else {
                count += 1
                if isPreviousAnswerCorrect {
                    score += 1
                    scoreCountLabel.text = String(score)
                }
                isPreviousAnswerCorrect = true
                writeProgress()
            }
        } else {
            checkButton.backgroundColor = .red
            checkButton.setTitle("Try again", for: .normal)
            isPreviousAnswerCorrect = false
        }
    }
    
    private func checkAnswers() -> Bool {
        pastSimpleTextField.text?.lowercased() == currentVerb?.pastSimple.lowercased() &&
        participleTextField.text?.lowercased() == currentVerb?.participle.lowercased()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            scoreTextLabel,
            scoreCountLabel,
            progressLabel,
            infinitiveLabel,
            pastSimpleLabel,
            pastSimpleTextField,
            participleLabel,
            participleTextField,
            checkButton
        ])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        scoreCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        scoreTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalTo(scoreCountLabel).inset(10)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreCountLabel).inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(60)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleTextField.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleTextField.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleTextField.snp.makeConstraints { make in
            make.top.equalTo(participleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(participleTextField.snp.bottom).offset(100)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TrainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pastSimpleTextField.isFirstResponder {
            participleTextField.becomeFirstResponder()
        } else {
            scrollView.endEditing(true)
        }

        return true
    }
}

// MARK: - Keyboard events
private extension TrainViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height + 50
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero - 50
    }
    
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
