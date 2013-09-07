//
//  BlueToothTestViewController.h
//  Tooth
//
//  Created by 吉井 竜太 on 13/09/07.
//  Copyright (c) 2013年 吉井 竜太. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>


@interface BlueToothTestViewController : UIViewController <UITextFieldDelegate,GKPeerPickerControllerDelegate,GKSessionDelegate>{
    GKPeerPickerController *picker;
    GKSession *currentSession;
    
    UITextField *txtMessage;
    UIButton *sentBtn;
    UIButton *connectedBtn;
    UIButton *disconnectedBtn;
}

- (void)btnSend:(id) sender;
- (void)btnConnect:(id) sender;
- (void)btnDisconnect:(id) sender;
- (void)mySendDataToPeers:(NSData *)data;

@property (nonatomic, retain) GKPeerPickerController *picker;
@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) UITextField *txtMessage;
@property (nonatomic, retain) UIButton *connectedBtn;
@property (nonatomic, retain) UIButton *disconnectedBtn;

@end
