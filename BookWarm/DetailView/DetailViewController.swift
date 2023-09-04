//
//  DetailViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

enum DetailViewType {
    case movie(movie: Movie)
    case book(book: Book)
}

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var detailViewType: DetailViewType?
    private let placeholderText = "내용을 입력해주세요."

    // MARK: - UI
    
    @IBOutlet weak private var postImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var rateLabel: UILabel!
    @IBOutlet weak private var overViewLabel: UILabel!
    @IBOutlet weak private var memoTextView: UITextView!
    @IBOutlet weak private var bottomBackgroundView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.delegate = self
        
        configureUI()
        configureMovie()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
    }
    
    func configureDismissButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: BWImageNames.System.xmark),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
    }
    
    @objc
    func dismissView() {
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Private Method

private extension DetailViewController {
    
    func configureUI() {
        postImageView.configureCornerRadius(4.0)
        
        bottomBackgroundView.layer.cornerRadius = 16.0
        bottomBackgroundView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        bottomBackgroundView.clipsToBounds = true
        bottomBackgroundView.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.borderWidth = 0.5
        memoTextView.configureCornerRadius(8.0)
        memoTextView.textColor = .lightGray
        memoTextView.text = placeholderText
    }
    
    func configureMovie() {
        
        guard let detailViewType = detailViewType
        else {
            fatalError("not linked detailViewType")
        }
        
        switch detailViewType {
        case let .movie(movie):
            postImageView.image = UIImage(named: movie.title)
            titleLabel.text = movie.title
            infoLabel.text = movie.infoText
            rateLabel.text = "평균 ★ \(movie.rate)"
            overViewLabel.text = movie.overview
            title = movie.title
            view.backgroundColor = movie.backgroundColor.color
            
        case let .book(book):
            break
        }
    }
}

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
}
