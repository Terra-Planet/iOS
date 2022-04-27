//
//  NodeRunner.mm
//  native-xcode-node-folder
//
//  Created by Jaime Bernardo on 08/03/2018.
//  Copyright © 2018 Janea Systems. All rights reserved.
//

#include "NodeRunner.h"
#include <NodeMobile/NodeMobile.h>
#include <string>

@implementation NodeRunner

NSFileHandle *pipeControlWriteHandle;
NSFileHandle *pipeControlReadHandle;
NSPipe *controlPipe;

+ (void) createControlPipe
{
  controlPipe = [NSPipe pipe] ;
  pipeControlReadHandle = [controlPipe fileHandleForReading];
  pipeControlWriteHandle = [controlPipe fileHandleForWriting];
}


//node's libUV requires all arguments being on contiguous memory.
+ (void) startEngine:(NSDictionary*) params
{
    NSString* httpUsername = [params objectForKey:@"httpUsername"];
    NSString* httpPassword = [params objectForKey:@"httpPassword"];
    
    NSString* controlFileDescriptorNS = [NSString stringWithFormat:@"%d",[pipeControlReadHandle fileDescriptor]];
    
    NSString* srcPath = [[NSBundle mainBundle] pathForResource:@"nodejs-project/bin/www" ofType:@""];
    NSArray* arguments = [NSArray arrayWithObjects: @"node",
                          srcPath,
                          [NSString stringWithFormat:@"--user=%@",httpUsername],
                          [NSString stringWithFormat:@"--password=%@",httpPassword],
                          [NSString stringWithFormat:@"--controlfh=%@",controlFileDescriptorNS],
                          nil];
    
    int c_arguments_size=0;
    
    //Compute byte size need for all arguments in contiguous memory.
    for (id argElement in arguments)
    {
        c_arguments_size+=strlen([argElement UTF8String]);
        c_arguments_size++; // for '\0'
    }
    
    //Stores arguments in contiguous memory.
    char* args_buffer=(char*)calloc(c_arguments_size, sizeof(char));
    
    //argv to pass into node.
    char* argv[[arguments count]];
    
    //To iterate through the expected start position of each argument in args_buffer.
    char* current_args_position=args_buffer;
    
    //Argc
    int argument_count=0;
    
    //Populate the args_buffer and argv.
    for (id argElement in arguments)
    {
        const char* current_argument=[argElement UTF8String];
        
        //Copy current argument to its expected position in args_buffer
        strncpy(current_args_position, current_argument, strlen(current_argument));
        
        //Save current argument start position in argv and increment argc.
        argv[argument_count]=current_args_position;
        argument_count++;
        
        //Increment to the next argument's expected position.
        current_args_position+=strlen(current_args_position)+1;
    }
    
    //Start node, with argc and argv.
    node_start(argument_count,argv);
    free(args_buffer);
}

+(void) sendControlMessage:(NSString*)message
{
  [pipeControlWriteHandle writeData:[[NSString stringWithFormat: @"%@\n", message] dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void) stopHttpServer {
    [self sendControlMessage:@"STOP"];
}

+ (void) startHttpServer {
    [self sendControlMessage:@"START"];
}

+ (void) runNode:(NSString*) httpUsername withPassword:(NSString*) httpPassword
{
    
    [self createControlPipe];
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            httpUsername, @"httpUsername",
                            httpPassword, @"httpPassword",
                            nil];
        
    //Spawns the engine in a background thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Give this thread a Shield...sorry, a Name! Ref: https://tenor.com/bxn6i.gif
        [[NSThread currentThread] setName:@"NodeJSThread"];
        [[NSThread currentThread] setThreadPriority:1];
        
        dispatch_time_t when = dispatch_time(DISPATCH_WALLTIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_queue_t startQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_after(when, startQueue, ^{
            [NodeRunner startHttpServer];
        });
                
        [NodeRunner startEngine:params];
    });
}

@end


