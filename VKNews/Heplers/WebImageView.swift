//
//  WebImageView.swift
//  VKNews
//
//  Created by Misha Volkov on 22.03.23.
//

import UIKit

final class WebImageView: UIImageView {
    func set(imageUrl: String?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            image = nil
            return
        }

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            image = UIImage(data: cachedResponse.data)
            print("Image loaded from cache")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print(error)
            }
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self.image = UIImage(data: data)
                    print("Image loaded from internet")
                    self.handleLoadedImage(data: data, response: response)
                }
            }
        }.resume()
    }

    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }

        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
    }
}
