//
//  ViewController.swift
//  OpenWeatherApp
//
//  Created by Tony Cioara on 8/11/19.
//  Copyright © 2019 Tony Cioara. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class ViewController: UIViewController {
    
    let tempLabel = UILabel()
    let humidityLabel = UILabel()
    let windSpeedLabel = UILabel()
    let moodLabel: UILabel = {
        let label = UILabel()
        label.text = "How's your mood today?"
        return label
    }()
    let moodStack = UIStackView()
    
    var buttons = [UIButton]()
    
    func setupStackView() {
        moodStack.axis = .horizontal
        let emojis = ["😫", "🙁", "😐", "🙂", "😄"]
        moodStack.distribution = .fillEqually
        for index in 0..<5 {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.setTitle(emojis[index], for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(self.moodSelected(sender:)), for: .touchUpInside)
            buttons.append(button)
            moodStack.addArrangedSubview(button)
        }
    }
    
    @objc func moodSelected(sender: UIButton) {
        for button in buttons {
            button.isEnabled = false
        }
        sender.backgroundColor = .green
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.title = "Weather"
        setupViews()
        setupStackView()
        configure(temp: "Loading...", humidity: "Loading...", windSpeed: "Loading...")
        Network.shared.fetch(route: .getWeather) { (data) in
//            print(data)
            let jsonData = JSON(data)
            
            print(jsonData)
            let temp = jsonData["main"]["temp"].stringValue
            let humidity = jsonData["main"]["humidity"].stringValue
            let windSpeed = jsonData["wind"]["speed"].stringValue
            
            DispatchQueue.main.async {
                self.configure(temp: temp, humidity: humidity, windSpeed: windSpeed)
            }
        }
    }
    
    func configure(temp: String, humidity: String, windSpeed: String) {
        if let temp = Float(temp) {
            tempLabel.text = "Tempreture: " + String(temp - 253.0) + " Celsius"
        } else {
            tempLabel.text = "Tempreture: Loading..."
        }
        
        humidityLabel.text = "Humidity: " + humidity
        windSpeedLabel.text = "Wind Speed: " + windSpeed
    }
    
    func setupViews() {
        [tempLabel, humidityLabel, windSpeedLabel, moodLabel, moodStack].forEach { (view) in
            self.view.addSubview(view)
        }
        
        
        tempLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            
        }
        
        humidityLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(tempLabel.snp.bottom).offset(16)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(humidityLabel.snp.bottom).offset(16)
        }
        
        moodLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(32)
        }
        
        moodStack.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(moodLabel.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }


}

