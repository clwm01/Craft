//
//  ExtensionForChatField.swift
//  Craft
//
//  Created by Rex Tsao on 13/6/2016.
//  Copyright © 2016 castiel. All rights reserved.
//

import Foundation

extension ChatRoom: UITextViewDelegate {
    
    private func sendText() {
        let message = RCTextMessage(content: self.enterText!.text)
        RCIMClient.sharedRCIMClient().setReceiveMessageDelegate(self, object: nil)
        RCIMClient.sharedRCIMClient().sendMessage(.ConversationType_PRIVATE, targetId: "2", content: message, pushContent: nil, success: {
            messageId in
                print("send successful")
            }, error: {
                (error, messageId) in
                print("send fail")
        })
        self.enterText!.resignFirstResponder()
        self.enterText!.text = ""
    }
    
    
    func textViewDidChange(textView: UITextView) {
        // Caculate the size which best fits the specified size.
        // This height is just the height of textView which best fits its content.
        var height = textView.sizeThatFits(CGSizeMake(enterText!.frame.width, CGFloat(MAXFLOAT))).height
        // Compare with the original height, if bigger than original value, use current height, otherwise, use original value.
        height = height > self.textViewInitialHeight ? height : self.textViewInitialHeight
        // Here i set the max height for textView is 80.
        if height <= uiah(104) {
            // Get how much the textView grows at height dimission
            let heightDiff = height - enterText!.frame.height
            UIView.animateWithDuration(0.05, animations: {
                self.chatListView?.frame = CGRectMake(self.chatListView!.frame.origin.x, self.chatListView!.frame.origin.y, self.chatListView!.frame.width, self.chatListView!.frame.height - heightDiff)
                self.enterText?.frame = CGRectMake(self.enterText!.frame.origin.x, self.enterText!.frame.origin.y - heightDiff, self.enterText!.frame.width, height)
                }, completion: {
                    finished in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableScrollToBottom()
                    })
            })
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.sendText()
            return false
        } else {
            return true
        }
    }
    
    private func tableScrollToBottom() {
        if self.chatContentsList.count > 0 {
            self.chatListView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chatContentsList.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
}


extension ChatRoom: RCIMClientReceiveMessageDelegate {
    func onReceived(message: RCMessage!, left nLeft: Int32, object: AnyObject!) {
        if message.content.isKindOfClass(RCTextMessage.classForCoder()) {
            let content = message.content as! RCTextMessage
            print(content.content)
        }
    }
}