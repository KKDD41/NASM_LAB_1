                    global Sum
                    global CheckOverflow
                    global ComputeFn
                    global Clock
                    global Polynom

                    section .text

Sum:                ; Data location:
                    ;           ( x,  y ) --> result
                    ; Unix/WSL: (EDI, SIL) --> RAX
                    ; Windows:  (ECX, DIL) --> RAX
                    ;
                    ; but why 'dil' instead of 'dl'?...
                    ;
                    mov rax, 0
                    movzx rax, dl
                    movsx rcx, ecx
                    add rax, rcx
                    ret

CheckOverflow:      mov rax, 0
                    mov r10, 0
                    mov r11, 8
                    add r10, rcx
                    add r10, rdx
                    seto al
                    ;
                    ; x + y now in r10.
                    ; Result of the overflow lies in al.
                    ; We will count x^4 and check the overflow flag
                    ; on each step.
                    ;
                    imul rcx, rcx
                    seto ah
                    or al, ah
                    mov ah, 0
                    imul rcx, rcx
                    seto ah
                    or al, ah
                    mov ah, 0
                    ;
                    add r11, rcx
                    seto ah
                    or al, ah
                    mov ah, 0
                    ;
                    ; Count y^2 in rdx.
                    ;
                    imul rdx, rdx
                    seto ah
                    or al, ah
                    mov ah, 0
                    ;
                    sub r11, rdx
                    seto ah
                    or al, ah
                    mov ah, 0
                    ;
                    ; vopros na million : ono poschitaet (x + y)^2?
                    ; Nu raz est' skobochki, to poschitaet...
                    ;
                    imul r10, r10
                    seto ah
                    or al, ah
                    mov ah, 0
                    ret
        
ComputeFn:          mov rax, 2
                    mov r10, rcx
                    imul r10, rcx
                    add rax, r10
                    mov r10, rdx
                    imul r10, r10
                    imul r10, rdx
                    sub rax, r10
                    ;
                    ; rax -> 2 + x^2 - y^3
                    ;
                    mov r10, rdx
                    imul r10, rdx
                    add r10, 2
                    imul rax, r10
                    imul rax, r10
                    ;
                    ; rax -> (2 + x^2 - y^3)(y^2 + 2)^2
                    ;
                    mov r10, rcx
                    imul rdx, rdx
                    sub r10, rdx
                    cqo
                    idiv r10
                    ret
        
Clock:              mov rax, 0
                    movsx r10, r8d
                    imul r10, 2
                    movsx rcx, ecx ; h
                    movsx rdx, edx ; m
                    ;
                    ; ((2 * f - (60 * h + m) * 11 + 8640) % 720 * 120 / 22
                    ;
                    imul rcx, 60
                    add rdx, rcx
                    imul rdx, 11
                    sub rax, rdx
                    add rax, r10
                    add rax, 8640
                    ;
                    ; Get a reminder (2f - 11 * (60h + m) + 8640) % 720 in rax
                    ;
                    mov rdx, rax
                    mov r10, 720
                    cqo
                    idiv r10
                    imul rax, 720
                    mov rax, rdx
                    ;
                    ; Final operations
                    ;
                    imul rax, 120
                    mov r10, 22
                    cqo
                    idiv r10
                    ret
        
Polynom:            movsx rax, ecx
                    mov rcx, rax
                    imul rax, rax, 2
                    sub rax, 3
                    imul rax, rcx
                    add rax, 4
                    imul rax, rcx
                    sub rax, 5
                    imul rax, rcx
                    add rax, 6
                    ret