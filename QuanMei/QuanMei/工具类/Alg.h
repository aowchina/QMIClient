//
//  Alg.h
//  BISTU
//
//  Created by cash  on 13-6-14.
//  Copyright (c) 2013年 Min-Fo. All rights reserved.
//

#ifndef BISTU_Alg_h
#define BISTU_Alg_h

#define SUCCESS						0
#define FAILURE						1

#define AES_ENCRYPT	1
#define AES_DECRYPT	0

/* Because array size can't be a const in C, the following two are macros.
 Both sizes are in bytes. */
#define AES_MAXNR 14
#define AES_BLOCK_SIZE 16

#ifdef  __cplusplus
extern "C" {
#endif
    
    int encryptedString(const char *Data,char *reval);
    
    int decryptedString(const char *encryptedString,char *outString);
    
    
#ifdef  __cplusplus
}
#endif

#endif
