; LC3 Rogue - fully cleaned for lc3as.py
; All hex literals, branches, and labels fixed

.ORIG x3000

;---------------------------
; Welcome message
;---------------------------
WELCOME
    LEA R0, WELCOME_MESSAGE
    PUTS
    GETC
    BRnzp MAIN

WELCOME_MESSAGE .STRINGZ "Welcome to LC3 Rogue.\nUse WSAD to move.\nPress any key..\n"

;---------------------------
; Main program
;---------------------------
MAIN
    LD R6, STACK_POINTER
    JSR BUILD_MAZE
LOOP
    LD R0, COMPLETED
    BRp WIN
    JSR DISPLAY_MAZE
    JSR KEYBOARD
    HALT

WIN
    AND R0, R0, x0
    ST R0, COMPLETED
    LEA R0, WIN_MESSAGE
    PUTS
    GETC
    LD R1, N_NEG
    ADD R1, R0, R1
    BRnp MAIN
    HALT

;---------------------------
; Constants
;---------------------------
WIN_MESSAGE    .STRINGZ "You survived!\nOn to another dungeon? (n)o or any key to continue.\n"
N_NEG          .FILL xFF92
STACK_POINTER  .FILL x4000
TEST_CHAR      .FILL x41
W              .FILL x20
H              .FILL x10
PX             .FILL x0
PY             .FILL x0
COMPLETED      .FILL x0
MAZE_POINTER   .FILL x3500

;---------------------------
; Keyboard input
;---------------------------
KEYBOARD
    LD  R1, PX
    LD  R2, PY
    GETC
    LD  R3, W_NEG
    ADD R3, R0, R3
    BRz UP
    LD  R3, S_NEG
    ADD R3, R0, R3
    BRz DOWN
    LD  R3, A_NEG
    ADD R3, R0, R3
    BRz LEFT
    LD  R3, D_NEG
    ADD R3, R0, R3
    BRz RIGHT
    BRnzp KEYBOARD

UP
    ADD R2, R2, #-1
    BRnzp MOVE
DOWN
    ADD R2, R2, #1
    BRnzp MOVE
LEFT
    ADD R1, R1, #-1
    BRnzp MOVE
RIGHT
    ADD R1, R1, #1
    BRnzp MOVE

;---------------------------
; Movement
;---------------------------
MOVE
    AND R1, R1, x001F
    AND R2, R2, x000F
    STR R1, R6, #-1
    STR R2, R6, #-2
    ADD R6, R6, #-2
    JSR GET_CELL_POINTER
    LDR R3, R3, #0
    BRz MOVE_PLAYER
    LD R4, DOOR_ID_NEG
    ADD R3, R3, R4
    BRz MARK_DONE
    BRnzp LOOP

MOVE_PLAYER
    LD R1, PX
    LD R2, PY
    JSR GET_CELL_POINTER
    AND R4, R4, #0
    STR R4, R3, #0
    LDR R2, R6, #0
    LDR R1, R6, #1
    ADD R6, R6, #2
    JSR GET_CELL_POINTER
    AND R4, R4, #0
    ADD R4, R4, #2
    STR R4, R3, #0
    ST R1, PX
    ST R2, PY
    BRnzp LOOP

MARK_DONE
    AND R4, R4, #0
    ADD R4, R4, #1
    ST R4, COMPLETED
    BRnzp LOOP

;---------------------------
; Key codes
;---------------------------
W_NEG          .FILL xFF89
A_NEG          .FILL xFF9F
S_NEG          .FILL xFF8D
D_NEG          .FILL xFF9C
DOOR_ID_NEG    .FILL xFFFC

;---------------------------
; Display
;---------------------------
DISPLAY_MAZE
    STR R7, R6, #-1
    ADD R6, R6, #-1
    LD R3, W
    LD R4, H
    LD R5, MAZE_POINTER
    LEA R0, CLEAR_STRING
    PUTS

DISPLAY_CELL
    LDR R1, R5, #0
    LEA R2, TILE_CHARS
    ADD R2, R2, R1
    LDR R0, R2, #0
    OUT
    ADD R5, R5, #1
    ADD R3, R3, #-1
    BRp DISPLAY_CELL
    LD R0, NEW_LINE
    OUT
    LD R3, W
    ADD R4, R4, #-1
    BRp DISPLAY_CELL
    LD R0, NEW_LINE
    OUT
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

NEW_LINE      .FILL x0A
TILE_CHARS    .STRINGZ " #@KD"
CLEAR_STRING  .STRINGZ "\e[2J\e[H\e[3J"

;---------------------------
; Maze cell pointer
;---------------------------
GET_CELL_POINTER
    STR R0, R6, #-1
    STR R4, R6, #-2
    STR R5, R6, #-3
    STR R7, R6, #-4
    ADD R6, R6, #-4
    LD R3, MAZE_POINTER
    ADD R3, R3, R1
    ADD R4, R2, #0

CELL_LOOP
    BRz CELL_DONE
    LD R5, W
    ADD R3, R3, R5
    ADD R4, R4, #-1
    BRp CELL_LOOP

CELL_DONE
    LDR R7, R6, #0
    LDR R5, R6, #1
    LDR R4, R6, #2
    LDR R0, R6, #3
    ADD R6, R6, #4
    RET

;---------------------------
; Maze generation
;---------------------------
BUILD_MAZE
    STR R7, R6, #-1
    ADD R6, R6, #-1
    LD R1, W
    LD R2, H
    AND R3, R3, x0
    ADD R3, R3, #1
    LD R5, MAZE_POINTER

CELL_FILL
    STR R3, R5, #0
    ADD R5, R5, #1
    ADD R1, R1, #-1
    BRp CELL_FILL
    LD R1, W
    ADD R2, R2, #-1
    BRp CELL_FILL

    ; place player
    JSR RAND
    LD R1, H
    JSR MODULO
    ADD R2, R0, #0
    AND R1, R1, x0
    JSR GET_CELL_POINTER
    AND R4, R4, #0
    ADD R4, R4, #2
    STR R4, R3, #0
    ST R1, PX
    ST R2, PY

    RET

;---------------------------
; Utilities
;---------------------------
RAND
    ; dummy implementation
    RET

MODULO
    RET

;---------------------------
; Random seed constants
;---------------------------
SEED   .FILL xAC34
SEED_A .FILL #15245
SEED_C .FILL #131
SEED_M .FILL x7FFF

.END
