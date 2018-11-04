//
//  ChatMessageCell.swift
//  DynamicChatBubbles
//
//  Created by Mehmet Salih Koçak on 4.11.2018.
//  Copyright © 2018 Mehmet Salih Koçak. All rights reserved.
//

import UIKit

let veryLightGray = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
let headerBackgroundColor = UIColor(red: 41/255, green: 156/255, blue: 170/255, alpha: 1)
let outgoingMessageColor = UIColor(red: 97/255, green: 136/255, blue: 160/255, alpha: 1)

class ChatMessageCell: UITableViewCell {

    let messageLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let bubbleView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var messageLeadingAnchor:NSLayoutConstraint!
    var messageTrailingAnchor:NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet{
            messageLabel.text = chatMessage.message
            
            bubbleView.backgroundColor = chatMessage.isIncoming ? .white : outgoingMessageColor
            messageLabel.textColor =  chatMessage.isIncoming ? .black : .white
            
            messageLeadingAnchor.isActive = chatMessage.isIncoming
            messageTrailingAnchor.isActive = !chatMessage.isIncoming
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(bubbleView)
        addSubview(messageLabel)
        
        setupMessageLabelConstraints()
        setupBubbleViewConstraints()
    }
    
    func setupMessageLabelConstraints(){
        [messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
         messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
         messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ].forEach({$0.isActive = true})
        
        messageLeadingAnchor = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        messageTrailingAnchor = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
    }
    
    func setupBubbleViewConstraints(){
        [bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
         bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12),
         bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -12),
         bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12)
        ].forEach({$0.isActive = true})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
