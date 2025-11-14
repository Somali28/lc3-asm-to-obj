.ORIG x3000

; Load numbers
LD R0, NUM1       ; R0 = NUM1
LD R1, NUM2       ; R1 = NUM2

; Add numbers
ADD R2, R0, R1    ; R2 = NUM1 + NUM2

; Convert to ASCII
LD R3, ASCII_ZERO
ADD R2, R2, R3

; Print result
ADD R0, R2, #0    ; move to R0 for OUT
OUT

HALT

;---------------------------
; Data
;---------------------------
NUM1        .FILL #0005
NUM2        .FILL #0003
ASCII_ZERO  .FILL #0048   ; ASCII '0'

.END
