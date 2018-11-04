//
//  ViewController.swift
//  DynamicChatBubbles
//
//  Created by Mehmet Salih Koçak on 4.11.2018.
//  Copyright © 2018 Mehmet Salih Koçak. All rights reserved.
//

import UIKit

struct ChatMessage {
    let message:String
    let isIncoming:Bool
    let timestamp:Date
}

class ViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var messages = [[ChatMessage]]()
    
    var messagesFromServer = [ChatMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = veryLightGray
        tableView.allowsSelection = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        receiveMessagesFromServer()
        groupMessagesByDay()
    }
    
    func receiveMessagesFromServer(){
        let today = Date()
        let tomorrow = today.addOneDay()
        let theDayAfterTomorrow = tomorrow.addOneDay()
        messagesFromServer.append(ChatMessage(message: "Pellentesque laoreet tristique dui, in imperdiet quam imperdiet vel. Aliquam quis bibendum turpis, a lobortis metus.", isIncoming: true, timestamp: today))
        messagesFromServer.append(ChatMessage(message: "Aliquam molestie", isIncoming: true, timestamp: today))
        messagesFromServer.append(ChatMessage(message: "Ut varius eros metus, vel consequat ex dignissim vel.", isIncoming: false, timestamp:today))
        messagesFromServer.append(ChatMessage(message: "Pellentesque id ullamcorper nunc, quis iaculis nisl. Praesent in nibh leo. Ut porta lectus non urna tempus, et sagittis nunc lobortis. Suspendisse molestie vitae lorem ac tristique. Sed semper sodales odio, non dapibus ipsum lobortis non. Vivamus auctor porttitor ante vel placerat. Donec faucibus a orci eget dictum. Vivamus ultricies pretium ultrices.", isIncoming: true, timestamp: tomorrow))
        messagesFromServer.append(ChatMessage(message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec libero tortor, consequat quis consequat quis, accumsan id dui. Proin ac velit eleifend, vehicula ex eget, euismod lorem.", isIncoming: true, timestamp: tomorrow))
        messagesFromServer.append(ChatMessage(message: "Nam mollis urna urna, non blandit metus congue et. Aenean finibus vitae metus vitae lacinia. Mauris gravida sed massa quis porttitor.", isIncoming: false, timestamp: theDayAfterTomorrow))
        messagesFromServer.append(ChatMessage(message: "Nam aliquam nisl vitae sem cursus suscipit.", isIncoming: false, timestamp: theDayAfterTomorrow))
        messagesFromServer.append(ChatMessage(message: "Mauris vel libero sit amet mauris pellentesque varius.", isIncoming: false, timestamp: theDayAfterTomorrow))
    }
    
    func groupMessagesByDay(){
        let groupedDict = Dictionary(grouping: messagesFromServer) { (element) -> Date in
            return element.timestamp.reduceToMonthDayYear()
        }
        let sortedKeys = groupedDict.keys.sorted(by: {$0 < $1})
        sortedKeys.forEach { (date) in
            messages.append(groupedDict[date] ?? [])
        }
        tableView.reloadData()
    }
    
    func addOneDay(to date:Date) -> Date?{
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: date)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let firstMessageInSection = messages[section].first else{ return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: firstMessageInSection.timestamp)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let firstMessageInSection = messages[section].first else{ return nil }
        
        let containerView = UIView()
        let dateHeaderLabel = DateHeaderLabel()
        
        containerView.addSubview(dateHeaderLabel)
        
        dateHeaderLabel.date = firstMessageInSection.timestamp
        [dateHeaderLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
         dateHeaderLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
         ].forEach({$0.isActive = true})
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        cell.chatMessage = messages[indexPath.section][indexPath.row]
        return cell
    }
    
    class DateHeaderLabel:UILabel{
        
        var date: Date! {
            didSet{
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                text = formatter.string(from: date!)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = headerBackgroundColor
            textColor = UIColor(white: 0.9, alpha: 1)
            textAlignment = .center
            font = UIFont.boldSystemFont(ofSize: 15)
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        override var intrinsicContentSize: CGSize{
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension Date{
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: "\(day)/\(month)/\(year)") ?? Date()
    }
    
    func addOneDay() -> Date{
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: self)!
    }
}
