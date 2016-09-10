Uses Crt,dos,Gif,ModeXLib,Sprites,vocplay,tastatur;

Const Sprite_Anzahl=77;          {Anzahl im Programm verwendeter Sprites}

Var Sprite:Array[1..Sprite_Anzahl] of SpriteTyp;
    zz:array[1..5] of spritetyp;
    qq,zzz,p,z,ii,n,i:Word;                     {Z„hler}
    taste,c:byte;
    power1,power2,cheat,boni,bomben,leben:integer;
    palette1,
    origpal,
    zielpal:Array[0..767] of Byte;
    missile,streu:boolean;
    a:char;
    schus,hit:longint;
procedure putship(y,x:word;temp:byte);
begin
 putsprite(24000,x,y,sprite[temp]);
end;

procedure bewegung(x:word);
begin
 inc(x);
 if x>=310 then sprite[i].ja:=false;
end;

function mauspressed:byte;
var g:registers;
begin
 g.ax:=3;
 intr($33,g);
 mauspressed:=g.bx;
end;

function mausy:word;
var y:word;
begin
  asm
     mov ax,0003h              {Funktion 0bh: relative Koordinaten lesen}
     int 33h
     mov y,dx                  {Division durch 2}
   End;
 if y>200 then y:=200;
 if y<1 then y:=1;
 mausy:=y;
 sprite[40].py:=y;
end;


function mausx:word;
var x:word;
begin
  asm
     mov ax,0003h              {Funktion 0bh: relative Koordinaten lesen}
     int 33h
     mov x,cx
  End;
 if x>320 then x:=320;
 if x<1 then x:=1;
 mausx:=x;
 sprite[40].px:=x;
end;

procedure Spiele_Vocdatei(datname : string;ak:boolean);
begin
 Init_Voc(datname);
 if ak then begin
  repeat until keypressed or (mauspressed>0) or voc_ready
 end else begin
  repeat until voc_ready;
 end;
 voc_done;
end;

procedure schuss(blubb:integer);
begin
   if missile=false then begin
    for i:=1 to 39 do begin
     if sprite[i].ja=false then begin
      inc(schus);
      sound(200);
      delay(5);
      nosound;
      sprite[i].ja:=true;
      sprite[i].px:=sprite[blubb].px-7;
      if streu then sprite[i].py:=sprite[blubb].py+random(40)-20 else sprite[i].py:=sprite[blubb].py+1;
      if (sprite[i].py<1) or (sprite[i].py>200) then sprite[i].ja:=fAlse;
      exit;
     end;
    end;
   end else begin
    for i:=57 to 77 do begin
     if sprite[i].ja=false then begin
      inc(schus);
      sound(300);delay(5);nosound;
      if random(100)>50 then sprite[i].sx:=0 else sprite[i].sx:=1;
      sprite[i].ja:=true;
      sprite[i].px:=sprite[blubb].px-17;
      sprite[i].py:=sprite[blubb].py+1;
      if (sprite[i].py<3) or (sprite[i].py>197) then sprite[i].ja:=fAlse;
      exit;
     end;
    end;
   end;
  end;
 {end;}
procedure bomb;
var q:integer;
begin
 if bomben>=1 then begin
  dec(bomben);
  sprite[56].px:=10;sprite[56].py:=100;
  Spiele_Vocdatei('bombe.voc',false);
  GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
  Move(Palette,OrigPal,768);    {Palette sichern}
  for q:=1 to 767 do palette1[q]:=random(256);
  Move(Palette1,Zielpal,768);    {Ziel-Palette bestimmen}
  delay(200);
  Make_bw(ZielPal);             {ZielPal auf schwarz/weiá ziehen}
  delay(200);
  fade_to(ZielPal,1);           {schwarz/weiáe Palette einblenden}
  delay(200);
  fade_to(OrigPal,1);           {Original-Palette einblenden}
  delay(200);
  for q:=41 to 55 do begin
   sprite[q].px:=300;
   sprite[q].py:=random(180);
  end;
  inc(p,7);
 end;
 sprite[56].px:=10;sprite[56].py:=100;
end;



Begin
 chdir('c:\pcunder\grafik');
 boni:=2;
 streu:=true;
 bomben:=3;
 textbackground(red);
 textcolor(green);
 clrscr;
 writeln('Player 1 : Steuerung mit Maus. Schuss mit Maustaste.');
 writeln('Player 2 : Steuerung mit Pfeiltasten. Schuss mit Leertaste');
 writeln('Bombe abwerfen mit b oder B. Ende mit <ESC>');
 Init_SB;
 delay(1333);
 readln;
 leben:=3;
 randomize;
 Init_ModeX;                   {Mode X einschalten}
 power1:=500;power2:=500;
 LoadGif('back');             {Hintergrundbild laden}
 p13_2_ModeX(vpage,24000);     {und auf Hintergrundseite kopieren}
 LoadGif('actions2');           {Bild mit den drei Sprites laden}
 GetSprite(1+3*320,11,6,Sprite[1]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[2]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[3]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[4]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[5]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[6]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[7]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[8]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[9]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[10]);
 GetSprite(1+3*320,11,6,Sprite[11]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[12]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[13]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[14]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[15]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[16]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[17]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[18]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[19]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[20]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[21]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[22]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[23]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[24]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[25]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[26]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[27]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[28]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[29]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[30]);
 GetSprite(1+3*320,11,6,Sprite[31]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[32]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[33]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[34]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[35]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[36]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[37]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[38]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[39]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(18+2*320,11,9,Sprite[40]); {(203/114), 58*48}
 GetSprite(18+2*320,11,9,Sprite[41]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[42]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[43]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[44]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[45]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[46]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[47]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[48]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[49]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[50]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[51]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[52]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[53]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[54]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[55]); {(203/114), 58*48}
 GetSprite(18+2*320,11,9,Sprite[56]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[57]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[58]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[59]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[60]);
 GetSprite(28+37*320,9,3,Sprite[61]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[62]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[63]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[64]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[65]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[66]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[67]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[68]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[69]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[70]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[71]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[72]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[73]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[74]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[75]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[76]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[77]); {(203/114), 58*48}
 GetSprite(7+31*320,11,14,zz[1]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(6+49*320,10,14,zz[2]); {(203/114), 58*48}
 GetSprite(5+71*320,14,15,zz[3]); {(203/114), 58*48}
 GetSprite(5+71*320,14,15,zz[4]); {(133/114), 58*48}
 GetSprite(5+93*320,11,8,zz[5]);  {Koordinaten (62/114), Breite 58*48}

 asm
  mov ax,0;
  int $33;
 end;
 for i:=1 to 39 do sprite[i].ja:=false;
 for i:=41 to 55 do begin
  sprite[i].px:=random(100)+120;
  sprite[i].le:=6;sprite[i].py:=random(200);
 end;
 for i:=57 to 77 do sprite[i].ja:=false;
 c:=0;
 streu:=false;
 repeat
  if random(10000)>9990 then spiele_vocdatei('plapper.voc',false);
  WaitRetrace;                {Bildschirm darf erst nach n„chstem Retrace}
  CopyScreen(vpage,24000);     {Hintergrundbild auf aktuelle Seite}
  copyscreen(24000,48000);
  putship(mausy,MAUSX,40);
  putship(sprite[56].py,sprite[56].px,56);
  if mauspressed=1 then begin
   for qq:=2 to boni do begin
    if power1>10 then begin dec(power1,10);schuss(40);end;end;
  end;
  for i:=1 to 39 do begin
   if sprite[i].ja=true then begin
    inc(sprite[i].px,10);
    if sprite[i].px>=320 then sprite[i].ja:=false;
    putsprite(24000,sprite[i].px,sprite[i].py,sprite[i]);
    for ii:=41 to 55 do begin
     if sprite[ii].px<=1 then begin
      sprite[ii].py:=random(180)+1;
      sprite[ii].px:=310;
     end;
     if (sprite[i].px<=sprite[ii].px+10) and (sprite[i].py<=sprite[ii].py+10) and (sprite[i].px>=sprite[ii].px-10)
     and (sprite[i].py>=sprite[ii].py-10) then begin
      dec(sprite[ii].le);sprite[i].ja:=false;
      inc(hit);
      if sprite[ii].le<1 then begin
       inc(p);
       if random(10000)>9500 then spiele_vocdatei('asta.voc',false);
       putsprite(vpage,sprite[ii].px,sprite[ii].py-5,zz[1]);
       delay(100);
       putsprite(vpage,sprite[ii].px,sprite[ii].py-5,zz[2]);
       delay(100);
       putsprite(vpage,sprite[ii].px,sprite[ii].py-5,zz[3]);
       delay(100);
       if p>(boni*20) then begin
        spiele_vocdatei('level.voc',false);
        streu:=true;inc(boni);
       end;
       sprite[ii].py:=random(180)+1;sprite[i].le:=6;
       sprite[ii].px:=300;
      end;
     end;
    end;
   end;
  end;
  for i:=57 to 77 do begin
   if sprite[i].ja=true then begin
    inc(sprite[i].px,10);
    if sprite[i].sx>0 then inc(sprite[i].py,5) else dec(sprite[i].py,5);
    if sprite[i].px>=315 then sprite[i].ja:=false;
    if sprite[i].py>=195 then sprite[i].ja:=false;
    if sprite[i].py<=5 then sprite[i].ja:=false;
    putsprite(24000,sprite[i].px,sprite[i].py,sprite[i]);
    for ii:=41 to 55 do begin
     if sprite[ii].px<=1 then begin
      sprite[ii].py:=random(180)+1;
      sprite[ii].px:=310;
     end;
     if (sprite[i].px<=sprite[ii].px+10) and (sprite[i].py<=sprite[ii].py+10) and (sprite[i].px>=sprite[ii].px-10)
     and (sprite[i].py>=sprite[ii].py-10) then begin
      dec(sprite[ii].le);sprite[i].ja:=false;
      if sprite[ii].le<1 then begin
       inc(p);
       putsprite(vpage,sprite[ii].px,sprite[ii].py-5,zz[1]);
       delay(100);
       putsprite(vpage,sprite[ii].px,sprite[ii].py-5,zz[2]);
       delay(100);
       putsprite(vpage,sprite[ii].px,sprite[ii].py-5,zz[3]);
       delay(100);
       if p>(boni*20) then begin
        spiele_vocdatei('level.voc',false);
        streu:=true;
        inc(boni);
       end;
       sprite[ii].py:=random(180)+1;sprite[i].le:=6;
       sprite[ii].px:=300;
      end;
     end;
    end;
   end;
  end;
  for ii:=41 to 55 do begin
   if sprite[ii].le>6 then sprite[ii].le:=6;
   dec(sprite[ii].px,boni-1);
   putsprite(24000,sprite[ii].px,sprite[ii].py,sprite[ii]);
   if sprite[ii].px<=1 then begin
    dec(leben);
    spiele_vocdatei('ohdear.voc',false);
    inc(bomben);
    bomb;
    sprite[ii].py:=random(180)+1;sprite[ii].px:=310;
    if leben<1 then begin
     TextMode(3);
     textbackground(red);
     textcolor(green);
     writeln('Erreichtes Level: ',boni-1);
     writeln('Points: ',p*100);
     writeln('Anzahl abgefeuerter Schsse: ',schus);
     writeln('Trefferquote: ',round((hit/schus)*100),' %');
     if round((hit/schus)*100)>100 then writeln('Wow! You got many ships with a double hit!');
     if (boni-1>10) and (boni-1<20) then writeln('Oh super! You was in a high level!');
     if boni-1>20 then writeln('Oh dear, you had cracked my wonderful game. I must hide the Variables');
     spiele_vocdatei('ende.voc',false);
     readln;
     halt;

    end;
   end;
  end;
    if keypressed then begin
    a:=readkey;
    if keydown[$39] then for qq:=1 to boni do begin
     if power2>10 then begin dec(power2,10);schuss(56);end;end;
    if keydown[$48] then if sprite[56].py>5 then dec(sprite[56].py,5);
    if keydown[$4B] then if sprite[56].px>5 then dec(sprite[56].px,5);
    if keydown[$4D] then if sprite[56].px<315 then inc(sprite[56].px,5);
    if keydown[$50] then if sprite[56].py<195 then inc(sprite[56].py,5);
    if keydown[$30] then bomb;
    if keydown[$0F] then
    begin
     spiele_vocdatei('ratch2.voc',false);
     if streu=true then begin
      missile:=false;streu:=false;
     end else begin
      if missile=true then begin streu:=true;missile:=false;end else missile:=true;
     end;
    end;
    end;
    if keypressed then begin
    a:=readkey;
    if keydown[$39] then for qq:=1 to boni div 2 do begin
    if power2>10 then begin dec(power2,10);schuss(56);end;end;
    if keydown[$48] then if sprite[56].py>5 then dec(sprite[56].py,5);
    if keydown[$4B] then if sprite[56].px>5 then dec(sprite[56].px,5);
    if keydown[$4D] then if sprite[56].px<315 then inc(sprite[56].px,5);
    if keydown[$50] then if sprite[56].py<195 then inc(sprite[56].py,5);
    if keydown[$30] then bomb;
    if keydown[$0F] then
    begin
     spiele_vocdatei('ratch2.voc',false);
     if streu=true then begin
      missile:=false;streu:=false;
     end else begin
      if missile=true then begin streu:=true;missile:=false;end else missile:=true;
     end;
    end;
    end;
   for c:=1 to leben do putsprite(24000,c*20+1,180,sprite[56]);
  if power1<500+(boni*100) then inc(power1,5);
  if power2<500+(boni*100) then inc(power2,5);
  if missile then begin
   for c:=1 to power1 div 30 do putsprite(24000,300,c*2,sprite[60]);
   for c:=1 to power2 div 30 do putsprite(24000,300,200-c*2,sprite[60]);
  end else begin
   for c:=1 to power1 div 20 do putsprite(24000,300,c,sprite[25]);
   for c:=1 to power2 div 20 do putsprite(24000,300,200-c,sprite[25]);end;
   for c:=1 to p div 5 do putsprite(24000,280,c,sprite[50]);
 until keydown[1];
 TextMode(3);
 textbackground(red);
 textcolor(green);
 writeln('Erreichtes Level: ',boni-1);
 writeln('Points: ',p*100);
 writeln('Anzahl abgefeuerter Schsse: ',schus);
 writeln('Anzahl getroffener  Schsse: ',hit);
 if schus>0 then begin
 writeln('Trefferquote: ',round((hit/schus)*100),' %');
 if round((hit/schus)*100)>100 then writeln('Wow! You got many ships with a double hit!');
 end else
 writeln('BUUU! You have NO Trefferquote! Play it again without press escape!');
 if (boni-1>10) and (boni-1<20) then writeln('Oh super! You was in a high level!');
 if boni>20 then writeln('Oh dear, you had cracked my wonderful game. I must hide the Variables');
 spiele_vocdatei('ende.voc',false);
readln;
End.
