#ifndef BITCRACKER_COMPAT_UNISTD_H
#define BITCRACKER_COMPAT_UNISTD_H

#ifdef _WIN32
#include "getopt.h"
#else
#include_next <unistd.h>
#endif

#endif
