# Prende da file e salva in struttira dati

.section .data

    buffer: .ascii "0"
    num: .byte 0        # variabile in cui salvo il numero letto per intero in numero (non ascii)
                        # non usiamo 'INTEGER' perchè ci bastano 8 bit di memoria (0-255)
    
    
