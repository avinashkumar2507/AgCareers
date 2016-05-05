//
//  Parser.m
//  SampleJson
//
//  Created by kishor Nimje on 10/11/14.
//  Copyright (c) 2014 venturelabour.com. All rights reserved.
//

#import "Parser.h"


/*
 // Configuration retrive webservice code
 
 NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigApp" ofType:@"plist" ]];
 NSString *webServiceString = [dictRoot objectForKey:@"WebServiceURL"];
 
 */

// Staging url

static NSString* base_url = @"http://staging.agcareers.com/mobilews/WebService/NewJobSearch.asmx/";
static NSString* base_host = @"staging.agcareers.com";

// Dev URL
//static NSString* base_url = @"http://dev.agcareers.farmsstaging.com/mobilews/WebService/NewJobSearch.asmx/"; //live
//static NSString* base_host = @"dev.agcareers.farmsstaging.com";


static Parser *parserInstance = nil;

@implementation Parser
@synthesize delegate;

// setting singletion class

+ (Parser *) sharedParser{
    @synchronized(self){
        if (parserInstance == nil){
            parserInstance = [[Parser alloc] init];
        }
    }
    return parserInstance;
}

// setting delegate

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = self;
        
    }
    return self;
}

-(void)parseSoapWithJSONSoapContents:(NSDictionary*)soapDict {
    
    isJson = YES;

    NSString * soapActionString = [soapDict objectForKey:@"soapAction"];
    
    NSDictionary* parameterDict = [soapDict objectForKey:@"parameterDict"];
    
    NSString * base = [[NSUserDefaults standardUserDefaults] valueForKey:@"GlobalURL"];
    
    NSLog(@"soapactionstring - %@",soapActionString);
    
    NSLog(@"parameter dict - %@",parameterDict);
    
    NSLog(@"host  - %@",base);
    
    NSError* error = nil;
    
    NSString* finalUrlString = [base stringByAppendingString:[soapDict objectForKey:@"url"]];
    
    NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
    
    //  NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:finalUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:100.0];
    
    [request addValue: [soapDict objectForKey:@"soapAction"] forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"GlobalHost"] forHTTPHeaderField:@"Host"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[soapDict objectForKey:@"parameterDict"] options:kNilOptions error:&error];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonData length]];
    [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( theConnection ) {
        webData = [NSMutableData data];
    }
    
}

-(void)connectionCancel{
    [theConnection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if ([challenge previousFailureCount] > 1) {
        NSLog(@"Too many unsuccessul login attempts");
    }else {
        NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:@"mangesh.karekar" password:@"Welcome@123" persistence:NSURLCredentialPersistenceForSession] ;
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}

-(void)parseSoapWithXMLwithSoapContents:(NSDictionary*)soapDict {
    
    isJson = NO;
    // catch the element names array
    
    elementNamesArray = [soapDict objectForKey:@"elementNamesArray"];
    
    // set max count
    
    maxCount = elementNamesArray.count;
    
    // XML parsing prepartion
    
    
    NSString * soapActionString = [soapDict objectForKey:@"soapAction"];
    NSString * base = [[NSUserDefaults standardUserDefaults] valueForKey:@"GlobalURL"];
    NSString* soapMessage = [soapDict objectForKey:@"soapMessage"];
    NSString* contentType = [soapDict objectForKey:@"contenttype"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    NSLog(@"soap message - %@",soapMessage);
    
    NSLog(@"soapactionstring - %@",soapActionString);
    
    NSLog(@"host  - %@",base);
    
    
    NSString* finalUrlString = [base stringByAppendingString:[soapDict objectForKey:@"url"]];
    
    NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
    
    
    //  NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:finalUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:20.0];
    [request addValue: [soapDict objectForKey:@"soapAction"] forHTTPHeaderField:@"SOAPAction"];
    [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"GlobalHost"] forHTTPHeaderField:@"Host"];
    [request addValue: contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( theConnection ) {
        webData = [NSMutableData data];
        
    }else {
        NSLog(@"Some error occurred in Connection");
    }
}

// NSURL CONNECTION DELEGATE


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error with connection %@",error);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //NSLog(@"Done. received Bytes %d", [webData length]);
    
    if (isJson) {
        NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:webData  options:kNilOptions error:nil];
        //NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:data  options:0 error:nil];
        //NSLog(@"%@",returnDict);
        
        [delegate receiveJsonResponse:returnDict];
    }else {
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:webData];
        // Don't forget to set the delegate!
        xmlParser.delegate = self;
        
        // Run the parser
        //BOOL parsingResult = [xmlParser parse];
        
    }
    
}

// NSXML PARSER DELEGATE

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
    // set inition operations to 0
    operations = 0;
    //
    parsedXmlDictionary = [[NSMutableDictionary alloc]init];
    
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    currentElementString = elementName;
    
    
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if (operations<=maxCount)
    {
        if ([currentElementString isEqualToString:[elementNamesArray objectAtIndex:operations]]) {
            
            foundCharacterString = string;
        }
        
    }
    
    
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // add parsed object to dictionary with the same key (element string)
    
    [parsedXmlDictionary setObject:foundCharacterString forKey:currentElementString];
    
    // increase operations by 1
    
    operations = operations + 1;
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // call the delegate
    
    [delegate receivedXmlResponse:[NSDictionary dictionaryWithDictionary:parsedXmlDictionary]];
    
    
}


@end
