#Disable Strict Aliasing Optimizations
CFLAGS_KERNEL += -fno-strict-aliasing

obj-$(CONFIG_SEC_NET_FILTER) := secfilter.o
secfilter-y := sec_filter.o \
		tcp_track.o \
		url_parser.o 
