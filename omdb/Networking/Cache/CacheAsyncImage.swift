//
//  CacheAsyncImage.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {

    private let url: URL?
    private let content: (AsyncImagePhase) -> Content

    init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
    }

    var body: some View {
        if let url = url {
            if let cached = ImageCache[url] {
                content(.success(cached))
            } else {
                AsyncImage(url: url) { phase in
                    cacheAndRender(phase: phase)
                }
            }
        } else {
            content(.failure(ImageError.invalidURLError))
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        guard let url = url else {
            return content(.failure(ImageError.invalidURLError))
        }
        
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

fileprivate actor ImageCache {
    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

enum ImageError: Error {
    case invalidURLError
}
