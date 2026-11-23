
; Sample Code for Lab 6
; This sample code implements the int main() function

.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int main()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Main's return value
LD R6, STACK_BASE		; R6 = x6000

; Main's return address
ADD R6, R6, #-1			; R6 = x5FFF
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1			; R6 = x5FFE
STR R5, R6, #0

; Set frame pointer
ADD R5, R6, #0			; R5 = R6 = x5FFE

; node_t *head
ADD R6, R6, #-1			; R6 = x5FFD
AND R0, R0, #0			; R0 = 0
STR R0, R6, #0

; char selection
ADD R6, R6, #-1			; R6 = x5FFC
LD R0, START_CHAR
STR R0, R6, #0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while(selection != 'q')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Perform the check for the while loop
; We check to see if char selection is equal to 'q'
; If equal, quit
; It not equal, continue running the loop
CHECK_WHILE
LDR R0, R5, #-2			; R0 = char selection
LD R1, LOWERCASE_Q
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRz BREAK_WHILE_LOOP

; Print the options menu
LEA R0, PROMPT_MENU
PUTS

; Get a character from the keyboard and put it in selection
; (We don't have to write our own scanf() function)
READ_SELECTION
GETC

; Skip newline characters
LD R1, NEWLINE
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRz READ_SELECTION

LD R1, CARRIAGE
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRz READ_SELECTION

STR R0, R5, #-2			; Store the character on the runtime stack in char selection (R0 = char selection)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if(selection == 'p')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'p'
LD R1, LOWERCASE_P
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_A			; If not equal to 'p' check 'a'

; Display prompt
LEA R0, PROMPT_PRINT
PUTS

; node_t **head (&head) (input to printList())
ADD R6, R6, #-1			; R6 = x5FFB
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

JSR PRINT_LIST

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if(selection == 'a')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'a'
ELSE_IF_A
LDR R0, R5, #-2
LD R1, LOWERCASE_A
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_R

; int a
ADD R6, R6, #-1			; R6 = x5FFB
AND R0, R0, #0
STR R0, R6, #0

; Display prompt
LEA R0, PROMPT_ADD
PUTS

; Call TRAP service routine for getting number here
TRAP x40

; Store number entered into int a
STR R0, R5, #-3

; node_t **head (&head) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int added (a) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

JSR ADD_VALUE

; Pop int added
ADD R6, R6, #1			; R6 = x5FFA

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

; Pop int a
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if(selection == 'r')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'r'
ELSE_IF_R
LDR R0, R5, #-2
LD R1, LOWERCASE_R
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp CONTINUE_WHILE_LOOP

; int r
ADD R6, R6, #-1			; R6 = x5FFB
AND R0, R0, #0
STR R0, R6, #0

; Display prompt
LEA R0, PROMPT_REMOVE
PUTS

; Call TRAP service routine for getting number here
TRAP x40

; Store number entered into int r
STR R0, R5, #-3

; node_t **head (&head) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int removed (r) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

JSR REMOVE_VALUE

; Pop int removed
ADD R6, R6, #1			; R6 = x5FFA

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

; Pop int r
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

; Loop back to check the while loop condition again
CONTINUE_WHILE_LOOP
BRnzp CHECK_WHILE

BREAK_WHILE_LOOP

; Pop local variables in main
ADD R6, R6, #2			; R6 = x5FFE

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1			; R6 = x5FFF

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1			; R6 = x6000

HALT

STACK_BASE .FILL x6000
START_CHAR .FILL x0073

LOWERCASE_A .FILL x0061
LOWERCASE_P .FILL x0070
LOWERCASE_Q .FILL x0071
LOWERCASE_R .FILL x0072

NEWLINE .FILL x000A
CARRIAGE .FILL x000D

PROMPT_MENU .STRINGZ "Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT .STRINGZ "\nContents of the linked list: \n"
PROMPT_ADD .STRINGZ "\nType a number to add: \n"
PROMPT_REMOVE .STRINGZ "\nType a number to remove: \n"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void printList(node_t **head)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINT_LIST

; Save return address and frame pointer
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

; Local variable current
ADD R6, R6, #-1

; Get head
LDR R1, R5, #2
LDR R1, R1, #0
STR R1, R5, #-1

; Print each node
PRINT_LOOP
LDR R1, R5, #-1
BRz PRINT_DONE

LDR R0, R1, #0
TRAP x41

; Move to next node
LDR R1, R5, #-1
LDR R1, R1, #1
STR R1, R5, #-1
BRz PRINT_LOOP

LEA R0, ARROW
PUTS
BRnzp PRINT_LOOP

PRINT_DONE
LEA R0, LINE_END
PUTS

; Pop local variable
ADD R6, R6, #1

; Restore frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Restore return address
LDR R7, R6, #0
ADD R6, R6, #1

RET

ARROW .STRINGZ " -> "
LINE_END .STRINGZ "\n"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void addValue(node_t **head, int added)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADD_VALUE

; Save return address and frame pointer
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

; Get head
LDR R1, R5, #3
LDR R2, R1, #0

; Create new node
LD R3, NEXT_FREE
LDR R4, R5, #2
STR R4, R3, #0

AND R4, R4, #0
STR R4, R3, #1

ADD R4, R3, #2
ST R4, NEXT_FREE

; Check if list is empty
ADD R2, R2, #0
BRz SET_HEAD

; Find the last node
ADD_LOOP
LDR R4, R2, #1
BRz LINK_NEW

ADD R2, R4, #0
BRnzp ADD_LOOP

; Add node to end of list
LINK_NEW
STR R3, R2, #1
BRnzp ADD_DONE

; Set new head
SET_HEAD
STR R3, R1, #0

ADD_DONE

; Restore frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Restore return address
LDR R7, R6, #0
ADD R6, R6, #1

RET

NEXT_FREE .FILL x7000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void removeValue(node_t **head, int removed)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

REMOVE_VALUE

; Save return address and frame pointer
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

; Get head
LDR R1, R5, #3
LDR R2, R1, #0

; Check if list is empty
BRz REMOVE_DONE

; Get value to remove
LDR R3, R5, #2
NOT R0, R3
ADD R0, R0, #1

; Check first node
LDR R4, R2, #0
ADD R4, R4, R0
BRz REMOVE_HEAD

; Previous node
ADD R1, R2, #0

; Current node
LDR R2, R2, #1

; Find the value
REMOVE_LOOP
ADD R2, R2, #0
BRz REMOVE_DONE

LDR R4, R2, #0
ADD R4, R4, R0
BRz REMOVE_FOUND

; Move to next node
ADD R1, R2, #0
LDR R2, R2, #1
BRnzp REMOVE_LOOP

; Remove first node
REMOVE_HEAD
LDR R4, R2, #1
STR R4, R1, #0
BRnzp REMOVE_DONE

; Remove matching node
REMOVE_FOUND
LDR R4, R2, #1
STR R4, R1, #1

REMOVE_DONE

; Restore frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Restore return address
LDR R7, R6, #0
ADD R6, R6, #1

RET

.END
