loading_bar macro       ;loading bar
    call clear_screen
    gotoxy 33,12
    print "0%"
    call delay

    gotoxy 33,12
    print 178
	print 178
	print 178
	gotoxy 36, 12
	print "25%"

    gotoxy 36,12
    print 178
	print 178
	gotoxy 38, 12
	print "50%"

    gotoxy 38,12
    print 178
	print 178 
	print 178
	gotoxy 41, 12
	print "75%"

    gotoxy 41,12
    print 178  
	print 178 
	gotoxy 43, 12
	print "100%"
    gotoxy 43, 12
    print 178
    print 178 
    print 178
    print 178
    call delay
    call clear_screen
endm        ;end loading bar