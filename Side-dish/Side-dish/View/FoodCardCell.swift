//
//  FoodCardCell.swift
//  Side-dish
//
//  Created by 조중윤 on 2021/04/19.
//

import UIKit
import Combine

class FoodCardCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemBodyLabel: UILabel!
    @IBOutlet weak var sPriceLabel: UILabel!
    @IBOutlet weak var nPriceLabel: UILabel!
    @IBOutlet weak var badgeStackView: UIStackView!

    private var cancellable = Set<AnyCancellable>()

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        self.itemImageView.layer.cornerRadius = 10
    }

    func configure(item: Item) {
        setImage(itemURLString: item.image)
        itemTitleLabel.text = item.title
        itemBodyLabel.text = item.description
        sPriceLabel.text = item.sPrice
        setNPrice(nPrice: item.nPrice)
        setBadge(badges: item.badge)
    }

    func getImageData(imageURLString: String) -> AnyPublisher<Data, NetworkError>{
        guard let safeURL = URL(string: imageURLString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: safeURL)
            .mapError { (_) -> Error in
                NetworkError.invalidRequest
            }
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidStatusCode(httpResponse.statusCode)
                }
                guard !data.isEmpty else {
                    throw NetworkError.emptyData
                }
                return data
            }.mapError {
                $0 as! NetworkError
            }.eraseToAnyPublisher()
    }

    func setImage(itemURLString: String) {
        getImageData(imageURLString: itemURLString)
            .receive(on: DispatchQueue.main)
            .sink { (complete) in
            // error
        } receiveValue: { (data) in
            self.itemImageView.image = UIImage(data: data)
        }.store(in: &cancellable)
    }

    func setNPrice(nPrice: String?) {
        guard let nPrice = nPrice else { return }
        let strokeEffect: [NSAttributedString.Key : Any] = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let strokeString = NSAttributedString(string: "\(nPrice)원", attributes: strokeEffect)
        self.nPriceLabel.attributedText = strokeString
    }

    func setBadge(badges: [Badge]?) {
        guard let badges = badges else { return }
        badges.forEach { (badge) in
            let badgeLabel = BadgeLabel(withInsets: 4, 4, 8, 8)
            badgeLabel.configure(with: badge)
            self.badgeStackView.addArrangedSubview(badgeLabel)
        }
    }
}
