
include Irvine32.inc
include Macros.inc
.386
;.model flat,stdcall
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

    ;pause screen------------
    pause1 db "        #######     #     ##    ##   ######  ######",0
           db "        ### ###    ###    ##    ##   ###     #     ",0
           db "        #######   #####   ########   ######  ######",0
           db "        ##       #######  ########      ###  #     ",0
           db "        ##      ######### ########   ######  ######",0
    pauseYval db 4
    ;pause screen------------

    ;gameover-----------------------------------
    game   db "         ######     #        #        #    ######  ",0
           db "         ##        ###      ###      ###   #       ",0
           db "         ##   #   #####    ##############  ######  ",0
           db "         ######  #######  ################ #       ",0
           db "         ###### ######### ################ ######  ",0
    gameYval db 4
    over1  db "         ###### #       #  ######  #######         ",0
           db "         ###### ##     ##  #       ### ###         ",0
           db "         ### ## ###   ###  ######  ## #            ",0
           db "         ###### #### ####  #       ##  #           ",0
           db "         ###### #########  ######  ##   #          ",0
    overYval db 10
    ;gameover-----------------------------------

    ;grid set up---------------------------------------------------------------------level 1
    rval dd 14
    cval dd 30
    yvalue db 4
    circle db ".",0
    gridRow = 14
    gridCol = 30
    counter dd 0
    current dd 0
    totalCountLevel1 = 320 ;advance to the next level.
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
    scorey db 6
    scorewx db 80
    scorewy db 6
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
    livesy db 7
    liveswx db 80
    liveswy db 7
;lives

;level 2 starts here first comes the grid for level 2 with power ups.
 grid2    db "#############################################################",0
          db "# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #",0
          db "# . ######### . ############################# . ######### . #",0
          db "# . . . . . . . . . O . ############# . . . . . . . . . . . #",0
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
          db "# O . . . . # . # . . ################# . . # . # . . . . O #",0
          db "# . . . . . # . # . . . . . . . . . . . . . # . # . . . . . #",0
          db "# . ######### . ##### . ############# . ##### . ######### . #",0
          db "# . . . . . . . ##### . . . . . . . . . ##### . . . . . . . #",0
          db "# . ######### . . . . . ############# O . . . . ######### . #",0
          db "# . . . . . . . ############################# . . . . . . . #",0
          db "# . ######### . . . . . . . . . . . . . . . . . ######### . #",0
          db "#############################################################",0
    scoreUp db "O",0
    ;level 2 grid with updated values on some indexes for the score increasing power ups.
    ;level 2 ghost with more complex movement.
    ghost2X db 35
    ghost2Y db 15
    g2rval dd 11
    g2cval dd 30
    g2move dd 7
    inBox db 1
    lastMove db 0
    wallHit db 0
    firstExit db 0
    ;level 2 ghost with more complex movement.

    ;level number
    levelNum db 1
    ;level number

    ;level3-------------------------------------------------------------------
    grid3 db "#############################################################",0
          db "# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #",0
          db "# . ######### . ############################# . ######### . #",0
          db "# . . . . . . . . . O . ############# . . . . . . . . . . . #",0
          db "# . ######### . ##### . . . . . . . . . ##### . ######### . #",0
          db "# . . . . . # . ##### . ############# . ##### . # . . . . . #",0
          db "# . . . . . # . ] . . . ############# . . . # . # . . . . . #",0
          db "# . ######### . # . # . . . . . . . . . # . [ . ######### . #",0
          db "# . # . . . . . # . #     #     #       # . # . . . . . # . #",0
          db "# . # . . . . . # .       #     #         . # . . . . . # . #",0
          db "# . ######### . # . #######     ######### . # . ######### . #",0
          db "# . . . . . . .   . #                   # .   . . . . . . . #",0
          db "# . ######### .   . #                   # .   . ######### . #",0
          db "# . # . . . . . # . ##################### . # . . . . . # . #",0
          db "# . # . . . . . # .                       . # . . . . . # . #",0
          db "# . ######### . # . ##################### . # . ######### . #",0
          db "# O . . . . # . # . . ################# . . # . # . . . . O #",0
          db "# . . . . . ] . # . . . . . . . . . . . . . [ . # . . . . . #",0
          db "# . ######### . ##### . ############# . ##### . ######### . #",0
          db "# . . . . . . . ##### . . . . . . . . . ##### . . . . . . . #",0
          db "# . ######### . . . . . ############# O . . . . ######### . #",0
          db "# . . . . . . . ############################# . . . . . . . #",0
          db "# . ######### . . . . . . . . . . . . . . . . . ######### . #",0
          db "#############################################################",0
    teleportLeft db "]",0
    teleportRight db "[",0
    ;level3-------------------------------------------------------------------

    ;ghost 3----
    ghost3X db 35
    ghost3Y db 15
    g3rval dd 11
    g3cval dd 30
    g3move db 7
    inBox3 db 1
    lastMove3 db 0
    wallHit3 db 0
    firstExit3 db 0
    ;ghost 3----
.code
main PROC
;reset registers
    call Randomize
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
    push offset grid
    call drawGrid
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    mov eax,yellow+(black*16)
    call SetTextColor
    mov eax,'P'
    call writechar
    call gotoxy
    exitPauseLevel1::
    mov esi,offset grid
    call gamesetup
    ;calling level 1 here
    ;call level1
    ;calling level 1 here
    jumpToLevel2::
    mov pacmanY,18
    mov pacmanX,35
    exitPauseLevel2::
    call clrscr
    mov yvalue,4
    push offset grid2
    call drawGrid
    mov esi,offset grid2
    call gamesetup
    ;call level2
    jumpToLevel3::
    ;callinglevel3
    mov pacmanY,18
    mov pacmanX,35
    call clrscr
    mov yvalue,4
    push offset grid3
    call drawGrid
    mov esi,offset grid3
    call gamesetup
    ;call level3
    ;callinglevel3
    call clrscr
    gameover::
    call clrscr
    call gameoverscreen
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
    mWrite "WATCH OUT FOR THE GHOSTS x-x"
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
    push ebp
    mov ebp,esp
    mov dl,5
    mov dh,yvalue
    call gotoxy
    mov esi,[ebp+8]
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
        cmp bl,'O'
        je drawPowerUP1
        cmp bl,']'
        je drawTeleport
        cmp bl,'['
        je drawTeleport
        call drawSpace
        jmp again
        drawWall:
        call drawHash
        jmp again
        drawDot:
        call drawCoin
        jmp again
        drawPowerUP1:
        call scorePower
        jmp again
        drawTeleport:
        call Teleporter
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
        mov eax,50
        call Delay
    loop drawGrid1

    pop ebp
    call crlf
ret 4
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

Teleporter proc
    mov eax,cyan+(black*16)
    call SetTextColor
    cmp bl,']'
    jne rightSide
    mov edx,offset teleportLeft
    call writestring
    jmp endFunc
    rightSide:
    mov edx,offset teleportRight
    call writestring
    endFunc:
ret
Teleporter endp
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
    mov eax,50
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
         add eax,1
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
         sub eax,1
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

level1 proc
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
        cmp lives,0
        je gameover
        cmp score,320
        je jumpToLevel2
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

ret
level1 endp

scorePower proc
    mov edx,offset scoreUP
    mov eax,white+(black*16)
    call SetTextColor
    call writestring
ret
scorePower endp

getTracking proc
    ;ghost that tracks pacmans position and moves accordingly
    cmp inBox,1
    jne goNext
    cmp ghost2Y,11
    jne goNext
    mov inBox,0
    goNext:
    cmp inBox,1
    jne startTracking
    mov g2move,0
    mov lastMove,0
    jmp endFunc
    startTracking:
    cmp firstExit,0
    jne track
    
    mov g2move,3
    mov lastMove,3
    jmp endFunc
    ;start comparing the values for movement now
    ;pacmanX and pacmanY
    track:
    ;comparisons for the positions where the ghost can escape from.
        cmp ghost2X,43
        jne checkP2
        cmp ghost2Y,21
        jne checkP2
        mov wallHit,1
        jmp track1
        checkP2:
        cmp ghost2X,27
        jne checkP3
        cmp ghost2Y,21
        jne checkP3
        mov wallHit,1
        jmp track1
        checkP3:
        cmp ghost2X,47
        jne checkP4
        cmp ghost2Y,16
        jne checkP4
        mov wallHit,1
        jmp track1
        checkP4:
        cmp ghost2X,23
        jne checkP5
        cmp ghost2Y,16
        jne checkP5
        mov wallHit,1
        checkP5:
        cmp ghost2X,43
        jne checkP6
        cmp ghost2Y,8
        jne checkP6
        mov wallHit,1
        jmp track1
        checkP6:
        cmp ghost2X,27
        jne checkP7
        cmp ghost2Y,8
        jne checkP7
        mov wallHit,1
        jmp track1
        checkP7:
        cmp ghost2X,51
        jne checkP8
        cmp ghost2Y,5
        jne checkP8
        mov wallHit,1
        jmp track1
        checkP8:
        cmp ghost2X,19
        jne checkP9
        cmp ghost2Y,5
        jne checkP9
        mov wallHit,1
        jmp track1
        checkP9: ;we will keep on adding more points.
    track1:
    cmp wallHit,0
    je endFunc
    

    mov al,ghost2Y
    mov ah,ghost2X
    cmp lastMove,0 ;the last done move was upwards
    jne Direction1
    cmp ah,pacmanX
    jg moveLEFT
    mov lastMove,1
    mov g2move,1
    mov wallHit,0
    jmp endFunc
    moveLEFT:
    mov lastMove,3
    mov g2move,3
    mov wallHit,0
    jmp endFunc
    Direction1:
    cmp lastMove,1 ;the last done move was towards the right
    jne Direction2
         
    cmp al,pacmanY
    jg moveUP1
         mov ebx,62
         mov eax,g2rval
         inc eax
         mul ebx
         add eax,g2cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je moveUP1
    mov lastMove,2
    mov g2move,2
    mov wallHit,0
    jmp endFunc
    moveUP1:
         mov ebx,62
         mov eax,g2rval
         dec eax
         mul ebx
         add eax,g2cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         jne findIfLeft
    leftNotFound:
    mov lastMove,0
    mov g2move,0
    mov wallHit,0
    jmp endFunc
    findIfLeft:
        mov al,ghost2Y
        cmp al,pacmanY
        jg leftNotFound
         mov g2move,3
        mov lastMove,3
        mov wallHit,0
    jmp endFunc
    Direction2:
    cmp lastMove,2 ;the last done move was done downwards
    jne Direction3
    cmp ah,pacmanX
    jl goRIGHT    
    mov g2move,3
    mov lastMove,3
    mov wallHit,0
    jmp endFunc
    goRIGHT:
    mov g2move,1
    mov lastMove,1
    mov wallHit,0
    jmp endFunc
    Direction3: ;the last move was done towards the left
    cmp al,pacmanY
    jg moveUP
        mov ebx,62
         mov eax,g2rval
         inc eax
         mul ebx
         add eax,g2cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je moveUP
    mov lastMove,2
    mov g2move,2
    mov wallHit,0
    jmp endFunc
    moveUP:
        mov ebx,62
         mov eax,g2rval
         dec eax
         mul ebx
         add eax,g2cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         jne findIfRight
    rightNotFound:
    mov lastMove,0
    mov g2move,0
    mov wallHit,0
    jmp endFunc
    findIfRight:
        ;seeing if going right would suffice or not.
        mov al,ghost2Y
        cmp al,pacmanY
        jg rightNotFound
        mov g2move,1
        mov lastMove,1
        mov wallHit,0
    endFunc:
ret
getTracking endp
ghost2movement proc
    ;ghost 2 has a complex movement compared to the first ghost.
    ;this ghost will try to move closer to the player.
    ;will be colored green.
    mov eax,red+(black*16)
    call SetTextColor
    mov eax,50
    call Delay
    mov dl,ghost2X
    mov dh,ghost2Y
    call gotoxy
    
    cmp g2move,0
    je g2UP
    cmp g2move,1
    je g2Right
    cmp g2move,2
    je g2Down
    cmp g2move,3
    je g2Left
    g2UP:
         mov ebx,62
         mov eax,g2rval
         dec eax
         mul ebx
         add eax,g2cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         cmp bl,'.'
         jne notRestoreCoinUP
         mov coinrestore,1
         mov ecx,g2rval
         dec ecx
         add ecx,4
         mov edx,g2cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinUP:
         dec g2rval
          mov eax,' '
          call writechar
          dec ghost2Y
          mov dl,ghost2X
          mov dh,ghost2Y
          call gotoxy
          mov eax,'G'
          call writechar
    jmp endMove
    g2Right:
         mov ebx,62
         mov eax,g2rval
         mul ebx
         add eax,g2cval
         add eax,2
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         mov ebx,62
         mov eax,g2rval
         mul ebx
         add eax,g2cval
         add eax,1
         mov ebx,[esi+eax]
         cmp bl,'.'
         jne notRestoreCoinRight
         mov coinrestore,1
         mov ecx,g2rval
         add ecx,4
         mov edx,g2cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1

         notRestoreCoinRight:
         inc g2cval
          mov eax,' '
          call writechar
          inc ghost2X
          mov dl,ghost2X
          mov dh,ghost2Y
          call gotoxy
          mov eax,'G'
          call writechar
          
             
    jmp endMove
    g2Down:
         mov ebx,62
         mov eax,g2rval
         inc eax
         mul ebx
         add eax,g2cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         cmp bl,'.'
         jne notRestoreCoinDOWN
         mov coinrestore,1
         mov ecx,g2rval
         inc ecx
         add ecx,4
         mov edx,g2cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinDOWN:

         inc g2rval
         mov eax,' '
          call writechar
          inc ghost2Y
          mov dl,ghost2X
          mov dh,ghost2Y
          call gotoxy
          mov eax,'G'
          call writechar
    jmp endMove
    g2Left:
         mov ebx,62
         mov eax,g2rval
         mul ebx
         add eax,g2cval
         sub eax,2
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         mov ebx,62
         mov eax,g2rval
         mul ebx
         add eax,g2cval
         add eax,1
         mov ebx,[esi+eax]
         cmp bl,'.'
         jne notRestoreCoinLeft
         mov coinrestore,1
         mov ecx,g2rval
         add ecx,4
         mov edx,g2cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinLeft:
         dec g2cval
          mov eax,' '
          call writechar
          dec ghost2X
          mov dl,ghost2X
          mov dh,ghost2Y
          call gotoxy
          mov eax,'G'
          call writechar
    endMove:
        cmp bl,'#'
        je checkg1move1
        jmp endg1
        checkg1move1:
            mov wallhit,1
            mov firstExit,1
       resetg1move:
       mov g2move,7
    endg1:
ret
ghost2movement endp

level2 proc
 ;level 2 introduces a new ghost and a score increasing power up that will increase the current score.
 ;there is a score quota for each level that once passed make the player eligible to move onto the next level.
 ;position ghost
    mov levelNum,2
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
        cmp lives,0
        je gameover
        cmp score,500
        je jumpToLevel3
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
        cmp al,'p'
        je timetopause
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
        jne ScoreInc
        inc score
        ScoreInc:
        cmp bl,'O'
        jne keepmoving
        add score,10
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
        jne ScoreUp1
        inc score
        ScoreUp1:
        cmp bl,'O'
        jne keepmoving1
        add score,10
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
        jne ScoreUp2
        inc score
        ScoreUp2:
        cmp bl,'O'
        jne keepmoving2
        add score,10
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
       jne ScoreUp3
        inc score
        ScoreUp3:
        cmp bl,'O'
        jne keepmoving3
        add score,10
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
        jne ghost2
        mov eax,white+(black*16)
        call SetTextColor
        mov eax,'.'
        mov dl,rcoinY
        mov dh,rcoinX
        call gotoxy
        mov coinrestore,0
        call writechar
        ;check for ghost2
        ghost2:
        
        call getTracking
       
        call Ghost2movement
        ;check for ghost2
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
        push g2rval
        push g2cval
        call CheckIfGhost
        ;checking pacman and ghost collisions
    jmp jump2
    timetopause:
    call clrscr
    call pausemenu
ret
level2 endp

gamesetup proc
    mov eax,yellow+(black*16)
    call SetTextColor
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
    mov dh,8
    call gotoxy
    mWrite "PLAYER: "
    mov dl,90
    mov dh,8
    call gotoxy
    mov edx,offset nameBuffer
    call writestring
ret
gamesetup endp

pausemenu proc
    mov esi,offset pause1
    mov ecx,5
    mov ebx,52
    mov dl,0
    mov dh,pauseYval
    call gotoxy
    drawPauseMessage:
        drawPauseMessage2:
            push ebx
            mov ebx,[esi]
            cmp bl,'#'
            je drawPLetter
            cmp bl,' '
            je drawPSpace
            drawPLetter:
                call drawHash2
                jmp drawPauseAgain
            drawPSpace:
                call drawSpace
            drawPauseAgain:
                inc esi
                pop ebx
                cmp ebx,0
                je drawPauseScreen1
                dec ebx
            jmp drawPauseMessage2
    drawPauseScreen1:
        mov eax,150
        call Delay
        add esi,1
        mov ebx,51
        mov dl,0
        inc pauseYval
        mov dh,pauseYval
        call gotoxy
    loop drawPauseMessage
        mov dl,20
        mov dh,10
        call gotoxy
        mov eax,white+(black*16)
        call SetTextColor
        mWrite "THE GHOSTS MAY DISPLACE YOUR COINS. THEY ARE NOT LOST SO BE ON THE LOOKOUT."
        mov dl,20
        mov dh,11
        call gotoxy
        mWrite "WATCH OUT FOR THE GHOSTS x-x"
        mov dl,30
        mov dh,12
        call gotoxy
        mWrite "PRESS B TO GO BACK."
        helpScreenLoop:
        mov eax,50
        call Delay
        call Readkey

        cmp al,'b'
        je timeToGoToTheGame


        jmp helpScreenLoop
    timeToGoToTheGame:
    mov pauseYval,4
    call clrscr
    cmp levelNum,1
    je exitPauseLevel1
    cmp levelNum,2
    je  exitPauseLevel2
   
ret
pausemenu endp

level3 proc
    mov levelNum,3
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
        cmp lives,0
        je gameover
        cmp score,700
        je jumpToLevel3
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
        cmp al,'p'
        je timetopause
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
        cmp bl,'['
        je teleporterFound
        cmp bl,']'
        je teleporterFound
        cmp bl,'.'
        jne ScoreInc
        inc score
        ScoreInc:
        cmp bl,'O'
        jne keepmoving
        add score,10
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
        cmp bl,'['
        je teleporterFound
        cmp bl,']'
        je teleporterFound
        cmp bl,'.'
        jne ScoreUp1
        inc score
        ScoreUp1:
        cmp bl,'O'
        jne keepmoving1
        add score,10
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
        jne ScoreUp2
        inc score
        ScoreUp2:
        cmp bl,'O'
        jne keepmoving2
        add score,10
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
       jne ScoreUp3
        inc score
        ScoreUp3:
        cmp bl,'O'
        jne keepmoving3
        add score,10
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
        jne ghost2
        mov eax,white+(black*16)
        call SetTextColor
        mov eax,'.'
        mov dl,rcoinY
        mov dh,rcoinX
        call gotoxy
        mov coinrestore,0
        call writechar
        ;check for ghost2
        ghost2:
        
        call getTracking
       
        call Ghost2movement
        ;check for ghost2
        cmp coinrestore,1
        jne ghost3
        mov eax,white+(black*16)
        call SetTextColor
        mov eax,'.'
        mov dl,rcoinY
        mov dh,rcoinX
        call gotoxy
        mov coinrestore,0
        call writechar

        ghost3:
        call getTracking3
        call Ghost3movement
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
        push g2rval
        push g2cval
        call CheckIfGhost
        push g3rval
        push g3cval
        call CheckIfGhost
        ;checking pacman and ghost collisions
    jmp jump2
    timetopause:
    call clrscr
    call pausemenu
    
    teleporterFound:
    ;compare where the teleporter was found at, shift the position and then go back to the main game loop.
    mov eax,yellow+(black*16)
    call SetTextColor
    mov eax,' '
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    cmp pacmanX,19
    jne TP2
    cmp pacmanY,10
    jne TP2
    call writechar
    mov eax,'P'
    mov pacmanX,51
    mov pacmanY,21
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    call writechar
    mov rval,17
    mov cval,46
    jmp endTeleport
    TP2:
    cmp pacmanX,15
    jne TP3
    cmp pacmanY,21
    jne TP3
    call writechar
    mov eax,'P'
    mov pacmanX,51
    mov pacmanY,11
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    call writechar
    mov rval,7
    mov cval,46
    jmp endTeleport
    TP3:
    cmp pacmanX,51
    jne TP4
    cmp pacmanY,11
    jne TP4
    call writechar
    mov eax,'P'
    mov pacmanX,15
    mov pacmanY,21
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    call writechar
    mov rval,17
    mov cval,10
    jmp endTeleport
    TP4:
    call writechar
    mov eax,'P'
    mov pacmanX,19
    mov pacmanY,10
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy
    call writechar
    mov rval,6
    mov cval,14

    endTeleport:
    jmp jump2

ret
level3 endp

getTracking3 proc
    cmp inBox3,1
    jne goNext
    cmp ghost3Y,11
    jne goNext
    mov inBox3,0
    goNext:
    cmp inBox3,1
    jne startTracking
    mov g3move,0
    mov lastMove3,0
    jmp endFunc
    startTracking:
    cmp firstExit3,0
    jne track
    
    mov g3move,1
    mov lastMove3,1
    jmp endFunc
    ;start comparing the values for movement now
    ;pacmanX and pacmanY
    track:
    ;comparisons for the positions where the ghost can escape from.
        cmp ghost3X,43
        jne checkP2
        cmp ghost3Y,21
        jne checkP2
        mov wallHit3,1
        jmp track1
        checkP2:
        cmp ghost3X,27
        jne checkP3
        cmp ghost3Y,21
        jne checkP3
        mov wallHit3,1
        jmp track1
        checkP3:
        cmp ghost3X,47
        jne checkP4
        cmp ghost3Y,16
        jne checkP4
        mov wallHit3,1
        jmp track1
        checkP4:
        cmp ghost3X,23
        jne checkP5
        cmp ghost3Y,16
        jne checkP5
        mov wallHit3,1
        checkP5:
        cmp ghost3X,43
        jne checkP6
        cmp ghost3Y,8
        jne checkP6
        mov wallHit3,1
        jmp track1
        checkP6:
        cmp ghost3X,27
        jne checkP7
        cmp ghost3Y,8
        jne checkP7
        mov wallHit3,1
        jmp track1
        checkP7:
        cmp ghost3X,51
        jne checkP8
        cmp ghost3Y,5
        jne checkP8
        mov wallHit3,1
        jmp track1
        checkP8:
        cmp ghost3X,19
        jne checkP9
        cmp ghost3Y,5
        jne checkP9
        mov wallHit3,1
        jmp track1
        checkP9: ;we will keep on adding more points.
    track1:
    cmp wallHit3,0
    je endFunc
    

    mov al,ghost3Y
    mov ah,ghost3X
    cmp lastMove3,0 ;the last done move was upwards
    jne Direction1
    cmp ah,pacmanX
    jg moveLEFT
    mov lastMove3,1
    mov g3move,1
    mov wallHit3,0
    jmp endFunc
    moveLEFT:
    mov lastMove3,3
    mov g3move,3
    mov wallHit3,0
    jmp endFunc
    Direction1:
    cmp lastMove3,1 ;the last done move was towards the right
    jne Direction2
         
    cmp al,pacmanY
    jg moveUP1
         mov ebx,62
         mov eax,g3rval
         inc eax
         mul ebx
         add eax,g3cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je moveUP1
    mov lastMove3,2
    mov g3move,2
    mov wallHit3,0
    jmp endFunc
    moveUP1:
         mov ebx,62
         mov eax,g3rval
         dec eax
         mul ebx
         add eax,g3cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         jne findIfLeft
    leftNotFound:
    mov lastMove3,0
    mov g3move,0
    mov wallHit3,0
    jmp endFunc
    findIfLeft:
        mov al,ghost3Y
        cmp al,pacmanY
        jg leftNotFound
         mov g3move,3
        mov lastMove3,3
        mov wallHit3,0
    jmp endFunc
    Direction2:
    cmp lastMove3,2 ;the last done move was done downwards
    jne Direction3
    cmp ah,pacmanX
    jl goRIGHT    
    mov g3move,3
    mov lastMove3,3
    mov wallHit3,0
    jmp endFunc
    goRIGHT:
    mov g3move,1
    mov lastMove3,1
    mov wallHit3,0
    jmp endFunc
    Direction3: ;the last move was done towards the left
    cmp al,pacmanY
    jg moveUP
        mov ebx,62
         mov eax,g3rval
         inc eax
         mul ebx
         add eax,g3cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je moveUP
    mov lastMove3,2
    mov g3move,2
    mov wallHit3,0
    jmp endFunc
    moveUP:
        mov ebx,62
         mov eax,g3rval
         dec eax
         mul ebx
         add eax,g3cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         jne findIfRight
    rightNotFound:
    mov lastMove3,0
    mov g3move,0
    mov wallHit3,0
    jmp endFunc
    findIfRight:
        ;seeing if going right would suffice or not.
        mov al,ghost3Y
        cmp al,pacmanY
        jg rightNotFound
        mov g3move,1
        mov lastMove3,1
        mov wallHit3,0
    endFunc:

ret
getTracking3 endp

ghost3movement proc
    mov eax,green+(black*16)
    call SetTextColor
    mov eax,50
    call Delay
    mov dl,ghost3X
    mov dh,ghost3Y
    call gotoxy
    
    cmp g3move,0
    je g3UP
    cmp g3move,1
    je g3Right
    cmp g3move,2
    je g3Down
    cmp g3move,3
    je g3Left
    g3UP:
         mov ebx,62
         mov eax,g3rval
         dec eax
         mul ebx
         add eax,g3cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         cmp bl,'.'
         jne notRestoreCoinUP
         mov coinrestore,1
         mov ecx,g3rval
         dec ecx
         add ecx,4
         mov edx,g3cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinUP:
         dec g3rval
          mov eax,' '
          call writechar
          dec ghost3Y
          mov dl,ghost3X
          mov dh,ghost3Y
          call gotoxy
          mov eax,'G'
          call writechar
    jmp endMove
    g3Right:
         mov ebx,62
         mov eax,g3rval
         mul ebx
         add eax,g3cval
         add eax,2
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         mov ebx,62
         mov eax,g3rval
         mul ebx
         add eax,g3cval
         add eax,1
         mov ebx,[esi+eax]
         cmp bl,'.'
         jne notRestoreCoinRight
         mov coinrestore,1
         mov ecx,g3rval
         add ecx,4
         mov edx,g3cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1

         notRestoreCoinRight:
         inc g3cval
          mov eax,' '
          call writechar
          inc ghost3X
          mov dl,ghost3X
          mov dh,ghost3Y
          call gotoxy
          mov eax,'G'
          call writechar
          
             
    jmp endMove
    g3Down:
         mov ebx,62
         mov eax,g3rval
         inc eax
         mul ebx
         add eax,g3cval
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         cmp bl,'.'
         jne notRestoreCoinDOWN
         mov coinrestore,1
         mov ecx,g3rval
         inc ecx
         add ecx,4
         mov edx,g3cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinDOWN:

         inc g3rval
         mov eax,' '
          call writechar
          inc ghost3Y
          mov dl,ghost3X
          mov dh,ghost3Y
          call gotoxy
          mov eax,'G'
          call writechar
    jmp endMove
    g3Left:
         mov ebx,62
         mov eax,g3rval
         mul ebx
         add eax,g3cval
         sub eax,2
         mov ebx,[esi+eax]
         cmp bl,'#'
         je endMove
         mov ebx,62
         mov eax,g3rval
         mul ebx
         add eax,g3cval
         add eax,1
         mov ebx,[esi+eax]
         cmp bl,'.'
         jne notRestoreCoinLeft
         mov coinrestore,1
         mov ecx,g3rval
         add ecx,4
         mov edx,g3cval
         add edx,5
         mov rcoinX,cl
         mov rcoinY,dl
         mov coinrestore,1
         notRestoreCoinLeft:
         dec g3cval
          mov eax,' '
          call writechar
          dec ghost3X
          mov dl,ghost3X
          mov dh,ghost3Y
          call gotoxy
          mov eax,'G'
          call writechar
    endMove:
        cmp bl,'#'
        je checkg1move1
        jmp endg1
        checkg1move1:
            mov wallhit3,1
            mov firstExit3,1
       resetg1move:
       mov g3move,7
    endg1:
ret
ghost3movement endp

gameoverscreen proc
    mov ecx,5
    mov ebx,51
    mov dl,0
    mov dh,gameYval
    mov esi,offset game
    call gotoxy
    drawGameMessage:
        drawGameMessage2:
            push ebx
            mov ebx,[esi]
            cmp bl,'#'
            je drawPLetter
            cmp bl,' '
            je drawPSpace
            drawPLetter:
                call drawHash2
                jmp drawGameAgain
            drawPSpace:
                call drawSpace
            drawGameAgain:
                inc esi
                pop ebx
                cmp ebx,0
                je drawGameScreen1
                dec ebx
            jmp drawGameMessage2
    drawGameScreen1:
        mov eax,150
        call Delay
        add esi,1
        mov ebx,50
        mov dl,0
        inc gameYval
        mov dh,gameYval
        call gotoxy
    loop drawGameMessage
    
    mov esi,offset over1
    mov ecx,5
    mov ebx,51
    mov dl,0
    mov dh,overYval
    call gotoxy
    drawOverMessage:
        drawOverMessage2:
            push ebx
            mov ebx,[esi]
            cmp bl,'#'
            je drawOLetter
            cmp bl,' '
            je drawOSpace
            drawOLetter:
                call drawHash2
                jmp drawOverAgain
            drawOSpace:
                call drawSpace
            drawOverAgain:
                inc esi
                pop ebx
                cmp ebx,0
                je drawOverScreen1
                dec ebx
            jmp drawOverMessage2
    drawOverScreen1:
        mov eax,150
        call Delay
        add esi,1
        mov ebx,50
        mov dl,0
        inc overYval
        mov dh,overYval
        call gotoxy
    loop drawOverMessage
    
    call gamesetup
    mov eax,white+(black*16)
    call SetTextColor
    mov dl,45
    mov dh,17
    call gotoxy
    mWrite "PRESS E TO EXIT - >"
        gameoverloop:
        mov eax,50
        call Delay
        call Readkey

        cmp al,'e'
        je ShutDown
    jmp gameoverloop


ret
gameoverscreen endp
end main
