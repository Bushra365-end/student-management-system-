
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt




   org 100h

jmp start


; =========================
; DATA
; =========================

students db 400 dup(0)
courses  db 370 dup(0)

nameBuf   db 20,0,20 dup(0)
idBuf     db 10,0,10 dup(0)
cgpaBuf   db 7,0,7 dup(0)
creditBuf db 4,0,4 dup(0)

newLine db 13,10,'$'
invalid db 13,10,'Invalid choice!',13,10,'$'
notFound db 13,10,'Record not found!',13,10,'$'

mainMsg db 13,10
db '===== STUDENT MANAGEMENT SYSTEM =====',13,10
db '1. Student Panel',13,10
db '2. Course Panel',13,10
db '3. Exit',13,10
db 'Enter choice: $'

studentMsg db 13,10
db '========== STUDENT PANEL ==========',13,10
db '1. Add Student',13,10
db '2. Display Students',13,10
db '3. Update Student',13,10
db '4. Delete Student',13,10
db '5. Search Student',13,10
db '6. Back',13,10
db 'Enter choice: $'

courseMsg db 13,10
db '=========== COURSE PANEL ===========',13,10
db '1. Add Course',13,10
db '2. Display Courses',13,10
db '3. Update Course',13,10
db '4. Delete Course',13,10
db '5. Search Course',13,10
db '6. Back',13,10
db 'Enter choice: $'

nameMsg db 13,10,'Enter Name: $'
idMsg db 13,10,'Enter ID: $'
cgpaMsg db 13,10,'Enter CGPA: $'

courseNameMsg db 13,10,'Enter Course Name: $'
codeMsg db 13,10,'Enter Course Code: $'
creditMsg db 13,10,'Enter Credit: $'

infoMsg db 13,10,'--- Information ---',13,10,'$'

nameLabel db 'Name: $'
idLabel db 'ID: $'
cgpaLabel db 'CGPA: $'

courseNameLabel db 'Course Name: $'
codeLabel db 'Course Code: $'
creditLabel db 'Credit: $'


; =========================
; START
; =========================

start:

mov ax,cs
mov ds,ax


; =========================
; MAIN MENU
; =========================

main:

mov dx,offset mainMsg
mov ah,09h
int 21h

mov ah,01h
int 21h
mov bl,al

mov dx,offset newLine
mov ah,09h
int 21h

cmp bl,'1'
je studentPanel

cmp bl,'2'
je coursePanel

cmp bl,'3'
je exit

mov dx,offset invalid
mov ah,09h
int 21h

jmp main


; =========================
; STUDENT PANEL
; =========================

studentPanel:

studentMenu:

mov dx,offset studentMsg
mov ah,09h
int 21h

mov ah,01h
int 21h
mov bl,al

mov dx,offset newLine
mov ah,09h
int 21h

cmp bl,'1'
je addStudent

cmp bl,'2'
je displayStudent

cmp bl,'3'
je updateStudent

cmp bl,'4'
je deleteStudent

cmp bl,'5'
je searchStudent

cmp bl,'6'
je main

mov dx,offset invalid
mov ah,09h
int 21h

jmp studentMenu


; =========================
; ADD STUDENT
; =========================

addStudent:

; Find empty record

mov si,offset students
mov cx,10

findStudentSpace:

cmp byte ptr [si],0
je studentSpaceFound

add si,40
loop findStudentSpace

jmp studentMenu


studentSpaceFound:

; Name

mov dx,offset nameMsg
mov ah,09h
int 21h

mov dx,offset nameBuf
mov ah,0Ah
int 21h

mov di,si
mov bx,offset nameBuf
add bx,2

xor cx,cx
mov cl,[nameBuf+1]

copyStudentName:

cmp cx,0
je studentNameDone

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp copyStudentName

studentNameDone:

mov byte ptr [di],0


; ID

mov dx,offset idMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

copyStudentID:

cmp cx,0
je studentIDDone

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp copyStudentID

studentIDDone:

mov byte ptr [di],0


; CGPA

mov dx,offset cgpaMsg
mov ah,09h
int 21h

mov dx,offset cgpaBuf
mov ah,0Ah
int 21h

mov di,si
add di,32

mov bx,offset cgpaBuf
add bx,2

xor cx,cx
mov cl,[cgpaBuf+1]

copyCGPA:

cmp cx,0
je studentAdded

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp copyCGPA


studentAdded:

mov byte ptr [di],0

jmp studentMenu


; =========================
; DISPLAY STUDENT
; =========================

displayStudent:

mov si,offset students
mov cx,10

displayStudentLoop:

cmp byte ptr [si],0
je nextDisplayStudent

mov dx,offset infoMsg
mov ah,09h
int 21h


; Name

mov dx,offset nameLabel
mov ah,09h
int 21h

mov di,si

printSName:

mov dl,[di]
cmp dl,0
je printSIDStart

mov ah,02h
int 21h

inc di
jmp printSName


; ID

printSIDStart:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset idLabel
mov ah,09h
int 21h

mov di,si
add di,21

printSID:

mov dl,[di]
cmp dl,0
je printSCGPAStart

mov ah,02h
int 21h

inc di
jmp printSID


; CGPA

printSCGPAStart:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset cgpaLabel
mov ah,09h
int 21h

mov di,si
add di,32

printSCGPA:

mov dl,[di]
cmp dl,0
je nextDisplayStudent

mov ah,02h
int 21h

inc di
jmp printSCGPA


nextDisplayStudent:

add si,40
loop displayStudentLoop

jmp studentMenu


; =========================
; SEARCH STUDENT BY ID
; =========================

searchStudent:

mov dx,offset idMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov si,offset students
mov bp,10

searchStudentLoop:

cmp bp,0
je studentNotFound

cmp byte ptr [si],0
je nextSearchStudent

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

compareStudentID:

cmp cx,0
je studentFound

mov al,[di]
cmp al,[bx]
jne nextSearchStudent

inc di
inc bx
dec cx

jmp compareStudentID


nextSearchStudent:

add si,40
dec bp
jmp searchStudentLoop


studentFound:

mov dx,offset infoMsg
mov ah,09h
int 21h

; Name

mov dx,offset nameLabel
mov ah,09h
int 21h

mov di,si

showSearchName:

mov dl,[di]
cmp dl,0
je showSearchID

mov ah,02h
int 21h

inc di
jmp showSearchName


showSearchID:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset idLabel
mov ah,09h
int 21h

mov di,si
add di,21

showSearchID2:

mov dl,[di]
cmp dl,0
je showSearchCGPA

mov ah,02h
int 21h

inc di
jmp showSearchID2


showSearchCGPA:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset cgpaLabel
mov ah,09h
int 21h

mov di,si
add di,32

showSearchCGPA2:

mov dl,[di]
cmp dl,0
je studentMenu

mov ah,02h
int 21h

inc di
jmp showSearchCGPA2


studentNotFound:

mov dx,offset notFound
mov ah,09h
int 21h

jmp studentMenu


; =========================
; UPDATE STUDENT BY ID
; =========================

updateStudent:

mov dx,offset idMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov si,offset students
mov bp,10

updateStudentLoop:

cmp bp,0
je studentNotFound

cmp byte ptr [si],0
je updateNext

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

updateCompare:

cmp cx,0
je updateFound

mov al,[di]
cmp al,[bx]
jne updateNext

inc di
inc bx
dec cx

jmp updateCompare


updateNext:

add si,40
dec bp
jmp updateStudentLoop


updateFound:

; New Name

mov dx,offset nameMsg
mov ah,09h
int 21h

mov dx,offset nameBuf
mov ah,0Ah
int 21h

mov di,si
mov bx,offset nameBuf
add bx,2

xor cx,cx
mov cl,[nameBuf+1]

updateName:

cmp cx,0
je updateIDInput

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp updateName


; New ID

updateIDInput:

mov dx,offset idMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

updateID:

cmp cx,0
je updateCGPAInput

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp updateID


; New CGPA

updateCGPAInput:

mov dx,offset cgpaMsg
mov ah,09h
int 21h

mov dx,offset cgpaBuf
mov ah,0Ah
int 21h

mov di,si
add di,32

mov bx,offset cgpaBuf
add bx,2

xor cx,cx
mov cl,[cgpaBuf+1]

updateCGPA:

cmp cx,0
je studentMenu

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp updateCGPA


; =========================
; DELETE STUDENT BY ID
; =========================

deleteStudent:

mov dx,offset idMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov si,offset students
mov bp,10

deleteStudentLoop:

cmp bp,0
je studentNotFound

cmp byte ptr [si],0
je deleteNext

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

deleteCompare:

cmp cx,0
je deleteFound

mov al,[di]
cmp al,[bx]
jne deleteNext

inc di
inc bx
dec cx

jmp deleteCompare


deleteNext:

add si,40
dec bp
jmp deleteStudentLoop


deleteFound:

mov di,si
mov cx,40

clearStudent:

mov byte ptr [di],0
inc di
loop clearStudent

jmp studentMenu


; =====================================================
; COURSE PANEL
; =====================================================

coursePanel:

courseMenu:

mov dx,offset courseMsg
mov ah,09h
int 21h

mov ah,01h
int 21h
mov bl,al

mov dx,offset newLine
mov ah,09h
int 21h

cmp bl,'1'
je addCourse

cmp bl,'2'
je displayCourse

cmp bl,'3'
je updateCourse

cmp bl,'4'
je deleteCourse

cmp bl,'5'
je searchCourse

cmp bl,'6'
je main

mov dx,offset invalid
mov ah,09h
int 21h

jmp courseMenu


; =========================
; ADD COURSE
; =========================

addCourse:

mov si,offset courses
mov cx,10

findCourseSpace:

cmp byte ptr [si],0
je courseSpaceFound

add si,37
loop findCourseSpace

jmp courseMenu


courseSpaceFound:

; Course Name

mov dx,offset courseNameMsg
mov ah,09h
int 21h

mov dx,offset nameBuf
mov ah,0Ah
int 21h

mov di,si
mov bx,offset nameBuf
add bx,2

xor cx,cx
mov cl,[nameBuf+1]

copyCourseName:

cmp cx,0
je courseCodeInput

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp copyCourseName


; Course Code

courseCodeInput:

mov dx,offset codeMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

copyCourseCode:

cmp cx,0
je courseCreditInput

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp copyCourseCode


; Credit

courseCreditInput:

mov dx,offset creditMsg
mov ah,09h
int 21h

mov dx,offset creditBuf
mov ah,0Ah
int 21h

mov di,si
add di,32

mov bx,offset creditBuf
add bx,2

xor cx,cx
mov cl,[creditBuf+1]

copyCredit:

cmp cx,0
je courseMenu

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp copyCredit


; =========================
; DISPLAY COURSE
; =========================

displayCourse:

mov si,offset courses
mov cx,10

displayCourseLoop:

cmp byte ptr [si],0
je nextDisplayCourse

mov dx,offset infoMsg
mov ah,09h
int 21h


; Course Name

mov dx,offset courseNameLabel
mov ah,09h
int 21h

mov di,si

printCourseName:

mov dl,[di]
cmp dl,0
je printCourseCodeStart

mov ah,02h
int 21h

inc di
jmp printCourseName


; Course Code

printCourseCodeStart:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset codeLabel
mov ah,09h
int 21h

mov di,si
add di,21

printCourseCode:

mov dl,[di]
cmp dl,0
je printCreditStart

mov ah,02h
int 21h

inc di
jmp printCourseCode


; Credit

printCreditStart:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset creditLabel
mov ah,09h
int 21h

mov di,si
add di,32

printCredit:

mov dl,[di]
cmp dl,0
je nextDisplayCourse

mov ah,02h
int 21h

inc di
jmp printCredit


nextDisplayCourse:

add si,37
loop displayCourseLoop

jmp courseMenu


; =========================
; SEARCH COURSE BY CODE
; =========================

searchCourse:

mov dx,offset codeMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov si,offset courses
mov bp,10

searchCourseLoop:

cmp bp,0
je courseNotFound

cmp byte ptr [si],0
je nextSearchCourse

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

compareCourseCode:

cmp cx,0
je courseFound

mov al,[di]
cmp al,[bx]
jne nextSearchCourse

inc di
inc bx
dec cx

jmp compareCourseCode


nextSearchCourse:

add si,37
dec bp
jmp searchCourseLoop


courseFound:

mov dx,offset infoMsg
mov ah,09h
int 21h

mov dx,offset courseNameLabel
mov ah,09h
int 21h

mov di,si

showCourseName:

mov dl,[di]
cmp dl,0
je showCourseCode

mov ah,02h
int 21h

inc di
jmp showCourseName


showCourseCode:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset codeLabel
mov ah,09h
int 21h

mov di,si
add di,21

showCourseCode2:

mov dl,[di]
cmp dl,0
je showCourseCredit

mov ah,02h
int 21h

inc di
jmp showCourseCode2


showCourseCredit:

mov dx,offset newLine
mov ah,09h
int 21h

mov dx,offset creditLabel
mov ah,09h
int 21h

mov di,si
add di,32

showCourseCredit2:

mov dl,[di]
cmp dl,0
je courseMenu

mov ah,02h
int 21h

inc di
jmp showCourseCredit2


courseNotFound:

mov dx,offset notFound
mov ah,09h
int 21h

jmp courseMenu


; =========================
; UPDATE COURSE BY CODE
; =========================

updateCourse:

mov dx,offset codeMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov si,offset courses
mov bp,10

updateCourseLoop:

cmp bp,0
je courseNotFound

cmp byte ptr [si],0
je updateCourseNext

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

updateCourseCompare:

cmp cx,0
je updateCourseFound

mov al,[di]
cmp al,[bx]
jne updateCourseNext

inc di
inc bx
dec cx

jmp updateCourseCompare


updateCourseNext:

add si,37
dec bp
jmp updateCourseLoop


updateCourseFound:

; New Name

mov dx,offset courseNameMsg
mov ah,09h
int 21h

mov dx,offset nameBuf
mov ah,0Ah
int 21h

mov di,si
mov bx,offset nameBuf
add bx,2

xor cx,cx
mov cl,[nameBuf+1]

newCourseName:

cmp cx,0
je newCourseCodeInput

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp newCourseName


; New Code

newCourseCodeInput:

mov dx,offset codeMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

newCourseCode:

cmp cx,0
je newCourseCreditInput

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp newCourseCode


; New Credit

newCourseCreditInput:

mov dx,offset creditMsg
mov ah,09h
int 21h

mov dx,offset creditBuf
mov ah,0Ah
int 21h

mov di,si
add di,32

mov bx,offset creditBuf
add bx,2

xor cx,cx
mov cl,[creditBuf+1]

newCourseCredit:

cmp cx,0
je courseMenu

mov al,[bx]
mov [di],al

inc bx
inc di
dec cx

jmp newCourseCredit


; =========================
; DELETE COURSE BY CODE
; =========================

deleteCourse:

mov dx,offset codeMsg
mov ah,09h
int 21h

mov dx,offset idBuf
mov ah,0Ah
int 21h

mov si,offset courses
mov bp,10

deleteCourseLoop:

cmp bp,0
je courseNotFound

cmp byte ptr [si],0
je deleteCourseNext

mov di,si
add di,21

mov bx,offset idBuf
add bx,2

xor cx,cx
mov cl,[idBuf+1]

deleteCourseCompare:

cmp cx,0
je deleteCourseFound

mov al,[di]
cmp al,[bx]
jne deleteCourseNext

inc di
inc bx
dec cx

jmp deleteCourseCompare


deleteCourseNext:

add si,37
dec bp
jmp deleteCourseLoop


deleteCourseFound:

mov di,si
mov cx,37

clearCourse:

mov byte ptr [di],0
inc di
loop clearCourse

jmp courseMenu


; =========================
; EXIT
; =========================

exit:

mov ah,4Ch
mov al,0
int 21h