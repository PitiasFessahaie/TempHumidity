#line 1 "C:/Users/Pitias/Desktop/PROJECTS/temp humid sensor with real time and date/Temp,Humid,Date,Time.c"




sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D4 at RD2_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D7 at RD5_bit;

sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D4_Direction at TRISD2_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D7_Direction at TRISD5_bit;


 unsigned char *text, second, second10, minute, minute10,
 hour, hour10, date, date10, month, month10,
 year, year10, day, i = 0;
 unsigned char a = 0, b = 0,j = 0, n, temp, humidity;

 void Interrupt(){
 if (TMR1IF_bit){
 TMR1IF_bit = 0;
 TMR1H = 0x6D;
 TMR1L = 0x84;
 n++;
 }
}
 void StartSignal(){
 TRISC.F0 = 0;
 PORTC.F0 = 0;
 delay_ms(18);
 PORTC.F0 = 1;
 delay_us(30);
 TRISC.F0 = 1;
 }
 void CheckResponse(){
 a = 0;
 delay_us(40);
 if (PORTC.F0 == 0){
 delay_us(80);
 if (PORTC.F0 == 1) a = 1;
 delay_us(40);}
 }
 void ReadData(){
 for(b=0;b<8;b++){
 while(!PORTC.F0);
 delay_us(30);
 if(PORTC.F0 == 0) j &= ~(1<<(7-b));
 else{j|= (1<<(7-b));
 while(PORTC.F0);}
 }
 }
 void display(){

 second10 = (second & 0x70) >> 4;
 second = second & 0x0F;
 minute10 = (minute & 0x70) >> 4;
 minute = minute & 0x0F;
 hour10 = (hour & 0x30) >> 4;
 hour = hour & 0x0F;
 date10 = (date & 0x30) >> 4;
 date = date & 0x0F;
 month10 = (month & 0x10) >> 4;
 month = month & 0x0F;
 year10 = (year & 0xF0) >> 4;
 year = year & 0x0F;

 Lcd_Chr(1, 8, second + 48);
 Lcd_Chr(1, 7, second10 + 48);
 Lcd_Chr(1, 5, minute + 48);
 Lcd_Chr(1, 4, minute10 + 48);
 Lcd_Chr(1, 2, hour + 48);
 Lcd_Chr(1, 1, hour10 + 48);

 Lcd_Chr(2, 2, date + 48);
 Lcd_Chr(2, 1, date10 + 48);
 Lcd_Chr(2, 5, month + 48);
 Lcd_Chr(2, 4, month10 + 48);
 Lcd_Chr(2, 10, year + 48);
 Lcd_Chr(2, 9, year10 + 48);

 Lcd_Chr(1, 14, (temp/10) + 48);
 Lcd_Chr(1, 15, (temp % 10) + 48);
 Lcd_Chr(2, 14, (humidity/10) + 48);
 Lcd_Chr(2, 15, (humidity % 10) + 48);
 }
 void write_value(char address, char data_)
 {
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Wr(data_);
 I2C1_Stop(); }
 void main() {

 T1CON = 0x31;
 TMR1IF_bit = 0;
 TMR1H = 0x6D;
 TMR1L = 0x84;
 TMR1IE_bit = 1;
 INTCON = 0xC0;

 TRISB = 3;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 I2C1_Init(100000);
 return_:
 text = ":  :     T:  C" ;
 Lcd_Out(1, 3, text);
 text = "/  /20   H:  %" ;
 Lcd_Out(2, 3, text);
 write_value(0, 0);
 while(1){
 if(i == 1){
 Lcd_Cmd(_LCD_CLEAR);
 text = "Adjust Minute:";
 Lcd_Out(1, 2, text);
 minute = minute + minute10 * 10;
 while(1){
 if (Button(&PORTB, 0, 100, 0)) i++;
 if(i!=1){
 minute = ((minute/10) << 4) + (minute % 10);
 write_value( 1 , minute);
 goto return_;}
 if (Button(&PORTB, 1, 100, 0)) minute++;
 if (minute > 59) minute = 0;
 Lcd_Chr(2, 8, (minute/10) + 48);
 Lcd_Chr(2, 9, (minute % 10) + 48);}
 }
 if(i == 2){ Lcd_Cmd(_LCD_CLEAR);
 text = "Adjust Hour:";
 Lcd_Out(1, 2, text);
 hour = hour + hour10 * 10;
 while(1){
 if (Button(&PORTB, 0, 100, 0)) i++;
 if(i!=2){
 hour = ((hour/10) << 4) + (hour % 10);
 write_value( 2 , hour);
 goto return_;}
 if (Button(&PORTB, 1, 100, 0)) hour++;
 if (hour > 23) hour = 0;
 Lcd_Chr(2, 8, (hour/10) + 48);
 Lcd_Chr(2, 9, (hour % 10) + 48);}
 }
 if(i == 3){ Lcd_Cmd(_LCD_CLEAR);
 text = "Adjust Date:";
 Lcd_Out(1, 2, text);
 date = date + date10 * 10;
 while(1){
 if (Button(&PORTB, 0, 100, 0)) i++;
 if(i!=3){
 date = ((date/10) << 4) + (date % 10);
 write_value( 4 , date);
 goto return_;}
 if (Button(&PORTB, 1, 100, 0)) date++;
 if (date > 31) date = 1;
 Lcd_Chr(2, 8, (date/10) + 48);
 Lcd_Chr(2, 9, (date % 10) + 48);}
 }
 if(i == 4){ Lcd_Cmd(_LCD_CLEAR);
 text = "Adjust Month:";
 Lcd_Out(1, 2, text);
 month = month + month10 * 10;
 while(1){
 if (Button(&PORTB, 0, 100, 0)) i++;
 if(i!=4){
 month = ((month/10) << 4) + (month % 10);
 write_value( 5 , month);
 goto return_;}
 if (Button(&PORTB, 1, 100, 0)) month++;
 if (month > 12) month = 1;
 Lcd_Chr(2, 8, (month/10) + 48);
 Lcd_Chr(2, 9, (month % 10) + 48);}
 }
 if(i == 5){ Lcd_Cmd(_LCD_CLEAR);
 text = "Adjust Year:";
 Lcd_Out(1, 2, text);
 year = year + year10 * 10;
 while(1){
 if (Button(&PORTB, 0, 100, 0)) {i++;
 if (i > 5) i = 0;}
 if(i!=5){
 year = ((year/10) << 4) + (year % 10);
 write_value( 6 , year);
 goto return_;}
 if (Button(&PORTB, 1, 100, 0)) year++;
 if (year > 99) year = 0;
 Lcd_Chr(2, 7, 2 + 48);
 Lcd_Chr(2, 8, 0 + 48);
 Lcd_Chr(2, 9, (year/10) + 48);
 Lcd_Chr(2, 10, (year % 10) + 48);}
 }
 if (n > 19){
 n = 0;
 StartSignal();
 CheckResponse();
 if (a == 1){
 ReadData();
 humidity = j;
 ReadData();
 ReadData();
 temp = j;}
 else {
 humidity = 0;
 temp = 0; }
 }
 if (Button(&PORTB, 0, 100, 0)) i++;
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(0);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
 second =I2C1_Rd(1);
 minute =I2C1_Rd(1);
 hour =I2C1_Rd(1);
 day =I2C1_Rd(1);
 date =I2C1_Rd(1);
 month =I2C1_Rd(1);
 year =I2C1_Rd(0);
 I2C1_Stop();
 display();
}
}
