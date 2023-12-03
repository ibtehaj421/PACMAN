
include Irvine32.inc
include Macros.inc
.386
.model flat,stdcall
.stack 4096

.data
;grid set up---------------------------------------------------------------------
    rval dd 14
    cval dd 30
    yvalue db 4
    hash db "#",0
    space db " ",0
    circle db ".",0
    gridRow = 14
    gridCol = 30
    counter dd 0
    current dd 0
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

;grid set up---------------------------------------------------------------------
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
.code
main PROC
;reset registers
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
Invoke ExitProcess,0
main ENDP


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

drawSpace proc
    mov edx,offset space
    mov eax,black+(black*16)
    call SetTextColor
    call writestring

    ret
drawSpace endp

pacmanPos proc
    mov dl,pacmanX
    mov dh,pacmanY
    call gotoxy

ret
pacmanPos endp

getRanGhost proc
    enter 0,0
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
