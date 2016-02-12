//
//  Parser.h
//  SampleJson
//
//  Created by kishor Nimje on 10/11/14.
//  Copyright (c) 2014 venturelabour.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol delegate <NSObject>

@optional

-(void)receivedXmlResponse:(NSDictionary*)responseDict;

-(void)receiveJsonResponse:(NSDictionary*)responseDict;

@end

@interface Parser : NSObject<NSXMLParserDelegate,NSURLConnectionDataDelegate>{
    
    // xml
    NSMutableData* webData;
    int operations;
    int maxCount;
    NSString* currentElementString;
    NSArray* elementNamesArray;
    NSMutableDictionary* parsedXmlDictionary;
    NSString* foundCharacterString;
    
    NSURLConnection *theConnection;
    
    // delegate
    id <delegate>delegate;
    
    BOOL isJson;
    
}


+ (Parser *) sharedParser;

-(void)parseSoapWithJSONSoapContents:(NSDictionary*)soapDict;

-(void)parseSoapWithXMLwithSoapContents:(NSDictionary*)soapDict;

-(void)connectionCancel;

-(void)parseSoapWithJSONSoapContentsPDF:(NSDictionary*)soapDict withdata : (NSDictionary *)pdfDictionary;

@property (strong,nonatomic) id <delegate>delegate;


@end
