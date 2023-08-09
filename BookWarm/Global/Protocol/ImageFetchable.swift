//
//  ImageFetchable.swift
//  BookWarm
//
//  Created by JongHoon on 2023/08/09.
//

import UIKit

enum FetchImageError: Error {
    case noImageURL
    case invalidData
    
    var message: String {
        switch self {
        case .noImageURL:    return "이미지 URL이 존재하지 않습니다."
        case .invalidData:   return "이미지 data가 유효하지 않습니다."
        }
    }
    
    static func logError(with error: Error) {
        if let error = error as? FetchImageError {
            print(error.message)
        } else {
            print(error)
        }
    }
}

@objc
protocol ImageFetchable {
    @objc optional func setImage()
}

extension ImageFetchable {
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw FetchImageError.noImageURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw FetchImageError.invalidData
        }
        
        return image
    }
}

extension ImageFetchable where Self: UIImageView {
    func fetchImage(urlString: String,
                    defaultImage: UIImage? = nil,
                    backgroundColorForError: UIColor? = nil) async {
        do {
            guard let url = URL(string: urlString) else {
                throw FetchImageError.noImageURL
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw FetchImageError.invalidData
            }
            
            await setImage(with: image)
        } catch {
            if let defaultImage = defaultImage {
                await setImage(with: defaultImage)
                
            }
            if let backgroundColorForError = backgroundColorForError {
                await setBackgroundColor(with: backgroundColorForError)
            }
            
            FetchImageError.logError(with: error)
        }
    }
}

extension UIImageView: ImageFetchable {
    func setImage(with image: UIImage) {
        self.image = image
    }
    func setBackgroundColor(with color: UIColor) {
        backgroundColor = color
    }
}
