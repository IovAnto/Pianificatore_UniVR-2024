.section .data
word: .space 4  # Buffer for the string (3 digits + null terminator)

.section .text
    .global btoa
    .type btoa, @function
    
btoa:
   
loop:
   
done:
   