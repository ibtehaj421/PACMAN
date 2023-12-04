
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
    nameBuffer db 20 dup(0),0 ;storing the name in a string to be shown on the screen.

    ;help screen 52 characters
    help db "                    #    #   ######  #      #######",0
         db "                    ######   #       #      ### ###",0
         db "                    ######   ######  #      #######",0
         db "                    #    #   #       #####  ##     ",0
         db "                    #    #   ######  #####  ##     ",0
    helpYval db 4
    ;help screen

    ;grid set up---------------------------------------------------------------------level 1
    rval dd 14
    cval dd 30
    yvalue db 4
    circle db ".",0
    gridRow = 14
    gridCol = 30
    counter dd 0
    current dd 0
    totalCountLevel1 = 318 ;advance to the next level.
    currentPosition = ((gridRow *60) + gridCol)
    ;each row in the grid is 60 characters.
    grid  db "#############################################################",0
          db "# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #",0
          db "# . ######### . ############################# . ######### . #",0
          db "# . . . . . . . . . . . ############# . . . . . . . . . . . #",0
          db "# . ######### . ##### . . . . . . . . . ##### . ######### . #",0
          db "# . . . . . # . ##### . ############# . ##### . # . . . . . #",0
          db "# . . . . . # . # . . . ############# . . . # . # . . . . . #",0
          db "# . ######### . # . # . . . . . . . . . # . # . ######### . #",0
          db "# . # . . . . . # . #     #     #       # . # . . . . . # . #",0
          db "# . # . . . . . # .       #     #         . # . . . . . # . #",0
          db "# . ######### . # . #######     ######### . # . ######### . #",0
          db "# . . . . . . .   . #                   # .   . . . . . . . #",0
          db "# . ######### .   . #                   # .   . ######### . #",0
          db "# . # . . . . . # . ##################### . # . . . . . # . #",0
          db "# . # . . . . . # .                       . # . . . . . # . #",0
          db "# . ######### . # . ##################### . # . ######### . #",0
          db "# . . . . . # . # . . ################# . . # . # . . . . . #",0
          db "# . . . . . # . # . . . . . . . . . . . . . # . # . . . . . #",0
          db "# . ######### . ##### . ############# . ##### . ######### . #",0
          db "# . . . . . . . ##### . . . . . . . . . ##### . . . . . . . #",0
          db "# . ######### . . . . . ############# . . . . . ######### . #",0
          db "# . . . . . . . ############################# . . . . . . . #",0
          db "# . ######### . . . . . . . . . . . . . . . . . ######### . #",0
          db "#############################################################",0

;grid set up---------------------------------------------------------------------level 1
;pacman
    pacman db 'P',0
    pacmanX db 35
    pacmanY db 18
;pacman

;score
    score dd 0
    scorex db 90
    scorey db 3
    scorewx db 80
    scorewy db 3
;score

;ghost
    ghost1 db 'G'
    ghost1X db 35
    ghost1Y db 15
    g1rval dd 11
    g1cval dd 30
    g1move dd 7
;ghost

;coin restore
    coinrestore db 0 ;boolean value that will restore a specific coin at a specific position. The original position my vary but it still shows that a coin exists in the proximity.
    rcoinX db 0
    rcoinY db 0
;coin restore

;lives
    lives dd 3
    livesx db 90
    livesy db 4
    liveswx db 80
    liveswy db 4
;lives

;level 2 starts here first comes the grid for level 2 with power ups.
.code
main PROC
;reset registers
    mov ecx,0
    mov ebx,0
    mov edx,0
    mov eax,0
    goBackToMenu::
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
    mWrite "HELP MENU"

    mov dl,37
    mov dh,20
    call gotoxy
    mWrite "PRESS E TO EXIT."
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
    je gameHelp
    cmp al,'e'
    je shutDown
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
    gameHelp:
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

    cmp cursor,0
    je timeTOSTART
    cmp cursor,1
    je gotothehelpscreen
    timeTOSTART:
    call clrscr
    mov menuYval,4
    call drawmain
    call menuEnterName
    jmp startTheGame
    gotothehelpscreen:
        call clrscr
        call drawHelpScreen
    startTheGame:
    call clrscr
    mov ecx,0
    mov ebx,0
    mov edx,0
    mov eax,0
    call drawGrid
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    mov eax,yellow+(black*16)
    call SetTextColor
    mov eax,'P'
    call writechar
    call gotoxy
    mov esi,offset grid
    mov dl,scorewx
    mov dh,scorewy
    call gotoxy
    mWrite "SCORE: "
    mov dl,scorex
    mov dh,scorey
    call gotoxy
    mov eax,score
    call writedec
    mov dl,liveswx
    mov dh,liveswy
    call gotoxy
    mWrite "LIVES: "
    mov dl,livesx
    mov dh,livesy
    call gotoxy
    mov eax,lives
    call writedec
    mov dl,80
    mov dh,5
    call gotoxy
    mWrite "PLAYER: "
    mov dl,90
    mov dh,5
    call gotoxy
    mov edx,offset nameBuffer
    call writestring
    ;position ghost
    mov eax,magenta+(black*16)
    call SetTextColor
    mov dl,ghost1X
    mov dh,ghost1Y
    call gotoxy
    mov eax,'G'
    call writechar
    mov eax,yellow+(black*16)
    call SetTextColor
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    mov ebx,[esi+634]
    jump2:
        mov eax,yellow+(black*16)
        call SetTextColor
        ;set score
            mov dl,scorex
            mov dh,scorey
            call gotoxy
            mov eax,score
            call writedec
        ;set score

        ;set lives
            mov dl,livesx
            mov dh,livesy
            call gotoxy
            mov eax,lives
            call writedec
        ;set lives

        call pacmanPos
        mov eax,50
        call Delay
        call readkey
        cmp al,'a'
        jz moveLeft
        cmp al,'d'
        jz moveRight
        cmp al,'w'
        jz moveUp
        cmp al,'s'
        jz moveDOWN
        cmp al,'e'
        je shutDown
        jmp movetoend

    moveLeft:
        mov ebx,62
        mov eax,rval
        mul ebx
        add eax,cval
        sub eax,2
        mov current,eax
        mov ebx,[esi+eax]
        cmp bl,'#'
        je movetoend
        cmp bl,'.'
        jne keepmoving
        inc score
        mov bl,' '
        mov [esi+eax],bl
        keepmoving:
        dec cval
        gridCol = cval
        mov eax,gridCol
        mov eax,' '
        call writechar
        dec pacmanX
        mov dl,pacmanX
        mov dh,pacmanY
        call gotoxy
        mov eax,'P'
        call writechar
        call gotoxy
    jmp movetoend

    moveRight:
        mov ebx,62
        mov eax,rval
        mul ebx
        add eax,cval
        add eax,2
        mov ebx,[esi+eax]
        cmp bl,'#'
        je movetoend
        cmp bl,'.'
        jne keepmoving1
        inc score
        mov bl,' '
        mov [esi+eax],bl
        keepmoving1:
        inc cval
        gridCol = cval
   
        mov eax,' '
        call writechar
        inc pacmanX
        mov dl,pacmanX
        mov dh,pacmanY
        call gotoxy
        mov eax,'P'
        call writechar
        call gotoxy
    jmp movetoend

    moveUP:
        mov ebx,62
        mov eax,rval
        dec eax
        mul ebx
        add eax,cval
        mov ebx,[esi+eax]
        cmp bl,'#'
        je movetoend
        cmp bl,'.'
        jne keepmoving2
        inc score
         mov bl,' '
        mov [esi+eax],bl
        keepmoving2:
        dec rval
        mov eax,' '
        call writechar
        dec pacmanY
        mov dl,pacmanX
        mov dh,pacmanY
        call gotoxy
        mov eax,'P'
        call writechar
        call gotoxy
    jmp movetoend

    moveDOWN:
        mov ebx,62
        mov eax,rval
        inc eax
        mul ebx
        add eax,cval
        mov ebx,[esi+eax]
        cmp bl,'#'
        je movetoend
        cmp bl,'.'
        jne keepmoving3
        inc score
         mov bl,' '
        mov [esi+eax],bl
        keepmoving3:
        inc rval
        mov eax,' '
        call writechar
        inc pacmanY
        mov dl,pacmanX
        mov dh,pacmanY
        call gotoxy
        mov eax,'P'
        call writechar
        call gotoxy
        movetoend:
        ;check for ghost1
        cmp g1move,0
        je skipnewmove1
        cmp g1move,2
        je skipnewmove1
        push offset g1move
        call getRanGhost
        skipnewmove1:
        call moveGhost1
        ;check for ghost1
        cmp coinrestore,1
        jne pacmanCollision
        mov eax,white+(black*16)
        call SetTextColor
        mov eax,'.'
        mov dl,rcoinY
        mov dh,rcoinX
        call gotoxy
        mov coinrestore,0
        call writechar
        ;checking pacman and ghost collisions
        pacmanCollision:
        push g1rval
        push g1cval
        call CheckIfGhost
        ;checking pacman and ghost collisions
    jmp jump2
    shutDown::
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
    call crlf
    ;call writedec
ret
menuEnterName endp

drawHelpScreen proc
    
    mov esi,offset help
    mov ecx,5
    mov ebx,52
    mov dl,0
    mov dh,helpYval
    call gotoxy
    drawhelpMessage:
        drawHelpMessage2:
            push ebx
            mov ebx,[esi]
            cmp bl,'#'
            je drawHLetter
            cmp bl,' '
            je drawHSpace
            drawHLetter:
                call drawHash2
                jmp drawHelpAgain
            drawHSpace:
                call drawSpace
            drawHelpAgain:
                inc esi
                pop ebx
                cmp ebx,0
                je drawHelpScreen1
                dec ebx
            jmp drawHelpMessage2
    drawHelpScreen1:
        mov eax,150
        call Delay
        add esi,1
        mov ebx,51
        mov dl,0
        inc helpYval
        mov dh,helpYval
        call gotoxy
    loop drawHelpMessage
    mov dl,20
    mov dh,10
    call gotoxy
    mov eax,white+(black*16)
    call SetTextColor
    mWrite "PRESS W TO GO UP---PRESS S TO GO DOWN---PRESS A TO GO LEFT---PRESS D TO GO RIGHT."
    mov dl,20
    mov dh,11
    call gotoxy
    mWrite "WATCH OUT FOR THE GHOST'S :)"
    mov dl,30
    mov dh,12
    call gotoxy
    mWrite "PRESS B TO GO BACK."
    helpScreenLoop:
    mov eax,50
    call Delay
    call Readkey

    cmp al,'b'
    je timeToGoToTheMenu


    jmp helpScreenLoop

    timeToGoToTheMenu:
    mov menuYval,4
    mov helpYval,4
    call clrscr
    jmp goBackToMenu
ret
drawHelpScreen endp

;game functions
drawGrid proc
    mov dl,5
    mov dh,yvalue
    call gotoxy
    mov esi,offset grid
    ;mov ebx,[esi+62]
    mov ecx,24
    mov ebx,60
    drawGrid1:
        drawGrid2:
        inc counter
        push ebx
        mov ebx,[esi]
       
        cmp bl,"#"
        je drawWall
        cmp bl,"."
        je drawDot
        call drawSpace
        jmp again
        drawWall:
        call drawHash
        jmp again
        drawDot:
        call drawCoin
        again:
        inc esi
        pop ebx
        cmp ebx,0
        je loopAgain
        dec ebx
        
        jmp drawGrid2
        loopAgain:
       ; mov ebx,[esi]
        add esi,1
        mov ebx,60
        mov dl,5
        inc yvalue
        mov dh,yvalue
        call gotoxy
    loop drawGrid1

  
    call crlf
drawGrid endp

drawHash proc
    mov edx,offset hash
    mov eax,blue+(blue*16)
    call SetTextColor
    call writestring

    ret
drawHash endp

drawCoin proc
    mov edx,offset circle
    mov eax,white+(black*16)
    call SetTextColor
    call writestring

    ret
drawCoin endp

pacmanPos proc
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy

ret
pacmanPos endp

getRanGhost proc
    enter 0,0
    call Randomize
    mov eax,4
    call RandomRange
    mov ecx,[ebp+8]
    mov [ecx],eax
    leave
ret 4
getRanGhost endp

moveGhost1 proc
    mov eax,magenta+(black*16)
    call SetTextColor
    mov eax,150
    call Delay
    mov dl,ghost1X
    mov dh,ghost1Y
    call gotoxy
    
    cmp g1move,0
    je g1UP
    cmp g1move,1
    je g1Right
    cmp g1move,2
    je g1Down
    cmp g1move,3
    je g1Left
    g1UP:
         mov ebx,62
         mov eax,g1rval
         dec eax
         mul ebx
         add eax,g1cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         cmp bl,'.'
         jne notRestoreCoinUP
         mov coinrestore,1
         mov ecx,g1rval
         dec ecx
         add ecx,4
         mov edx,g1cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinUP:
         dec g1rval
          mov eax,' '
          call writechar
          dec ghost1Y
          mov dl,ghost1X
          mov dh,ghost1Y
          call gotoxy
          mov eax,'G'
          call writechar
    jmp endMove
    g1Right:
         mov ebx,62
         mov eax,g1rval
         mul ebx
         add eax,g1cval
         add eax,2
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         mov ebx,62
         mov eax,g1rval
         mul ebx
         add eax,g1cval
         add eax,1
         mov ebx,[esi+eax]
         cmp bl,'.'
         jne notRestoreCoinRight
         mov coinrestore,1
         mov ecx,g1rval
         add ecx,4
         mov edx,g1cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1

         notRestoreCoinRight:
         inc g1cval
          mov eax,' '
          call writechar
          inc ghost1X
          mov dl,ghost1X
          mov dh,ghost1Y
          call gotoxy
          mov eax,'G'
          call writechar
          
             
    jmp endMove
    g1Down:
         mov ebx,62
         mov eax,g1rval
         inc eax
         mul ebx
         add eax,g1cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         cmp bl,'.'
         jne notRestoreCoinDOWN
         mov coinrestore,1
         mov ecx,g1rval
         inc ecx
         add ecx,4
         mov edx,g1cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinDOWN:

         inc g1rval
         mov eax,' '
          call writechar
          inc ghost1Y
          mov dl,ghost1X
          mov dh,ghost1Y
          call gotoxy
          mov eax,'G'
          call writechar
    jmp endMove
    g1Left:
         mov ebx,62
         mov eax,g1rval
         mul ebx
         add eax,g1cval
         sub eax,2
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         mov ebx,62
         mov eax,g1rval
         mul ebx
         add eax,g1cval
         add eax,1
         mov ebx,[esi+eax]
         cmp bl,'.'
         jne notRestoreCoinLeft
         mov coinrestore,1
         mov ecx,g1rval
         add ecx,4
         mov edx,g1cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinLeft:
         dec g1cval
          mov eax,' '
          call writechar
          dec ghost1X
          mov dl,ghost1X
          mov dh,ghost1Y
          call gotoxy
          mov eax,'G'
          call writechar
    endMove:
        cmp bl,'#'
        je checkg1move1
        jmp endg1
        checkg1move1:
            cmp g1move,0
            je resetg1move
            cmp g1move,2
            je resetg1move
            jmp endg1
       resetg1move:
       mov g1move,7
    endg1:
ret 
moveGhost1 endp

checkIfGhost proc
    enter 0,0
        mov ecx,[ebp+12]
        mov ebx,[ebp+8]
        cmp rval,ecx
    jne notCollided
        cmp cval,ebx
        jne notCollided
        dec lives
        mov rval,14
        mov cval,30
        mov pacmanX,35
        mov pacmanY,18
    notCollided:
    leave
ret 8
checkIfGhost endp
end main
