;ibtehaj haider,22i0767,CS-D
include Irvine32.inc
include Macros.inc
.386
.model flat,stdcall
.stack 4096

.data
    ;main menu
    ;main menu shapez
      
    mainmenu  db "                 #######     #      ######      #        #          #      #      ####                                      ",0
              db "                 ### ###    ###     ######     ###      ###        ###     ##     ####                                      ",0
              db "                 #######   #####    #         #####    #####      #####    #####  ####                                      ",0
              db "                 ##       ### ###   #        ################    ### ###   ###########                                      ",0
              db "                 ##      #########  ######  ##################  #########  ###########                                      ",0
    menuYval db 4         
    ;125 characters
    ;main menu shapez
    hash db "#",0
    space db " ",0
    cursor db 0 ;indicates that the game is meant to be started
    nameBuffer db 10 dup(0),0
.code
main PROC
;reset registers
    mov ecx,0
    mov ebx,0
    mov edx,0
    mov eax,0
    call drawmain
    mov eax,blue+(black*16)
    call SetTextColor
    mov dl,40
    mov dh,16
    call gotoxy
    mov eax,150
    call Delay
    mWrite "START GAME"
    mov dl,40
    mov dh,17
    call gotoxy
    mWrite "EXIT GAME"
    ;cursor
    mov eax,'>'
    mov dl,36
    mov dh,16
    call gotoxy
    call writechar
    call gotoxy
    jumpmain:
        mov eax,50
        call Delay
        call ReadKey

    cmp al,'w'
    je gameStart
    cmp al,'s'
    je gameExit
    cmp al,'y'
    je OptionChosen
    jmp jumpmain
    gameStart:
        mov eax,' '
        mov dl,36
        mov dh,17
        call gotoxy
        call writechar
        mov eax,white+(black*16)
        call SetTextColor
        mov cursor,0
        mov eax,'>'
        mov dl,36
        mov dh,16
        call gotoxy
        call writechar
        call gotoxy
        jmp jumpMain
    gameExit:
        mov eax,' '
        mov dl,36
        mov dh,16
        call gotoxy
        call writechar
        mov eax,white+(black*16)
        call SetTextColor
        mov cursor,1
        mov eax,'>'
        mov dl,36
        mov dh,17
        call gotoxy
        call writechar
        call gotoxy
    jmp jumpmain

    OptionChosen:
    call clrscr
    mov menuYval,4
    call drawmain
    call menuEnterName
Invoke ExitProcess,0
main ENDP

drawmain proc
    mov esi,offset mainmenu
    mov ecx,5
    mov ebx,123
    mov dl,0
    mov dh,menuYval
    call gotoxy
    drawPac:
        drawPac2:
            push ebx
            mov ebx,[esi]
            cmp bl,'#'
            je drawLetter
            cmp bl,' '
            je drawspes
            drawLetter:
                call drawHash2
                jmp menuAgain
            drawspes:
                call drawSpace
            menuAgain:
                inc esi
                pop ebx
                cmp ebx,0
                je loopmenuAgain
                dec ebx
               
        jmp drawPac2
    loopmenuAgain:
         mov eax,150
         call Delay
        add esi,1
        mov ebx,123
        mov dl,0
        inc menuYval
        mov dh,menuYval
        call gotoxy
    loop drawPac
ret
drawmain endp

drawHash2 proc
    mov edx,offset hash
    mov eax,yellow+(yellow*16)
    call SetTextColor
    call writestring

    ret
drawHash2 endp

drawSpace proc
    mov edx,offset space
    mov eax,black+(black*16)
    call SetTextColor
    call writestring

    ret
drawSpace endp

menuEnterName proc
    mov eax,white+(black*16)
    call SetTextColor
    mov dl,40
    mov dh,16
    call gotoxy
    mov ecx,11
    mWrite "ENTER YOUR NAME: "
    mov edx,offset nameBuffer
    call readstring

ret
menuEnterName endp
end main
