//
//  DetailViewController.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit

import RealmSwift

enum DetailViewType {
    case movie(movie: Movie)
    case book(book: Book, editable: Bool)
}

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let realm = try! Realm()
    var detailViewType: DetailViewType?
    private let placeholderText = "내용을 입력해주세요."
    private var book: Book?

    // MARK: - UI
    
    @IBOutlet weak private var postImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var rateLabel: UILabel!
    @IBOutlet weak private var overViewLabel: UILabel!
    @IBOutlet weak private var memoTextView: UITextView!
    @IBOutlet weak private var bottomBackgroundView: UIView!
    
    let deleteBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "trash"),
        style: .plain,
        target: nil,
        action: nil
    )
    let saveBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "square.and.arrow.down"),
        style: .done,
        target: nil,
        action: nil
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.delegate = self
        
        configureView()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if case let .book(book, editable) = detailViewType,
            editable == false {
            saveBook(book: book)
        }
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
//        memoTextView.textColor = .lightGray
//        memoTextView.text = placeholderText
    }
    
    func configureView() {
        switch detailViewType {
        case let .movie(movie):
            postImageView.image = UIImage(named: movie.title)
            titleLabel.text = movie.title
            infoLabel.text = movie.infoText
            rateLabel.text = "평균 ★ \(movie.rate)"
            overViewLabel.text = movie.overview
            title = movie.title
            view.backgroundColor = movie.backgroundColor.color
        case let .book(book, editable):
            self.book = book
            if let thumbnail = book.thumbnail {
                postImageView.fetchImage(
                    urlString: thumbnail,
                    defaultImage: UIImage(systemName: BWImageNames.System.book),
                    backgroundColorForError: .systemGray6
                )
            } else {
                postImageView.image = DocumentRepositoryManager.shared.loadImage(
                    fileName: book.posterFileName,
                    placeholder: UIImage(systemName: BWImageNames.System.book)
                )
            }
            
            title = book.title
            titleLabel.text = book.title
            infoLabel.text = book.releaseDate
            overViewLabel.text = ""
            if let memo = book.memo {
                memoTextView.text = memo
            }
            
            switch editable {
            case true:
                configureEditableNavigationBar()
            case false:
                memoTextView.isHidden = true
            }
            
        case .none:
            fatalError("not linked detailViewType")
        }
    }
    
    func saveBook(book: Book) {
        let realm = try! Realm()
        let task = BookTable(
            id: book.isbn,
            title: book.title,
            releaseDate: book.releaseDate
        )
        do {
            try realm.write {
                realm.add(task, update: .modified)
                print("Book: \(book.title) Add Succeed")
            }
        } catch {
            print("ERROR: \(error)")
        }
        
        if book.thumbnail != "",
           let image = postImageView.image {
            DocumentRepositoryManager.shared.saveImage(
                fileName: book.posterFileName,
                image: image
            )
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
    
    func configureEditableNavigationBar() {
        memoTextView.isHidden = false
        
        deleteBarButtonItem.tintColor = .red
        saveBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItems = [
            saveBarButtonItem, deleteBarButtonItem
        ]
        
        deleteBarButtonItem.target = self
        deleteBarButtonItem.action = #selector(deleteButtonTapped)
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(saveButtonTapped)
    }
    
    @objc
    func deleteButtonTapped() {
        
        guard let book = book,
              let bookObject = realm.object(
                ofType: BookTable.self,
                forPrimaryKey: book.isbn
              )
        else {
            return
        }
        
        DocumentRepositoryManager.shared.removeImage(fileName: book.posterFileName)
        do {
            try realm.write {
                realm.delete(bookObject)
            }
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    @objc
    func saveButtonTapped() {
        guard let book = book,
              let bookObject = realm.object(
                ofType: BookTable.self,
                forPrimaryKey: book.isbn
              )
        else {
            return
        }
                
        do {
            try realm.write {
                bookObject.memo = memoTextView.text
                realm.add(
                    bookObject,
                    update: .modified
                )
            }
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
}
