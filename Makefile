AS	= as
LD	= ld
LDFLAGS	= -T boot.ld

OBJS	= boot.o
all:	boot.img

.S.o:
	$(AS) -o $@ $<

boot.bin:$(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

boot.img:boot.bin
	cat $< > $@
	

