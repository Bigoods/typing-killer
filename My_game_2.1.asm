include emu8086.inc
include loading.inc

org 100h
 
screen_color ;cor do ecra
call square ;desenha o aro em volta
start_menu:  
    call clear_screen ;chamar funcao clear_screen
    gotoxy 1, 1 
    mov ah, 9
    lea dx, title0 ;titulo
    int 21h 
    gotoxy 1, 2 
    mov ah, 9
    lea dx, title1
    int 21h
    gotoxy 1, 3 
    mov ah, 9
    lea dx, title2
    int 21h
    gotoxy 1, 4 
    mov ah, 9
    lea dx, title3
    int 21h
    gotoxy 1, 5 
    mov ah, 9
    lea dx, title4
    int 21h
    gotoxy 1, 6 
    mov ah, 9
    lea dx, title5
    int 21h
    gotoxy 30, 10                                                                    
    mov ah, 9
    lea dx, menu_0  ;menu
    int 21h 
    gotoxy 30, 11
    mov ah, 9
    lea dx, menu_1
    int 21h
    gotoxy 30, 12
    mov ah, 9
    lea dx, menu_2
    int 21h
    gotoxy 30, 13
    mov ah, 9
    lea dx, menu_3
    int 21h    
    cursoroff 
    menu: 
    gotoxy 30, 14
    print " "  ;apaga o carater caso nao escolha uma das opcoes
    gotoxy 30, 14
    ;ler carater do teclado
    mov ah, 1
    int 21h  
    print 007  ;emite um som
    cmp al, '1'
    je play     ;salto para a funcao play
    cmp al, '2'
    je how      ;salto para a funcao how
    cmp al, '3'
    je exit     ;salto para a funcao exit
    jne menu

    ;define's------------------------------
    define_get_string
    define_print_string
    define_print_num
    define_print_num_uns 

    hlt

 how:
    call clear_screen 
    gotoxy 1, 1
    mov ah, 9
    lea dx, htp_0  ;how to play
    int 21h
    gotoxy 1, 2  
    mov ah, 9
    lea dx, htp_1  
    int 21h
    gotoxy 1, 3
    mov ah, 9
    lea dx, htp_2  
    int 21h
    gotoxy 1, 4 
    mov ah, 9
    lea dx, htp_3  
    int 21h
    gotoxy 1, 5
    mov ah, 9
    lea dx, htp_4  
    int 21h
    gotoxy 1, 7
    mov ah, 9
    lea dx, htp_5 
    int 21h
    gotoxy 1, 8       
    mov ah, 9
    lea dx, htp_6  
    int 21h
    gotoxy 1, 9       
    mov ah, 9
    lea dx, htp_7  
    int 21h      
    gotoxy 1, 10
    mov ah, 1
    int 21h 
    print 007
    cmp al, 'b'
    je start_menu   ;go to menu
    cmp al, 'p'
    je play         ; go play the game
    jne exit

 play:     ;iniciar o jogo
    call clear_screen 
    gotoxy 1, 1
    mov ah, 9
    lea dx, inser ;inserir nome
    int 21h 
    gotoxy 1, 2
    call get_string ;inserir nome
    print 007
    call clear_screen
    gotoxy 1, 1
    print "Hello "
    call print_string ;escrever nome
    print ", let's play the game. Good luck, have fun."
    call delay
    loading_bar
    
    include open_file.inc  
    
    open_file   ;abre ficheiro
    read_word   ;le palavras e contem as comparacoes, o jogo
    close_file  ;fecha o ficheiro
    
    ;mov ah, 7   ;imput sem aparecer no ecra
    ;int 21h 
    call delay  
    gotoxy 0, 24
    print "          "  ;apaga o score 
    call clear_screen
    gotoxy 20, 10
    mov ah, 9
    lea dx, end0   ;end bye bye
    int 21h
    gotoxy 20, 11  
    mov ah, 9
    lea dx, end1  
    int 21h
    gotoxy 20, 12
    mov ah, 9
    lea dx, end2  
    int 21h
    gotoxy 20, 13 
    mov ah, 9
    lea dx, end3  
    int 21h
    hlt
	
exit:     ;sair do jogo
    mov ah, 9
    lea dx, bye
    int 21h 
    mov ah, 4ch
    int 21h  

 ;DELAY 1sec
delay: 
    pusha
    pushf
    mov ah, 0
    int 1ah
    mov di, 30
    mov ah, 0
    int 1ah
    mov bx, dx
    wait:
    mov ah, 0
    int 1ah
    sub dx, bx
    cmp di, dx
    ja wait
    popf
    popa
    ret 
     
square:  
    gotoxy 0, 0
    mov ah, 9
    lea dx, quad_0  ;parte de cima
    int 21h        
    mov col, 0 
    mov row, 1
    loop:      ;lado esquerdo
        gotoxy col, row 
        mov ah, 9
        lea dx, quad_1  
        int 21h
        inc row
        cmp row, 23
        jne loop
        mov col, 79
        mov row, 1
    loop2:     ;lado direito
        gotoxy col, row 
        mov ah, 9
        lea dx, quad_1  
        int 21h
        inc row
        cmp row, 23
        jne loop2
    gotoxy 0, 23
    mov ah, 9
    lea dx, quad_2 ;parte de baixo
    int 21h     
    ret      
yellow_word:  ;pintar ecra de amarelo com letras pertas 
    pusha
    pushf
    mov cl, 1d  ;x inicial
    mov ch, 1d  ;y inicial
    mov dl, 78d ;x final
    mov dh, 22d ;y final  
    mov ah, 06h ;scroll up
    mov al, 22d ;quantidade de linhas de scroll
    mov bh, 11100000b ;cor da consola
    int 10h
    popf
    popa
    ret
 
red_word:     ;pintar ecra de vermelhor com letras brancas
    pusha
    pushf
    mov cl, 1d  ;x inicial
    mov ch, 1d  ;y inicial
    mov dl, 78d ;x final
    mov dh, 22d ;y final 
    mov ah, 06h ;scroll up
    mov al, 22d ;quantidade de linhas de scroll
    mov bh, 4Fh ;cor da consola 
    int 10h 
    popf
    popa
    ret
    
clear_screen: ;apagar ecra apenas entre os aros 
    pusha
    pushf 
    mov cl, 1d  ;x inicial
    mov ch, 1d  ;y inicial
    mov dl, 78d ;x final
    mov dh, 22d ;y final
    mov ah, 06h ;scroll up
    mov al, 22d ;quantidaiade de linhas de scroll
    mov bh, 71h ;cor da consola
    int 10h
    popf
    popa
    ret 
    
random_number: 
   mov ah, 00h  ; interrupts to get system time        
   int 1ah      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 3    
   div  cx       ; here dx contains the remainder of the division - from 0 to 2

   ;add  dl, '0'  ; to ascii from '0' to '2'    
ret    

clear_buffer:    ;clear buffer do teclado
    key:
        mov     ah, 01h ;check key
        int     16h
        jz      no_key
        mov     ah, 00h ;read key
        int     16h
        jmp key
    no_key:
    ret

;------------------------------------------
 menu_0 db "Please select an option:", '$'
 menu_1 db "1. Play the game", '$'
 menu_2 db "2. How to play", '$'
 menu_3 db "3. Exit", '$'
 htp_0 db "How to play the game?", '$'
 htp_1 db " In this single player game the objective is to type all the words that", '$' 
 htp_2 db "appear  on the screen. By correctly writing a word, you destroy it. Destroy as", '$'
 htp_3 db "many words as you can. But be careful, because you have limited time to write", '$'
 htp_4 db "a correct letter.", '$'
 htp_5 db "Lets play (Press p)", '$'
 htp_6 db "Go back (Press b)", '$'
 htp_7 db "Exit (Press other key)", '$'
 bye db 10, 13, 186, "Bye-bye, see you soon", '$'
 inser db "Your name:", '$'
 filename db "words.txt" 
 filehandle dw ?    
 text db 255 dup(0) 
 palavra db 255 dup(0)
 char db ?  
 col db 1
 row db 1 
 quad_0 db 201, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 187, '$'
 quad_1 db 186, '$'
 quad_2 db 200, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 188, '$'
 clear db "                                                                              $"
 score db 0 
 time db 5
                                                                                           
title0 db " _________             .__                  __   .__.__  .__        $"
title1 db " \__  ___/__.__.______ |__| ____    ____   |  | _|__|  | |  |   ___________ $"
title2 db "   |  | <   |  |\____ \|  |/    \  / ___\  |  |/ /  |  | |  | _/ __ \_  __ \$"
title3 db "   |  |  \___  ||  |_> >  |   |  \/ /_/  > |    <|  |  |_|  |_\  ___/|  | \/$"
title4 db "   |__|  / ____||   __/|__|___|  /\___  /  |__|_ \__|____/____/\___  >__|$"   
title5 db "         \/     |__|           \//_____/        \/                 \/ $"
 

end0 db " ____  _  _  ____     ____  _  _  ____ $"
end1 db "(  _ \( \/ )(  __)___(  _ \( \/ )(  __)$"
end2 db " ) _ ( )  /  ) _)(___)) _ ( )  /  ) _) $"
end3 db "(____/(__/  (____)   (____/(__/  (____)$"