//
//  DocumentRepositoryManager.swift
//  BookWarm
//
//  Created by JongHoon on 2023/09/05.
//

import UIKit

final class DocumentRepositoryManager {
    
    static let shared = DocumentRepositoryManager()
    private init() {}
    private var documentDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first
    
    func saveImage(
        fileName: String,
        image: UIImage
    ) {
        guard let fileURL = fileURL(fileNmae: fileName),
              let data = image.jpegData(compressionQuality: 0.5)
        else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImage(
        fileName: String,
        placeholder: UIImage? = nil
    ) -> UIImage? {
        guard let fileURL = fileURL(fileNmae: fileName)
        else {
            return placeholder
        }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return placeholder
        }
    }
    
    func removeImage(fileName: String) {
        guard let fileURL = fileURL(fileNmae: fileName) else { return }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
}

private extension DocumentRepositoryManager {
    
    func fileURL(fileNmae: String) -> URL? {
        return documentDirectory?.appendingPathComponent(fileNmae)
    }
}
