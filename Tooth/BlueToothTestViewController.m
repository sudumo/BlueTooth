//
//  BlueToothTestViewController.m
//  Tooth
//
//  Created by 吉井 竜太 on 13/09/07.
//  Copyright (c) 2013年 吉井 竜太. All rights reserved.
//

#import "BlueToothTestViewController.h"
@implementation BlueToothTestViewController

@synthesize picker;
@synthesize currentSession;
@synthesize txtMessage;
@synthesize connectedBtn;
@synthesize disconnectedBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        //Text
        txtMessage = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, 260, 30)];
        txtMessage.borderStyle = UITextBorderStyleRoundedRect;
        txtMessage.delegate = self;
        txtMessage.textAlignment = NSTextAlignmentCenter;
        txtMessage.keyboardType = UIKeyboardTypeASCIICapable;
        txtMessage.font = [UIFont boldSystemFontOfSize:22];
        
        //Button
        sentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sentBtn.frame = CGRectMake(30, 90, 260, 50);
        [sentBtn setTitle:@"Send" forState:UIControlStateNormal];
        [sentBtn addTarget:self action:@selector(btnSend:) forControlEvents:UIControlEventTouchUpInside];
        
        connectedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        connectedBtn.frame = CGRectMake(30, 190, 120, 50);
        [connectedBtn setTitle:@"Connect" forState:UIControlStateNormal];
        [connectedBtn addTarget:self action:@selector(btnConnect:) forControlEvents:UIControlEventTouchUpInside];
        
        disconnectedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        disconnectedBtn.frame = CGRectMake(160,190, 120, 50);
        [disconnectedBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
        [disconnectedBtn addTarget:self action:@selector(btnDisconnect:) forControlEvents:UIControlEventTouchUpInside];
        
        [connectedBtn setHidden:NO];
        [disconnectedBtn setHidden:YES];
        
        [self.view addSubview:txtMessage];
        [self.view addSubview:sentBtn];
        [self.view addSubview:connectedBtn];
        [self.view addSubview:disconnectedBtn];
    }
    return self;
}

- (void)btnSend:(id) sender {
    //---convert an NSString object to NSData---
    if ([txtMessage.text length]>0) {
        
        
        NSData* data;
        NSString *str = [NSString stringWithString:txtMessage.text];
        data = [str dataUsingEncoding: NSASCIIStringEncoding];
        [self mySendDataToPeers:data];
         
    }
}

- (void)btnConnect:(id) sender {
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
    
    [connectedBtn setHidden:YES];
    [disconnectedBtn setHidden:NO];
    [picker show];
}

- (void)btnDisconnect:(id) sender {
    [self.currentSession disconnectFromAllPeers];
    [self.currentSession release];
    currentSession = nil;
    
    [connectedBtn setHidden:NO];
    [disconnectedBtn setHidden:YES];
}

- (void)peerPickerController:(GKPeerPickerController *)_picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
    if (type == GKPeerPickerConnectionTypeOnline) {
        _picker.delegate = nil;
        [_picker dismiss];
        [_picker autorelease];
        // Implement your own internet user interface here.
        
        [connectedBtn setHidden:NO];
        [disconnectedBtn setHidden:YES];
    }
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    GKSession* session = [[GKSession alloc] initWithSessionID:@"MySessionID" displayName:@"BlueToothTest" sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)_picker didConnectPeer:(NSString *)peerID toSession: (GKSession *) session {
    // Use a retaining property to take ownership of the session.
    self.currentSession = session;
    // Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
    // Remove the picker.
    _picker.delegate = nil;
    [_picker dismiss];
    [_picker autorelease];
    // Start your game.
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)_picker {
    _picker.delegate = nil;
    [_picker autorelease];
    
    [connectedBtn setHidden:NO];
    [disconnectedBtn setHidden:YES];
}

- (void)mySendDataToPeers:(NSData *)data {
    if (currentSession){
        NSLog(@"send data");
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
    }
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch(state){
        case GKPeerStateConnected:
            NSLog(@"connected");
            break;
        case GKPeerStateDisconnected:
            NSLog(@"disconnected");
            [self.currentSession release];
            currentSession = nil;
            
            [connectedBtn setHidden:NO];
            [disconnectedBtn setHidden:YES];
            break;
    }
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context {
    //---convert the NSData to NSString---
    NSString* str;
    str = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data received"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                          ];
    [alert show];
    [alert release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [txtMessage release];
    [super dealloc];
}

@end


