//
//  ProductInformation.swift
//  SideDish
//
//  Created by Jason on 2023/06/22.
//

import UIKit

//MARK: - Top Class
class ProductInformation: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray
        configureOfLayout()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureOfLayout()
        setUp()
    }
    
    private let foodThumbScroll = FoodThumbImages()
    private let detailFoodInfo = DetailFoodInfo()
    private let deliveryInformation = DeliveryInformation()
    
    private let divisionLine: UIView = {
        let divisionLine = UIView()
        divisionLine.backgroundColor = .systemGray4
        return divisionLine
    }()
    
    private func setUp() {
        let foodInfo = ["오리 주물럭_반조리", "감칠맛 나는 매콤한 양념", "12,640", "15,800", "런칭특가"]
        let deliveryInfo = ["126원", "서울 경기 새벽 배송, 전국 택배 배송", "2,500원 (40,000원 이상 구매 시 무료)"]
        detailFoodInfo.configureOfFoodInfoUIComponents(foodInfo: foodInfo)
        deliveryInformation.configureOfUIComponents(info: deliveryInfo)
    }
}

//MARK: - Configure of Layout
extension ProductInformation {
    
    private func configureOfLayout() {
        self.addSubview(foodThumbScroll)
        foodThumbScroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foodThumbScroll.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            foodThumbScroll.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            foodThumbScroll.heightAnchor.constraint(equalToConstant: 376),
        ])
        
        self.addSubview(detailFoodInfo)
        detailFoodInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailFoodInfo.topAnchor.constraint(equalTo: foodThumbScroll.bottomAnchor),
            detailFoodInfo.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailFoodInfo.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            detailFoodInfo.heightAnchor.constraint(equalToConstant: 152)
        ])
        
        self.addSubview(divisionLine)
        divisionLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divisionLine.topAnchor.constraint(equalTo: detailFoodInfo.bottomAnchor, constant: 28),
            divisionLine.leadingAnchor.constraint(equalTo: detailFoodInfo.leadingAnchor),
            divisionLine.trailingAnchor.constraint(equalTo: detailFoodInfo.trailingAnchor),
            divisionLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.addSubview(deliveryInformation)
        deliveryInformation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deliveryInformation.topAnchor.constraint(equalTo: divisionLine.bottomAnchor, constant: 24),
            deliveryInformation.leadingAnchor.constraint(equalTo: detailFoodInfo.leadingAnchor),
            deliveryInformation.trailingAnchor.constraint(equalTo: detailFoodInfo.trailingAnchor),
            deliveryInformation.heightAnchor.constraint(equalToConstant: 104)
        ])
    }
}
