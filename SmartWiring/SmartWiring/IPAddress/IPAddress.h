//
//  IPAddress.h
//  TCTravel_IPhone
//
//  Created by 陆 鑫 on 13-1-25.
//
//
#define MAXADDRS    32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();
