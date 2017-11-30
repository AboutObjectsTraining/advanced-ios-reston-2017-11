/// Debug logging macro. Removed during Release builds.
#ifdef DEBUG
#define DLOG(format, ...) NSLog(format, ##__VA_ARGS__);
#else
#define DLOG(format, ...)
#endif