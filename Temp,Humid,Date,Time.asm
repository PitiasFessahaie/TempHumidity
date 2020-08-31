
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Temp,Humid,Date,Time.c,25 :: 		void Interrupt(){
;Temp,Humid,Date,Time.c,26 :: 		if (TMR1IF_bit){
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_Interrupt0
;Temp,Humid,Date,Time.c,27 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;Temp,Humid,Date,Time.c,28 :: 		TMR1H         = 0x6D;
	MOVLW      109
	MOVWF      TMR1H+0
;Temp,Humid,Date,Time.c,29 :: 		TMR1L         = 0x84;
	MOVLW      132
	MOVWF      TMR1L+0
;Temp,Humid,Date,Time.c,30 :: 		n++;
	INCF       _n+0, 1
;Temp,Humid,Date,Time.c,31 :: 		}
L_Interrupt0:
;Temp,Humid,Date,Time.c,32 :: 		}
L_end_Interrupt:
L__Interrupt61:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_StartSignal:

;Temp,Humid,Date,Time.c,33 :: 		void StartSignal(){
;Temp,Humid,Date,Time.c,34 :: 		TRISC.F0 = 0;    //Configure RD2 as output
	BCF        TRISC+0, 0
;Temp,Humid,Date,Time.c,35 :: 		PORTC.F0 = 0;    //RD2 sends 0 to the sensor
	BCF        PORTC+0, 0
;Temp,Humid,Date,Time.c,36 :: 		delay_ms(18);
	MOVLW      71
	MOVWF      R12+0
	MOVLW      31
	MOVWF      R13+0
L_StartSignal1:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal1
	DECFSZ     R12+0, 1
	GOTO       L_StartSignal1
	NOP
	NOP
;Temp,Humid,Date,Time.c,37 :: 		PORTC.F0 = 1;    //RD2 sends 1 to the sensor
	BSF        PORTC+0, 0
;Temp,Humid,Date,Time.c,38 :: 		delay_us(30);
	MOVLW      29
	MOVWF      R13+0
L_StartSignal2:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal2
	NOP
	NOP
;Temp,Humid,Date,Time.c,39 :: 		TRISC.F0 = 1;    //Configure RD2 as input
	BSF        TRISC+0, 0
;Temp,Humid,Date,Time.c,40 :: 		}
L_end_StartSignal:
	RETURN
; end of _StartSignal

_CheckResponse:

;Temp,Humid,Date,Time.c,41 :: 		void CheckResponse(){
;Temp,Humid,Date,Time.c,42 :: 		a = 0;
	CLRF       _a+0
;Temp,Humid,Date,Time.c,43 :: 		delay_us(40);
	MOVLW      39
	MOVWF      R13+0
L_CheckResponse3:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse3
	NOP
	NOP
;Temp,Humid,Date,Time.c,44 :: 		if (PORTC.F0 == 0){
	BTFSC      PORTC+0, 0
	GOTO       L_CheckResponse4
;Temp,Humid,Date,Time.c,45 :: 		delay_us(80);
	MOVLW      79
	MOVWF      R13+0
L_CheckResponse5:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse5
	NOP
	NOP
;Temp,Humid,Date,Time.c,46 :: 		if (PORTC.F0 == 1)   a = 1;
	BTFSS      PORTC+0, 0
	GOTO       L_CheckResponse6
	MOVLW      1
	MOVWF      _a+0
L_CheckResponse6:
;Temp,Humid,Date,Time.c,47 :: 		delay_us(40);}
	MOVLW      39
	MOVWF      R13+0
L_CheckResponse7:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse7
	NOP
	NOP
L_CheckResponse4:
;Temp,Humid,Date,Time.c,48 :: 		}
L_end_CheckResponse:
	RETURN
; end of _CheckResponse

_ReadData:

;Temp,Humid,Date,Time.c,49 :: 		void ReadData(){
;Temp,Humid,Date,Time.c,50 :: 		for(b=0;b<8;b++){
	CLRF       _b+0
L_ReadData8:
	MOVLW      8
	SUBWF      _b+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ReadData9
;Temp,Humid,Date,Time.c,51 :: 		while(!PORTC.F0); //Wait until PORTC.F0 goes HIGH
L_ReadData11:
	BTFSC      PORTC+0, 0
	GOTO       L_ReadData12
	GOTO       L_ReadData11
L_ReadData12:
;Temp,Humid,Date,Time.c,52 :: 		delay_us(30);
	MOVLW      29
	MOVWF      R13+0
L_ReadData13:
	DECFSZ     R13+0, 1
	GOTO       L_ReadData13
	NOP
	NOP
;Temp,Humid,Date,Time.c,53 :: 		if(PORTC.F0 == 0) j &= ~(1<<(7-b));  //Clear bit (7-b)
	BTFSC      PORTC+0, 0
	GOTO       L_ReadData14
	MOVF       _b+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData65:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData66
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData65
L__ReadData66:
	COMF       R0+0, 1
	MOVF       R0+0, 0
	ANDWF      _j+0, 1
	GOTO       L_ReadData15
L_ReadData14:
;Temp,Humid,Date,Time.c,54 :: 		else{j|= (1<<(7-b));               //Set bit (7-b)
	MOVF       _b+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData67:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData68
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData67
L__ReadData68:
	MOVF       R0+0, 0
	IORWF      _j+0, 1
;Temp,Humid,Date,Time.c,55 :: 		while(PORTC.F0);}  //Wait until PORTC.F0 goes LOW
L_ReadData16:
	BTFSS      PORTC+0, 0
	GOTO       L_ReadData17
	GOTO       L_ReadData16
L_ReadData17:
L_ReadData15:
;Temp,Humid,Date,Time.c,50 :: 		for(b=0;b<8;b++){
	INCF       _b+0, 1
;Temp,Humid,Date,Time.c,56 :: 		}
	GOTO       L_ReadData8
L_ReadData9:
;Temp,Humid,Date,Time.c,57 :: 		}
L_end_ReadData:
	RETURN
; end of _ReadData

_display:

;Temp,Humid,Date,Time.c,58 :: 		void display(){
;Temp,Humid,Date,Time.c,60 :: 		second10  =  (second & 0x70) >> 4;
	MOVLW      112
	ANDWF      _second+0, 0
	MOVWF      _second10+0
	RRF        _second10+0, 1
	BCF        _second10+0, 7
	RRF        _second10+0, 1
	BCF        _second10+0, 7
	RRF        _second10+0, 1
	BCF        _second10+0, 7
	RRF        _second10+0, 1
	BCF        _second10+0, 7
;Temp,Humid,Date,Time.c,61 :: 		second = second & 0x0F;
	MOVLW      15
	ANDWF      _second+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _second+0
;Temp,Humid,Date,Time.c,62 :: 		minute10  =  (minute & 0x70) >> 4;
	MOVLW      112
	ANDWF      _minute+0, 0
	MOVWF      _minute10+0
	RRF        _minute10+0, 1
	BCF        _minute10+0, 7
	RRF        _minute10+0, 1
	BCF        _minute10+0, 7
	RRF        _minute10+0, 1
	BCF        _minute10+0, 7
	RRF        _minute10+0, 1
	BCF        _minute10+0, 7
;Temp,Humid,Date,Time.c,63 :: 		minute = minute & 0x0F;
	MOVLW      15
	ANDWF      _minute+0, 1
;Temp,Humid,Date,Time.c,64 :: 		hour10  =  (hour & 0x30) >> 4;
	MOVLW      48
	ANDWF      _hour+0, 0
	MOVWF      _hour10+0
	RRF        _hour10+0, 1
	BCF        _hour10+0, 7
	RRF        _hour10+0, 1
	BCF        _hour10+0, 7
	RRF        _hour10+0, 1
	BCF        _hour10+0, 7
	RRF        _hour10+0, 1
	BCF        _hour10+0, 7
;Temp,Humid,Date,Time.c,65 :: 		hour = hour & 0x0F;
	MOVLW      15
	ANDWF      _hour+0, 1
;Temp,Humid,Date,Time.c,66 :: 		date10  =  (date & 0x30) >> 4;
	MOVLW      48
	ANDWF      _date+0, 0
	MOVWF      _date10+0
	RRF        _date10+0, 1
	BCF        _date10+0, 7
	RRF        _date10+0, 1
	BCF        _date10+0, 7
	RRF        _date10+0, 1
	BCF        _date10+0, 7
	RRF        _date10+0, 1
	BCF        _date10+0, 7
;Temp,Humid,Date,Time.c,67 :: 		date = date & 0x0F;
	MOVLW      15
	ANDWF      _date+0, 1
;Temp,Humid,Date,Time.c,68 :: 		month10  =  (month & 0x10) >> 4;
	MOVLW      0
	BTFSC      _month+0, 4
	MOVLW      1
	MOVWF      _month10+0
;Temp,Humid,Date,Time.c,69 :: 		month = month & 0x0F;
	MOVLW      15
	ANDWF      _month+0, 1
;Temp,Humid,Date,Time.c,70 :: 		year10  =  (year & 0xF0) >> 4;
	MOVLW      240
	ANDWF      _year+0, 0
	MOVWF      _year10+0
	RRF        _year10+0, 1
	BCF        _year10+0, 7
	RRF        _year10+0, 1
	BCF        _year10+0, 7
	RRF        _year10+0, 1
	BCF        _year10+0, 7
	RRF        _year10+0, 1
	BCF        _year10+0, 7
;Temp,Humid,Date,Time.c,71 :: 		year = year & 0x0F;
	MOVLW      15
	ANDWF      _year+0, 1
;Temp,Humid,Date,Time.c,73 :: 		Lcd_Chr(1, 8, second + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      R1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,74 :: 		Lcd_Chr(1, 7, second10 + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _second10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,75 :: 		Lcd_Chr(1, 5, minute + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _minute+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,76 :: 		Lcd_Chr(1, 4, minute10 + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _minute10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,77 :: 		Lcd_Chr(1, 2, hour + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _hour+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,78 :: 		Lcd_Chr(1, 1, hour10 + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _hour10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,80 :: 		Lcd_Chr(2, 2, date + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _date+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,81 :: 		Lcd_Chr(2, 1, date10 + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _date10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,82 :: 		Lcd_Chr(2, 5, month + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _month+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,83 :: 		Lcd_Chr(2, 4, month10 + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _month10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,84 :: 		Lcd_Chr(2, 10, year + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _year+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,85 :: 		Lcd_Chr(2, 9, year10 + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _year10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,87 :: 		Lcd_Chr(1, 14, (temp/10) + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _temp+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,88 :: 		Lcd_Chr(1, 15, (temp % 10) + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _temp+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,89 :: 		Lcd_Chr(2, 14, (humidity/10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _humidity+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,90 :: 		Lcd_Chr(2, 15, (humidity % 10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _humidity+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,91 :: 		}
L_end_display:
	RETURN
; end of _display

_write_value:

;Temp,Humid,Date,Time.c,92 :: 		void write_value(char address, char data_)
;Temp,Humid,Date,Time.c,94 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;Temp,Humid,Date,Time.c,95 :: 		I2C1_Wr(0xD0);
	MOVLW      208
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;Temp,Humid,Date,Time.c,96 :: 		I2C1_Wr(address);
	MOVF       FARG_write_value_address+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;Temp,Humid,Date,Time.c,97 :: 		I2C1_Wr(data_);
	MOVF       FARG_write_value_data_+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;Temp,Humid,Date,Time.c,98 :: 		I2C1_Stop();     }
	CALL       _I2C1_Stop+0
L_end_write_value:
	RETURN
; end of _write_value

_main:

;Temp,Humid,Date,Time.c,99 :: 		void main() {
;Temp,Humid,Date,Time.c,101 :: 		T1CON         = 0x31;
	MOVLW      49
	MOVWF      T1CON+0
;Temp,Humid,Date,Time.c,102 :: 		TMR1IF_bit         = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;Temp,Humid,Date,Time.c,103 :: 		TMR1H         = 0x6D;
	MOVLW      109
	MOVWF      TMR1H+0
;Temp,Humid,Date,Time.c,104 :: 		TMR1L         = 0x84;
	MOVLW      132
	MOVWF      TMR1L+0
;Temp,Humid,Date,Time.c,105 :: 		TMR1IE_bit         = 1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;Temp,Humid,Date,Time.c,106 :: 		INTCON         = 0xC0;
	MOVLW      192
	MOVWF      INTCON+0
;Temp,Humid,Date,Time.c,108 :: 		TRISB = 3;
	MOVLW      3
	MOVWF      TRISB+0
;Temp,Humid,Date,Time.c,109 :: 		Lcd_Init();                // Initialize LCD
	CALL       _Lcd_Init+0
;Temp,Humid,Date,Time.c,110 :: 		Lcd_Cmd(_LCD_CLEAR);       // Clear LCD display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,111 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);  // Turn cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,112 :: 		I2C1_Init(100000);         // initialize I2C at 100KHz
	MOVLW      30
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;Temp,Humid,Date,Time.c,113 :: 		return_:
___main_return_:
;Temp,Humid,Date,Time.c,114 :: 		text = ":  :     T:  C" ;
	MOVLW      ?lstr1_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,115 :: 		Lcd_Out(1, 3, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,116 :: 		text = "/  /20   H:  %" ;
	MOVLW      ?lstr2_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,117 :: 		Lcd_Out(2, 3, text);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,118 :: 		write_value(0, 0);   //Reset seconds and start oscillator
	CLRF       FARG_write_value_address+0
	CLRF       FARG_write_value_data_+0
	CALL       _write_value+0
;Temp,Humid,Date,Time.c,119 :: 		while(1){
L_main18:
;Temp,Humid,Date,Time.c,120 :: 		if(i == 1){
	MOVF       _i+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;Temp,Humid,Date,Time.c,121 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,122 :: 		text = "Adjust Minute:";
	MOVLW      ?lstr3_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,123 :: 		Lcd_Out(1, 2, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,124 :: 		minute = minute + minute10 * 10;
	MOVF       _minute10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	ADDWF      _minute+0, 1
;Temp,Humid,Date,Time.c,125 :: 		while(1){
L_main21:
;Temp,Humid,Date,Time.c,126 :: 		if (Button(&PORTB, 0, 100, 0)) i++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
	INCF       _i+0, 1
L_main23:
;Temp,Humid,Date,Time.c,127 :: 		if(i!=1){
	MOVF       _i+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;Temp,Humid,Date,Time.c,128 :: 		minute = ((minute/10) << 4) + (minute % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVF       _minute+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _minute+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _minute+0
;Temp,Humid,Date,Time.c,129 :: 		write_value( 1 , minute);
	MOVLW      1
	MOVWF      FARG_write_value_address+0
	MOVF       R0+0, 0
	MOVWF      FARG_write_value_data_+0
	CALL       _write_value+0
;Temp,Humid,Date,Time.c,130 :: 		goto return_;}
	GOTO       ___main_return_
L_main24:
;Temp,Humid,Date,Time.c,131 :: 		if (Button(&PORTB, 1, 100, 0)) minute++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main25
	INCF       _minute+0, 1
L_main25:
;Temp,Humid,Date,Time.c,132 :: 		if (minute > 59) minute = 0;
	MOVF       _minute+0, 0
	SUBLW      59
	BTFSC      STATUS+0, 0
	GOTO       L_main26
	CLRF       _minute+0
L_main26:
;Temp,Humid,Date,Time.c,133 :: 		Lcd_Chr(2, 8, (minute/10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _minute+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,134 :: 		Lcd_Chr(2, 9, (minute % 10) + 48);}
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _minute+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_main21
;Temp,Humid,Date,Time.c,135 :: 		}
L_main20:
;Temp,Humid,Date,Time.c,136 :: 		if(i == 2){ Lcd_Cmd(_LCD_CLEAR);
	MOVF       _i+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,137 :: 		text = "Adjust Hour:";
	MOVLW      ?lstr4_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,138 :: 		Lcd_Out(1, 2, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,139 :: 		hour = hour + hour10 * 10;
	MOVF       _hour10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	ADDWF      _hour+0, 1
;Temp,Humid,Date,Time.c,140 :: 		while(1){
L_main28:
;Temp,Humid,Date,Time.c,141 :: 		if (Button(&PORTB, 0, 100, 0)) i++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main30
	INCF       _i+0, 1
L_main30:
;Temp,Humid,Date,Time.c,142 :: 		if(i!=2){
	MOVF       _i+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main31
;Temp,Humid,Date,Time.c,143 :: 		hour = ((hour/10) << 4) + (hour % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVF       _hour+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _hour+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _hour+0
;Temp,Humid,Date,Time.c,144 :: 		write_value( 2 , hour);
	MOVLW      2
	MOVWF      FARG_write_value_address+0
	MOVF       R0+0, 0
	MOVWF      FARG_write_value_data_+0
	CALL       _write_value+0
;Temp,Humid,Date,Time.c,145 :: 		goto return_;}
	GOTO       ___main_return_
L_main31:
;Temp,Humid,Date,Time.c,146 :: 		if (Button(&PORTB, 1, 100, 0)) hour++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	INCF       _hour+0, 1
L_main32:
;Temp,Humid,Date,Time.c,147 :: 		if (hour > 23) hour = 0;
	MOVF       _hour+0, 0
	SUBLW      23
	BTFSC      STATUS+0, 0
	GOTO       L_main33
	CLRF       _hour+0
L_main33:
;Temp,Humid,Date,Time.c,148 :: 		Lcd_Chr(2, 8, (hour/10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _hour+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,149 :: 		Lcd_Chr(2, 9, (hour % 10) + 48);}
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _hour+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_main28
;Temp,Humid,Date,Time.c,150 :: 		}
L_main27:
;Temp,Humid,Date,Time.c,151 :: 		if(i == 3){ Lcd_Cmd(_LCD_CLEAR);
	MOVF       _i+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,152 :: 		text = "Adjust Date:";
	MOVLW      ?lstr5_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,153 :: 		Lcd_Out(1, 2, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,154 :: 		date = date + date10 * 10;
	MOVF       _date10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	ADDWF      _date+0, 1
;Temp,Humid,Date,Time.c,155 :: 		while(1){
L_main35:
;Temp,Humid,Date,Time.c,156 :: 		if (Button(&PORTB, 0, 100, 0)) i++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main37
	INCF       _i+0, 1
L_main37:
;Temp,Humid,Date,Time.c,157 :: 		if(i!=3){
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main38
;Temp,Humid,Date,Time.c,158 :: 		date = ((date/10) << 4) + (date % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVF       _date+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _date+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _date+0
;Temp,Humid,Date,Time.c,159 :: 		write_value( 4 , date);
	MOVLW      4
	MOVWF      FARG_write_value_address+0
	MOVF       R0+0, 0
	MOVWF      FARG_write_value_data_+0
	CALL       _write_value+0
;Temp,Humid,Date,Time.c,160 :: 		goto return_;}
	GOTO       ___main_return_
L_main38:
;Temp,Humid,Date,Time.c,161 :: 		if (Button(&PORTB, 1, 100, 0)) date++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main39
	INCF       _date+0, 1
L_main39:
;Temp,Humid,Date,Time.c,162 :: 		if (date > 31) date = 1;
	MOVF       _date+0, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_main40
	MOVLW      1
	MOVWF      _date+0
L_main40:
;Temp,Humid,Date,Time.c,163 :: 		Lcd_Chr(2, 8, (date/10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _date+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,164 :: 		Lcd_Chr(2, 9, (date % 10) + 48);}
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _date+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_main35
;Temp,Humid,Date,Time.c,165 :: 		}
L_main34:
;Temp,Humid,Date,Time.c,166 :: 		if(i == 4){ Lcd_Cmd(_LCD_CLEAR);
	MOVF       _i+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main41
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,167 :: 		text = "Adjust Month:";
	MOVLW      ?lstr6_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,168 :: 		Lcd_Out(1, 2, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,169 :: 		month = month + month10 * 10;
	MOVF       _month10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	ADDWF      _month+0, 1
;Temp,Humid,Date,Time.c,170 :: 		while(1){
L_main42:
;Temp,Humid,Date,Time.c,171 :: 		if (Button(&PORTB, 0, 100, 0)) i++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main44
	INCF       _i+0, 1
L_main44:
;Temp,Humid,Date,Time.c,172 :: 		if(i!=4){
	MOVF       _i+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main45
;Temp,Humid,Date,Time.c,173 :: 		month = ((month/10) << 4) + (month % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVF       _month+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _month+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _month+0
;Temp,Humid,Date,Time.c,174 :: 		write_value( 5 , month);
	MOVLW      5
	MOVWF      FARG_write_value_address+0
	MOVF       R0+0, 0
	MOVWF      FARG_write_value_data_+0
	CALL       _write_value+0
;Temp,Humid,Date,Time.c,175 :: 		goto return_;}
	GOTO       ___main_return_
L_main45:
;Temp,Humid,Date,Time.c,176 :: 		if (Button(&PORTB, 1, 100, 0)) month++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main46
	INCF       _month+0, 1
L_main46:
;Temp,Humid,Date,Time.c,177 :: 		if (month > 12) month = 1;
	MOVF       _month+0, 0
	SUBLW      12
	BTFSC      STATUS+0, 0
	GOTO       L_main47
	MOVLW      1
	MOVWF      _month+0
L_main47:
;Temp,Humid,Date,Time.c,178 :: 		Lcd_Chr(2, 8, (month/10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _month+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,179 :: 		Lcd_Chr(2, 9, (month % 10) + 48);}
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _month+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_main42
;Temp,Humid,Date,Time.c,180 :: 		}
L_main41:
;Temp,Humid,Date,Time.c,181 :: 		if(i == 5){ Lcd_Cmd(_LCD_CLEAR);
	MOVF       _i+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_main48
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temp,Humid,Date,Time.c,182 :: 		text = "Adjust Year:";
	MOVLW      ?lstr7_Temp,Humid,Date,Time+0
	MOVWF      _text+0
;Temp,Humid,Date,Time.c,183 :: 		Lcd_Out(1, 2, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temp,Humid,Date,Time.c,184 :: 		year = year + year10 * 10;
	MOVF       _year10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	ADDWF      _year+0, 1
;Temp,Humid,Date,Time.c,185 :: 		while(1){
L_main49:
;Temp,Humid,Date,Time.c,186 :: 		if (Button(&PORTB, 0, 100, 0)) {i++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main51
	INCF       _i+0, 1
;Temp,Humid,Date,Time.c,187 :: 		if (i > 5) i = 0;}
	MOVF       _i+0, 0
	SUBLW      5
	BTFSC      STATUS+0, 0
	GOTO       L_main52
	CLRF       _i+0
L_main52:
L_main51:
;Temp,Humid,Date,Time.c,188 :: 		if(i!=5){
	MOVF       _i+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main53
;Temp,Humid,Date,Time.c,189 :: 		year = ((year/10) << 4) + (year % 10);
	MOVLW      10
	MOVWF      R4+0
	MOVF       _year+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	RLF        FLOC__main+0, 1
	BCF        FLOC__main+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _year+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _year+0
;Temp,Humid,Date,Time.c,190 :: 		write_value( 6 , year);
	MOVLW      6
	MOVWF      FARG_write_value_address+0
	MOVF       R0+0, 0
	MOVWF      FARG_write_value_data_+0
	CALL       _write_value+0
;Temp,Humid,Date,Time.c,191 :: 		goto return_;}
	GOTO       ___main_return_
L_main53:
;Temp,Humid,Date,Time.c,192 :: 		if (Button(&PORTB, 1, 100, 0)) year++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main54
	INCF       _year+0, 1
L_main54:
;Temp,Humid,Date,Time.c,193 :: 		if (year > 99) year = 0;
	MOVF       _year+0, 0
	SUBLW      99
	BTFSC      STATUS+0, 0
	GOTO       L_main55
	CLRF       _year+0
L_main55:
;Temp,Humid,Date,Time.c,194 :: 		Lcd_Chr(2, 7, 2 + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      50
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,195 :: 		Lcd_Chr(2, 8, 0 + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,196 :: 		Lcd_Chr(2, 9, (year/10) + 48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _year+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Temp,Humid,Date,Time.c,197 :: 		Lcd_Chr(2, 10, (year % 10) + 48);}
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _year+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_main49
;Temp,Humid,Date,Time.c,198 :: 		}
L_main48:
;Temp,Humid,Date,Time.c,199 :: 		if (n > 19){
	MOVF       _n+0, 0
	SUBLW      19
	BTFSC      STATUS+0, 0
	GOTO       L_main56
;Temp,Humid,Date,Time.c,200 :: 		n = 0;
	CLRF       _n+0
;Temp,Humid,Date,Time.c,201 :: 		StartSignal();
	CALL       _StartSignal+0
;Temp,Humid,Date,Time.c,202 :: 		CheckResponse();
	CALL       _CheckResponse+0
;Temp,Humid,Date,Time.c,203 :: 		if (a == 1){
	MOVF       _a+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main57
;Temp,Humid,Date,Time.c,204 :: 		ReadData();
	CALL       _ReadData+0
;Temp,Humid,Date,Time.c,205 :: 		humidity = j;
	MOVF       _j+0, 0
	MOVWF      _humidity+0
;Temp,Humid,Date,Time.c,206 :: 		ReadData();
	CALL       _ReadData+0
;Temp,Humid,Date,Time.c,207 :: 		ReadData();
	CALL       _ReadData+0
;Temp,Humid,Date,Time.c,208 :: 		temp = j;}
	MOVF       _j+0, 0
	MOVWF      _temp+0
	GOTO       L_main58
L_main57:
;Temp,Humid,Date,Time.c,210 :: 		humidity = 0;
	CLRF       _humidity+0
;Temp,Humid,Date,Time.c,211 :: 		temp = 0; }
	CLRF       _temp+0
L_main58:
;Temp,Humid,Date,Time.c,212 :: 		}
L_main56:
;Temp,Humid,Date,Time.c,213 :: 		if (Button(&PORTB, 0, 100, 0)) i++;
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main59
	INCF       _i+0, 1
L_main59:
;Temp,Humid,Date,Time.c,214 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;Temp,Humid,Date,Time.c,215 :: 		I2C1_Wr(0xD0);
	MOVLW      208
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;Temp,Humid,Date,Time.c,216 :: 		I2C1_Wr(0);
	CLRF       FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;Temp,Humid,Date,Time.c,217 :: 		I2C1_Repeated_Start();
	CALL       _I2C1_Repeated_Start+0
;Temp,Humid,Date,Time.c,218 :: 		I2C1_Wr(0xD1);
	MOVLW      209
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;Temp,Humid,Date,Time.c,219 :: 		second =I2C1_Rd(1);
	MOVLW      1
	MOVWF      FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _second+0
;Temp,Humid,Date,Time.c,220 :: 		minute =I2C1_Rd(1);
	MOVLW      1
	MOVWF      FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _minute+0
;Temp,Humid,Date,Time.c,221 :: 		hour =I2C1_Rd(1);
	MOVLW      1
	MOVWF      FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _hour+0
;Temp,Humid,Date,Time.c,222 :: 		day =I2C1_Rd(1);
	MOVLW      1
	MOVWF      FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _day+0
;Temp,Humid,Date,Time.c,223 :: 		date =I2C1_Rd(1);
	MOVLW      1
	MOVWF      FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _date+0
;Temp,Humid,Date,Time.c,224 :: 		month =I2C1_Rd(1);
	MOVLW      1
	MOVWF      FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _month+0
;Temp,Humid,Date,Time.c,225 :: 		year =I2C1_Rd(0);
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      _year+0
;Temp,Humid,Date,Time.c,226 :: 		I2C1_Stop();
	CALL       _I2C1_Stop+0
;Temp,Humid,Date,Time.c,227 :: 		display();
	CALL       _display+0
;Temp,Humid,Date,Time.c,228 :: 		}
	GOTO       L_main18
;Temp,Humid,Date,Time.c,229 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
