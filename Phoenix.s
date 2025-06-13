.name       "Phoenix"
.comment    "Survie, scan, régénération, vengeance."

        ld      %0, r10        
        ld      %0, r11        
        ld      %1, r12         
        ld      %0, r13         

        sti     r1, %:live_loop, %1
        fork    %:live_loop
        fork    %:copie_init     

        zjmp    %:watchdog       

live_loop:
        live    %1
        xor     r16, r16, r16
        zjmp    %:live_loop

original:
        live    %1
        xor     r16, r16, r16
        zjmp    %:original

copie_init:
        live    %1
        ldi     %:original, r10, r1   
        sti     r1, %:safe_zone, r10  
        add     r10, r12, r10      
        ld      %64, r15              
        sub     r10, r15, r11        
        zjmp    %:copie_init         

safe_zone:
        live    %1
        zjmp    %:safe_zone

watchdog:
        live    %1
        ldi     %:original, r10, r2
        ldi     %:safe_zone, r10, r3
        sub     r2, r3, r4            
        zjmp    %:ok              
        ldi     %:safe_zone, r10, r5
        sti     r5, %:original, r10
        fork    %:original           
        zjmp    %:watchdog

ok:
        add     r10, r12, r10
        ld      %64, r15              
        sub     r10, r15, r11  
        zjmp    %:watchdog
