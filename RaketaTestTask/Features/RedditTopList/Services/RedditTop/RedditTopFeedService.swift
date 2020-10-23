//
//  RedditTopFeedService.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import Foundation

public class RedditTopFeedService {
    
    private var after = ""
}

extension RedditTopFeedService: FeedService {
    
    public func loadFeed(completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        
        let url = "https://reddit.com/top.json?after=\(after)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, resp, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let resp = try decoder.decode(Net.TopResponse.self, from: data)
                    self?.after = resp.data.after
                    completion(.success(.init(resp)))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

extension FeedResponse {
    
   fileprivate init(_ response: Net.TopResponse) {
        self.init(total: response.data.children.count, list: response.data.children.map {
            FeedItem(title: $0.data.title, author: $0.data.media?.oembed?.authorName ?? $0.data.authorFullname, date: $0.data.created, img: $0.data.media?.oembed?.thumbnailURL, numberOfComents: $0.data.numComments, isVideo: $0.data.isVideo, videoURL: $0.data.media?.redditVideo?.fallbackURL)
        })
    }
}


fileprivate struct Net {
    
    struct TopResponse: Codable {
        let data: TopResponseData
    }

    // MARK: - TopResponseData
    struct TopResponseData: Codable {
        let dist: Int
        let children: [Child]
        let after: String
        let before: String?
    }

    // MARK: - Child
    struct Child: Codable {
        let kind: String
        let data: ChildData
    }

    // MARK: - ChildData
    struct ChildData: Codable {
        
        let selftext: String
        let authorFullname: String
        let title: String
        let url: String
        let media: Media?
        let created: Date
        let isVideo: Bool
        let numComments: Int

        enum CodingKeys: String, CodingKey {
            case selftext
            case authorFullname = "author_fullname"
            case title
            case url
            case media
            case isVideo = "is_video"
            case created
            case numComments = "num_comments"
        }
    }

    struct Media: Codable {
        let oembed: Oembed?
        let type: String?
        let redditVideo: RedditVideo?

        enum CodingKeys: String, CodingKey {
            case oembed, type
            case redditVideo = "reddit_video"
        }
    }

    // MARK: - Oembed
    struct Oembed: Codable {
        let providerURL: String
        let oembedDescription, title, authorName: String
        let height, width: Int
        let html: String
        let thumbnailWidth: Int
        let version, providerName: String
        let thumbnailURL: String
        let type: String
        let thumbnailHeight: Int

        enum CodingKeys: String, CodingKey {
            case providerURL = "provider_url"
            case oembedDescription = "description"
            case title
            case authorName = "author_name"
            case height, width, html
            case thumbnailWidth = "thumbnail_width"
            case version
            case providerName = "provider_name"
            case thumbnailURL = "thumbnail_url"
            case type
            case thumbnailHeight = "thumbnail_height"
        }
    }

    // MARK: - RedditVideo
    struct RedditVideo: Codable {
        let fallbackURL: String
        let height, width: Int
        let scrubberMediaURL: String
        let dashURL: String
        let duration: Int
        let hlsURL: String
        let isGIF: Bool
        let transcodingStatus: String

        enum CodingKeys: String, CodingKey {
            case fallbackURL = "fallback_url"
            case height, width
            case scrubberMediaURL = "scrubber_media_url"
            case dashURL = "dash_url"
            case duration
            case hlsURL = "hls_url"
            case isGIF = "is_gif"
            case transcodingStatus = "transcoding_status"
        }
    }
}
