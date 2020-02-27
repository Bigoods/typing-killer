open_file macro
            mov dx, offset filename
            mov al, 0
            mov ah, 3Dh      ;open file
            int 21h
            mov filehandle, ax
            lea si, text

        ;      mov al, 1
	;      mov bx, filehandle
	;      mov cx, 0
        ;      mov dx, 2
  	;      mov ah, 42h
	;      int 21h ; seek...
endm

read_word macro
    read_line:
            mov ah, 3Fh      ;read file
            mov bx, filehandle
            lea dx, char
            mov cx, 1
            int 21h
            cmp ax, 0       ;EOF
            je EO_file
            mov al, char
            cmp al, 0ah     ; line feed
            je LF
            mov [si], al
            inc si
            jmp read_line

    EO_file:

            lea dx, text    ;DX=offset(address) of text
            mov ah, 40h     ;print
            mov cx, si      ;CX = # characters. Move pointer to last char to it
            sub cx, dx      ;Subtract the offset of text (in DX) from CX
                            ;To get the actual number of chars in the buffer
            mov bx, 1
            int 21h
            jmp read_line

    LF: 
            call clear_screen
            call clear_buffer
            again:
            call random_number
            ;mov dl, 0
            call Set_col      ;coluna em que a palavra aparece no ecra
            call random_number
            ;mov dl, 0
            call Set_row      ;linha em que a palavra aparece no ecra
            cmp col, 34
            je dois
            nao:
            gotoxy col, row
            lea dx, text    ;DX=offset(address) of text
            ;mov ah, 40h     ;print
            mov cx, si      ;CX = # characters. Move pointer to last char to it
            sub cx, dx      ;Subtract the offset of text (in DX) from CX
                            ;To get the actual number of chars in the buffer
            mov bx, 1
            ;int 21h
            dec cx  ;retirar o enter que a palavra tem no fim
            jmp desenho
            start_compare:
                call clear_buffer
                gotoxy col, row 
                print "          "    ;apaga a palavra no sitio onde estava
                cmp row, 1
                je cima
                cmp row, 6
                je cima
                cmp row, 11
                je cima
                cmp row, 22
                je baixo
                cmp row, 18
                je baixo
                cmp row, 14
                je baixo
                cmp row, 12
                je meio 
                cima_esquerda:
                    add col, 17 ;anda para a direita ficando em 1/4 do ecra
                    add row, 5  ;desce ate ficar em 1/4 do ecra 
                    cmp row, 6
                    je yellow1   ;ecra amarelo pois so tem mais 2 oportunidades
                    gy1:
                    cmp row, 11
                    je red1      ;ecra vermelhor pois so tem mais 1 oportunidade
                    gr1:
                    gotoxy col, row
                    cmp row, 12
                    jge lose    ;perdeu
                    jl desenho
                cima_meio:
                    add row, 5  
                    cmp row, 6
                    je yellow2  
                    gy2:
                    cmp row, 11
                    je red2     
                    gr2:
                    gotoxy col, row
                    cmp row, 12
                    jge lose    ;perdeu
                    jl desenho
                cima_direita:
                    sub col, 12 
                    add row, 5  
                    cmp row, 6
                    je yellow3   
                    gy3:
                    cmp row, 11
                    je red3     
                    gr3:
                    gotoxy col, row
                    cmp row, 12
                    jge lose    ;perdeu
                    jl desenho
                meio_esquerdo:
                    add col, 10 
                    cmp col, 11
                    je yellow4  
                    gy4:
                    cmp col, 21
                    je red4     
                    gr4:
                    gotoxy col, row
                    cmp col, 22
                    jge lose    ;perdeu
                    jl desenho
                meio_direito:
                    sub col, 11 
                    cmp col, 54
                    je yellow5   
                    gy5:
                    cmp col, 43
                    je red5      
                    gr5:
                    gotoxy col, row
                    cmp col, 42
                    jle lose    ;perdeu
                    jg desenho
                baixo_esquerdo:
                    add col, 17 
                    sub row, 4  
                    cmp row, 18
                    je yellow6  
                    gy6:
                    cmp row, 14
                    je red6      
                    gr6:
                    gotoxy col, row
                    cmp row, 12
                    jle lose    ;perdeu
                    jg desenho
                baixo_meio:
                    sub row, 4  
                    cmp row, 18
                    je yellow7  
                    gy7:
                    cmp row, 14
                    je red7      
                    gr7:
                    gotoxy col, row
                    cmp row, 12
                    jle lose    ;perdeu
                    jg desenho
                baixo_direita:
                    sub col, 10 
                    sub row, 4 
                    cmp row, 18
                    je yellow8  
                    gy8:
                    cmp row, 14
                    je red8     
                    gr8:
                    gotoxy col, row
                    cmp row, 12
                    jle lose    ;perdeu
                    jg desenho
                desenho:
                mov ah, 40h ;escreve a palavra que leu do ficheiro
                int 21h
                gotoxy 39, 12
                print 015   ;meio do ecra
                gotoxy 0, 24
                print "Score: "
                mov ah, 0
                mov al, score
                call print_num
                mov si, 0
            comparar:
                gotoxy 39, 12
                cmp si, cx  ;compara para saber se chegou ao fim da palavra
                je stop     ;chegou ao final da palavra e acertou tds as letras
                mov ah, 01h
                int 16h
                jnz Wkey    ;se tiver letras no buffer salta pra Wkey=With key
                  n_key:    
                  mov ah, 0
                  mov al, time
                  gotoxy 39, 24
                  call print_num
                  call delay
                  cmp time, 0   ;compara se o temporizador chegou a 0
                  je lose
                  dec time
                  mov ah, 01h
                  int 16h
                  jz n_key  ;loop enquanto nao tem letras no buffer
                Wkey:
                gotoxy 39, 12
                mov ah, 1
                int 21h
                cmp al, text[si]    ;compara a letra inserida com a palavra que foi lida do ficheiro de texto
                je incrementa
                jne start_compare
            incrementa: ;acertou na letra e passa para a proxima letra da palavra e ganha mais 5 segundos
                inc si
                mov time, 5
                jmp comparar
            stop:
                gotoxy 36, 12
                print "Got it!" ;acertou na palavra toda
                call clear_buffer
                gotoxy 7, 24
                inc score   ;+1 ponto de score
                mov ah, 0
                mov al, score
                call print_num
            mov si, dx      ;Start from beginning of buffer 
                            ;(DX=beginning of text buffer)
        jmp read_line
        yellow1:
            call yellow_word
            jmp gy1
        red1:
            call red_word
            jmp gr1
        yellow2:
            call yellow_word
            jmp gy2
        red2:
            call red_word
            jmp gr2
        yellow3:
            call yellow_word
            jmp gy3
        red3:
            call red_word
            jmp gr3
        yellow4:
            call yellow_word
            jmp gy4
        red4:
            call red_word
            jmp gr4
        yellow5:
            call yellow_word
            jmp gy5
        red5:
            call red_word
            jmp gr5
        yellow6:
            call yellow_word
            jmp gy6
        red6:
            call red_word
            jmp gr6
        yellow7:
            call yellow_word
            jmp gy7
        red7:
            call red_word
            jmp gr7
        yellow8:
            call yellow_word
            jmp gy8
        red8:
            call red_word
            jmp gr8           
        Set_col:
        ; mov ah, 7
        ; int 21h
            cmp dl, 0
            je ze
            cmp dl, 1
            je um
            cmp dl, 2
            je do
            ze:
                mov col, 1
                ret
            um:
                mov col, 34
                ret
            do:
                mov col, 65
                ret
            ret
            Set_row:
                cmp dl, 0
                je zer
                cmp dl, 1
                je umm
                cmp dl, 2
                je doo
                zer:
                    mov row, 1
                    ret
                umm:
                    mov row, 12
                    ret
                doo:
                    mov row, 22
                    ret
                ret
        
        dois: 
        cmp row, 12
        je again
        jne nao
        cima:
            cmp col, 1
            je cima_esquerda
            cmp col, 18
            je cima_esquerda
            cmp col, 35
            je cima_esquerda
            cmp col, 34
            je cima_meio
            cmp col, 65
            je cima_direita
            cmp col, 53
            je cima_direita
            cmp col, 41
            je cima_direita
        meio:
            cmp col, 1
            je meio_esquerdo
            cmp col, 11
            je meio_esquerdo
            cmp col, 21
            je meio_esquerdo
            cmp col, 65
            je meio_direito
            cmp col, 54
            je meio_direito
            cmp col, 43
            je meio_direito
        baixo:
            cmp col, 1
            je baixo_esquerdo
            cmp col, 18
            je baixo_esquerdo
            cmp col, 35
            je baixo_esquerdo
            cmp col, 34
            je baixo_meio
            cmp col, 65
            je baixo_direita
            cmp col, 55
            je baixo_direita
            cmp col, 45
            je baixo_direita
        lose:
            call clear_screen
            call clear_buffer
            gotoxy 39, 24
            print " "
            gotoxy 27, 12
            print "You lost " 
            call print_string   ;apresenta o nome que foi inserido no inicio
            print ". Feels bad bro."
            gotoxy 27, 13
            print "Please restart the game!!"
endm

close_file macro
        mov bx, filehandle
        mov ah, 3eh
        int 21h
endm

screen_color macro
	PUSH AX
	PUSH BX
	PUSH CX
	mov ah, 09h
    mov cx, 1000h
    mov al, 20h
    mov bl, 71h 
    int 10h
	POP CX 
	POP BX
	POP AX
endm