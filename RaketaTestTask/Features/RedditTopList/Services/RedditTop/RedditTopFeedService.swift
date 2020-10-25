//
//  RedditTopFeedService.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import Foundation

public class RedditTopFeedService {
    
    private var after = ""
    
    public func clear() {
        after = ""
    }
}

extension RedditTopFeedService: FeedService {
    
    public func loadFeed(after: String, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        
        let url = "https://reddit.com/top.json?after=\(after)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, resp, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let resp = try decoder.decode(Net.TopResponse.self, from: data)
                    completion(.success(.init(resp, after: resp.data.after)))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

extension FeedResponse {
    
    fileprivate init(_ response: Net.TopResponse, after: String) {
        self.init(total: response.data.children.count, list: response.data.children.map {
            FeedItem(title: $0.data.title, author: $0.data.authorFullname, date: $0.data.created, img: $0.data.preview, numberOfComents: $0.data.numComments)
        }, after: after)
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
        let created: Date
        let numComments: Int
        let preview: String?

        enum CodingKeys: String, CodingKey {
            case selftext
            case authorFullname = "author_fullname"
            case title
            case url
            case created
            case numComments = "num_comments"
            case preview = "url_overridden_by_dest"
        }
    }
    
    // MARK: - Preview
    struct Preview: Codable {
        let images: [Image]
        let enabled: Bool
        let redditVideoPreview: RedditVideo?

        enum CodingKeys: String, CodingKey {
            case images, enabled
            case redditVideoPreview = "reddit_video_preview"
        }
    }

    // MARK: - Image
    struct Image: Codable {
        let source: ResizedIcon
        let resolutions: [ResizedIcon]
        let id: String
    }
    
    struct ResizedIcon: Codable {
        let url: String
        let width, height: Int
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
