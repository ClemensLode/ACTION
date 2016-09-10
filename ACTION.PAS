Uses Crt,dos,Gif,ModeXLib,Sprites,vocplay,tastatur,pcspeak;
Const Sprite_Anzahl=177;          {Anzahl im Programm verwendeter Sprites}

Var Sprite:Array[1..Sprite_Anzahl] of SpriteTyp;
    a:char;
    memm,filt:longint;
    f:text;
    zz:array[1..5] of spritetyp;
    xxzz,qq,zzz,p,z,ii,n,i:Word;                     {ZÑhler}
    abl,temp,taste,c:byte;
    endle,money,ship1le,ship2le,plus1,plus2,power1,power2,cheat,boni,bomben,leben:integer;
    pass:string;
    palette1,
    origpal,
    zielpal:Array[0..767] of Byte;
    buyMISstr,misstr,las,bew,sb,missile,buymis,streu,buystreu,buylaser:boolean;
    b,psn:char;
    schus,hit:longint;
procedure Spiele_Vocdatei(datname : string);
begin
if sb then begin
 Init_Voc(datname);
  repeat until voc_ready;
 voc_done;
 end;
end;
procedure destroy(zahl:byte);
begin
  putsprite(vpage,sprite[zahl].px,sprite[zahl].py-5,zz[1]);
  delay(100);
  putsprite(vpage,sprite[zahl].px,sprite[zahl].py-5,zz[2]);
  delay(100);
  putsprite(vpage,sprite[zahl].px,sprite[zahl].py-5,zz[3]);
  delay(100);
  sprite[zahl].le:=15;
end;
procedure hitem(zahl:byte);
begin
 dec(sprite[zahl].le);
 inc(hit);
 if (sprite[zahl].le<=0) or (sprite[zahl].le>15) then begin
  inc(p);
  if random(100)>98 then spiele_vocdatei('asta.voc');
  destroy(zahl);
  inc(money);
  sprite[zahl].py:=random(180)+1;sprite[zahl].le:=15;
  sprite[zahl].px:=300;
 end;
end;

Procedure PutPixel(x,y,col:word);assembler;
{setzt Punkt (x/y) auf Farbe col (Mode X)}
asm
  mov ax,0a000h                 {Segment laden}
  mov es,ax
  mov cx,x                      {Write Plane bestimmen}
  and cx,3                      {als x mov 4}
  mov ax,1
  shl ax,cl                     {entsprechendes Bit setzen}
  mov ah,al
  mov dx,03c4h                  {Timing Sequenzer}
  mov al,2                      {Register 2 - Write Plane Mask}
  out dx,ax
  mov ax,80                     {Offset = Y*80 + X div 4}
  mul y
  mov di,ax
  mov ax,x
  shr ax,2
  add di,ax                     {Offset laden}
  mov al,byte ptr col           {Farbe laden}
  mov es:[di],al                {und Punkt setzen}
End;
procedure laser(zahl:word);
var temp,temp2,temp3,temp4:word;
begin
if buylaser then begin
sound(1200);delay(2);nosound;
temp:=random(256);
temp3:=sprite[zahl].py+random(abl*4)-abl*2+4;
for temp:=sprite[zahl].px+4 to 319 do begin putpixel(temp,temp3,200);putpixel(temp,temp3-1,200);putpixel(temp,temp3+1,200);end;
if (temp3+80<sprite[150].py) and (temp3>sprite[150].py) then
begin
dec(endle);sound(120);delay(2);nosound;
if endle<=0 then begin
      putsprite(vpage,sprite[150].px,sprite[150].py,sprite[151]);
      delay(100);
inc(leben);endle:=boni*100 ;
      if p>(boni*20) then begin
       inc(leben);spiele_vocdatei('level.voc');
       inc(boni);inc(plus1,10);inc(plus2,10);
      end;
end;end;
for temp2:=82 to 96 do begin
if (sprite[temp2].py+10>temp3) and (sprite[temp2].py-5<temp3) then begin
sound(1000);delay(2);nosound;
hitem(temp2);
end; end;
end;
end;
procedure putship(y,x:word;temp:byte);
begin
 putsprite(24000,x,y,sprite[temp]);
end;

procedure bewegung(x:word);
begin
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
 sprite[80].py:=y;
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
 sprite[80].px:=x;
end;

procedure schuss(blubb:word);
var tempus,tempus2:byte;
begin
if (blubb>=82) and (blubb<=96) then begin
for tempus:=137 to 147 do begin
if sprite[tempus].ja=false then begin
    sound(1500);delay(4);nosound;
    sprite[tempus].ja:=true;
    sprite[tempus].px:=sprite[blubb].px-7;
    sprite[tempus].py:=sprite[blubb].py-1;
    if (sprite[tempus].py<1) or (sprite[tempus].py>200) then sprite[tempus].ja:=fAlse;
    exit;
    end;
    end;
    exit;
    end;
  if misstr then begin
   for tempus:=97 to 136 do begin
    if sprite[tempus].ja=false then begin
     sound(410);delay(2);nosound; inc(schus);
     if random(100)>50 then sprite[tempus].sy:=abl else sprite[tempus].sy:=-abl;
     sprite[tempus].ja:=true;
     sprite[tempus].px:=sprite[blubb].px-17;
     sprite[tempus].py:=sprite[blubb].py+1;
     if (sprite[tempus].py<3) or (sprite[tempus].py>197) then sprite[tempus].ja:=fAlse;
     for tempus2:=1 to 79 do begin
     if sprite[tempus2].ja=false then begin
      sound(410);delay(2);nosound;
      inc(schus);
      sprite[tempus2].ja:=true;
      sprite[tempus2].px:=sprite[blubb].px-7;
      if streu then sprite[tempus2].py:=sprite[blubb].py+random(abl*8)-abl*4 else sprite[tempus2].py:=sprite[blubb].py+1;
      if (sprite[tempus2].py<1) or (sprite[tempus2].py>200) then sprite[tempus2].ja:=fAlse;
      exit;
     end;
     end;
     exit;
     end;end;
     end;
     if las then begin
    laser(blubb);exit;end;
if missile=false then begin
    for tempus:=1 to 79 do begin
     if sprite[tempus].ja=false then begin
      sound(410);delay(2);nosound;
      inc(schus);
      sprite[tempus].ja:=true;
      sprite[tempus].px:=sprite[blubb].px-7;
      if streu then sprite[tempus].py:=sprite[blubb].py+random(abl*8)-abl*4 else sprite[tempus].py:=sprite[blubb].py+1;
      if (sprite[tempus].py<1) or (sprite[tempus].py>200) then sprite[tempus].ja:=fAlse;
      exit;
     end;
    end;
   end else begin
    for tempus:=97 to 136 do begin
     if sprite[tempus].ja=false then begin
      sound(410);delay(2);nosound; inc(schus);
if random(100)>50 then sprite[tempus].sy:=abl else sprite[tempus].sy:=-abl;
      sprite[tempus].ja:=true;
      sprite[tempus].px:=sprite[blubb].px-17;
      sprite[tempus].py:=sprite[blubb].py+1;
      if (sprite[tempus].py<3) or (sprite[tempus].py>197) then sprite[tempus].ja:=fAlse;
      exit;
     end;
    end;
   end;
  end;
 {end;}
procedure gegner;
begin
 for ii:=82 to 96 do begin
  if random(1000)>990 then schuss(ii);
  if sprite[ii].le>15 then sprite[ii].le:=15;
  dec(sprite[ii].px,boni div 2);
  case ii of
  90..92:if sprite[ii].py>sprite[80].py then dec(sprite[ii].py) else inc(sprite[ii].py);
  93..95:if sprite[ii].py>sprite[81].py then dec(sprite[ii].py) else inc(sprite[ii].py);
  end;
  putsprite(24000,sprite[ii].px,sprite[ii].py,sprite[ii]);
  if sprite[ii].px<=1 then begin
   sprite[ii].py:=random(180)+1;sprite[ii].px:=310;sprite[ii].le:=15;
  end;
 end;
end;
procedure bomb;
var q:integer;
begin
 if bomben>=1 then begin
  dec(bomben);
  Spiele_Vocdatei('volled.voc');
  Spiele_Vocdatei('bombe.voc');
  GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
  Move(Palette,OrigPal,768);    {Palette sichern}
  for q:=1 to 767 do palette1[q]:=random(256);
  Move(Palette1,Zielpal,768);    {Ziel-Palette bestimmen}
  delay(200);
  Make_bw(ZielPal);             {ZielPal auf schwarz/wei· ziehen}
  delay(200);
  fade_to(ZielPal,1);           {schwarz/wei·e Palette einblenden}
  delay(200);
  fade_to(OrigPal,1);           {Original-Palette einblenden}
  delay(200);
  for q:=82 to 96 do begin
   sprite[q].px:=300;
   sprite[q].py:=random(180);
  end;
  inc(p,7);
 end;
end;
procedure zeichnesonstiges;
begin
 for c:=1 to leben do putsprite(24000,c*20+1,180,sprite[81]);
 if missile then begin
  for c:=1 to power1 div 30 do putsprite(24000,300,c*2,sprite[135]);
  for c:=1 to power2 div 30 do putsprite(24000,300,200-c*2,sprite[135]);
 end else begin
  for c:=1 to power1 div 20 do putsprite(24000,300,c,sprite[25]);
  for c:=1 to power2 div 20 do putsprite(24000,300,200-c,sprite[25]);
 end;
 for c:=1 to p div 5 do putsprite(24000,280,c,sprite[81]);
 for c:=1 to ship1le do putsprite(24000,10,c*3,sprite[148]);
 for c:=1 to ship2le do putsprite(24000,20,c*3,sprite[148]);
 if MONEY>30 then putsprite(24000,100,180,sprite[100]);
 if MONEY>100 then putsprite(24000,120,180,sprite[2]);
 if MONEY>200 then begin for xxzz:=1 to 10 do putpixel(140+xxzz,183,200);end;
 if MONEY>250 then begin putsprite(24000,160,170,sprite[2]);putsprite(24000,160,180,sprite[100]);end;
end;
procedure tastat;
begin
 bew:=false;
 if keypressed then b:=readkey;
 if keypressed then b:=readkey;
 if keydown[$1D] then for qq:=1 to boni div 2 do begin
 if power2>10 then begin dec(power2,10);schuss(81);end;end;
 if keydown[$02] then if money>=40 then begin if buymis=false then begin spiele_vocdatei('kirche.voc');dec(money,40);
 buymis:=true;end;end;
 if keydown[$03] then if money>=100 then begin if buystreu=false then begin spiele_vocdatei('kirche.voc');dec(money,100);
 buystreu:=true;end;end;
 if keydown[$04] then if money>=200 then begin if buylaser=false then begin spiele_vocdatei('kirche.voc');dec(money,200);
 buylaser:=true;end;end;
 if keydown[$05] then if money>=250 then begin if buymisstr=false then begin spiele_vocdatei('kirche.voc');dec(money,250);
 buymisstr:=true;end;end;
 if keydown[$48] then if sprite[81].py>5 then begin dec(sprite[81].py,5);bew:=true;end;
 if keydown[$4B] then if sprite[81].px>5 then dec(sprite[81].px,5);
 if keydown[$4D] then if sprite[81].px<315 then inc(sprite[81].px,5);
 if keydown[$50] then if sprite[81].py<195 then begin inc(sprite[81].py,5);bew:=true;end;
 if keydown[$30] then bomb;
 if keydown[$3B] then begin streu:=false;las:=false;missile:=false;end;
 if keydown[$3C] then if buystreu then begin streu:=true;las:=false;missile:=false;end;
 if keydown[$3D] then if buymis then begin streu:=false;las:=false;missile:=true;end;
 if keydown[$3E] then if buylaser then begin streu:=false;las:=true;missile:=false;end;
 if keydown[$3F] then if buymisstr then begin streu:=false;las:=false;misstr:=true;missile:=false;end;
 if keydown[$48] then if sprite[81].py>5 then begin dec(sprite[81].py,5);bew:=true;end;
 if keydown[$4B] then if sprite[81].px>5 then dec(sprite[81].px,5);
 if keydown[$4D] then if sprite[81].px<315 then inc(sprite[81].px,5);
 if keydown[$50] then if sprite[81].py<195 then begin inc(sprite[81].py,5);bew:=true;end;
 if keydown[$30] then bomb;
 if keydown[$4A] then begin if abl>0 then dec(abl);end;
 if keydown[$4E] then begin if abl<20 then inc(abl);end;
end;
procedure missil;
begin
 for i:=97 to 135 do begin
  if sprite[i].ja=true then begin
   inc(sprite[i].px,10);
   inc(sprite[i].py,sprite[i].sy);
   if sprite[i].px>=315 then sprite[i].ja:=false;
   if sprite[i].py>=199-abl then sprite[i].ja:=false;
   if sprite[i].py<=1+abl then sprite[i].ja:=false;
   putsprite(24000,sprite[i].px,sprite[i].py,sprite[i]);
   for ii:=82 to 96 do begin
    if sprite[ii].px<=1 then begin
     sprite[ii].py:=random(180)+1;
     sprite[ii].px:=310;
    end;
    if (sprite[i].px<=sprite[ii].px+10) and (sprite[i].py<=sprite[ii].py+10) and (sprite[i].px>=sprite[ii].px-10)
    and (sprite[i].py>=sprite[ii].py-10) then begin
     sprite[i].ja:=false;
      hitem(ii);
    end;
   end;
  end;
 end;
end;
procedure normal;
begin
 for i:=1 to 79 do begin
  if sprite[i].ja=true then begin
   inc(sprite[i].px,10);
   if sprite[i].px>=320 then begin sprite[i].ja:=false;exit;end;
   putsprite(24000,sprite[i].px,sprite[i].py,sprite[i]);

   for ii:=82 to 96 do begin
    if (sprite[i].px<=sprite[ii].px+10) and (sprite[i].py<=sprite[ii].py+10) and (sprite[i].px>=sprite[ii].px-10)
    and (sprite[i].py>=sprite[ii].py-10) then begin
     sprite[i].ja:=false;
     hitem(ii);
     exit;
    end;
   end;
   if (sprite[i].px<=sprite[150].px+140) and (sprite[i].py<=sprite[150].py+140) and (sprite[i].px>=sprite[150].px)
   and (sprite[i].py>=sprite[150].py) then begin
    sound(920);delay(3);nosound;
    dec(endle);sprite[i].ja:=false;
    if endle<=0 then begin
     putsprite(vpage,sprite[150].px,sprite[150].py+50,sprite[151]);
     delay(100);inc(bomben);bomb;
     if p>(boni*20) then begin
      inc(leben);spiele_vocdatei('level.voc');
      inc(boni);inc(plus1,10);inc(plus2,10);
     end;
     endle:=1000;
    end;
   end;
 end;
end;
end;
Procedure PutPix(x,y,col:word);assembler;
{setzt Punkt (x/y) auf Farbe col (Mode X)}
asm
  mov ax,0a000h                 {Segment laden}
  mov es,ax

  mov cx,x                      {Write Plane bestimmen}
  and cx,3                      {als x mov 4}
  mov ax,1
  shl ax,cl                     {entsprechendes Bit setzen}
  mov ah,al
  mov dx,03c4h                  {Timing Sequenzer}
  mov al,2                      {Register 2 - Write Plane Mask}
  out dx,ax

  mov ax,80                     {Offset = Y*80 + X div 4}
  mul y
  mov di,ax
  mov ax,x
  shr ax,2
  add di,ax                     {Offset laden}
  mov al,byte ptr col           {Farbe laden}
  mov es:[di+24000],al                {und Punkt setzen}
End;
Var Sternle:Array[0..500] of Record
                              x,y,Ebene:Integer;
                            End;
  st_nr:Word;
procedure sterne;
begin
    For St_nr:=0 to 500 do Begin{fÅr jeden Stern neue Posit. berechnen}
      With Sternle[st_nr] do Begin
        PutPix(x,y,0);        {alten Punkt lîschen}
        Dec(x,Ebene shr 5 + 1); {weiterbewegen}
        if x <= 0 Then Begin    {links raus ?}
          x:=319;               {dann neu initialisieren}
          y:=Random(200);
          Ebene:=Random(256);
        End;
        PutPix(x,y,Ebene shr 4 + 16);  {neuen Punkt setzen}
    End;
end;
end;
var j:word;
Procedure Fade_in(ZPal:Array of Byte);
Begin
  For j:=0 to 63 do Begin       {64 DurchlÑufe, um komplett zu faden}
    For i:=0 to 767 do          {768 Farbwerte berechnen}
      If Palette[i] < ZPal[i]   {aktueller Wert noch kleiner als Zielwert ?}
        Then Inc(Palette[i]);   {dann erhîhen}
    WaitRetrace;                {Synchronisation}
    SetPal;                     {berechnete Palette setzen}
  End;
End;
Begin
 chdir('c:\pcunder\grafik');
 p:=0;
 endle:=1000;
 money:=600;
 buylaser:=false;
 las:=false;
 port[$60]:=$F3;
 port[$60]:=$1F;
 ship1le:=20;
 ship2le:=20;abl:=5;
 plus1:=5;plus2:=5;
 boni:=2;
 streu:=true;
 bomben:=3;
 textbackground(blue);
 textcolor(green);
 clrscr;
 writeln('Allgemein: Waffe wechseln mit <F1>,<F2>,<F3>,<F4>. Bombe mit B.');
 writeln('           Waffe kaufen mit <1>,<2>,<3>,<4>.');
 writeln('Player 1 : Steuerung mit Maus. Schuss mit Maustaste.');
 writeln('Player 2 : Steuerung mit Pfeiltasten. Schuss mit <Strg>');
 write('Soundblaster oder nix [S,N]:');readln(psn);
 sb:=false;
 if upcase(psn)=('S') then begin
 writeln('Initialisiere Soundblaster ...');
 Init_SB;
 delay(1333);
 sb:=true;
 spiele_vocdatei('voc3.voc');
 end;
 write('Enter Password: ');
 spiele_vocdatei('voc2.voc');
 repeat
 if keypressed then readkey;
 until (keydown[$2E] and keydown[$26] and keydown[$1F]);
 writeln('OK. Let''s Start!!!');
 spiele_vocdatei('voc5.voc');
 spiele_vocdatei('enter.voc');
 readln;
 leben:=3;
 randomize;
 Init_ModeX;                   {Mode X einschalten}
 LoadGif('action!');            {Zeichensatz laden}
 GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
 Move(Palette,Zielpal,768);    {Palette sichern}
 FillChar(Palette,768,0);      {alte Palette lîschen}
 SetPal;                       {und setzen}
 p13_2_ModeX(vpage,16000);     {und auf Seite 3 kopieren}
 fade_in(Zielpal);             {Bild auf Zielpal (originale Palette) faden}
 spiele_vocdatei('intro.voc');
 LoadGif('warten');            {Zeichensatz laden}
 p13_2_ModeX(vpage,16000);     {und auf Seite 3 kopieren}

power1:=500;power2:=500;
 {LoadGif('back');             {Hintergrundbild laden}
 {p13_2_ModeX(vpage,24000);     {und auf Hintergrundseite kopieren}

 LoadGif('actions4');           {Bild mit den drei Sprites laden}
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
 GetSprite(1+3*320,11,6,Sprite[40]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[41]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[42]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[43]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[44]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[45]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[46]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[47]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[48]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[49]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[50]);
 GetSprite(1+3*320,11,6,Sprite[51]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[52]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[53]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[54]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[55]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[56]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[57]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[58]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[59]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[60]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[61]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[62]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[63]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[64]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[65]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[66]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[67]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[68]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[69]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[70]);
 GetSprite(1+3*320,11,6,Sprite[71]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[72]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[73]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[74]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[75]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(1+3*320,11,6,Sprite[76]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[77]); {(203/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[78]); {(133/114), 58*48}
 GetSprite(1+3*320,11,6,Sprite[79]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(18+2*320,11,9,Sprite[80]); {(203/114), 58*48}
 GetSprite(18+2*320,11,9,Sprite[81]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[82]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[83]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[84]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[85]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[86]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[87]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[88]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[89]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[90]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[91]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[92]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[93]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[94]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[95]); {(203/114), 58*48}
 GetSprite(18+2*320,11,9,Sprite[96]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[97]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[98]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[99]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[100]);
 GetSprite(28+37*320,9,3,Sprite[101]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[102]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[103]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[104]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[105]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[106]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[107]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[108]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[109]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[110]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[111]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[112]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[113]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[114]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[115]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[116]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[117]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[118]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[119]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[120]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[121]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[122]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[123]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[124]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[125]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[126]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[127]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[130]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[131]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[132]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[133]); {(133/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[134]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(28+37*320,9,3,Sprite[135]); {(203/114), 58*48}
 GetSprite(28+37*320,9,3,Sprite[136]); {(203/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[137]); {(203/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[138]); {(133/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[139]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(30+19*320,13,5,Sprite[140]);
 GetSprite(30+19*320,13,5,Sprite[141]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(30+19*320,13,5,Sprite[142]); {(203/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[143]); {(203/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[144]); {(133/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[145]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(30+19*320,13,5,Sprite[146]); {(203/114), 58*48}
 GetSprite(30+19*320,13,5,Sprite[147]); {(203/114), 58*48}
 GetSprite(33+1*320,7,3,Sprite[148]); {(203/114), 58*48}
 GetSprite(49+4*320,12,7,Sprite[149]); {(203/114), 58*48}
 GetSprite(7+31*320,11,14,zz[1]);  {Koordinaten (62/114), Breite 58*48}
 GetSprite(6+49*320,10,14,zz[2]); {(203/114), 58*48}
 GetSprite(5+71*320,14,15,zz[3]); {(203/114), 58*48}
 GetSprite(5+71*320,14,15,zz[4]); {(133/114), 58*48}
 GetSprite(5+93*320,11,8,zz[5]);  {Koordinaten (62/114), Breite 58*48}
 LoadGif('endgeg');           {Bild mit den drei Sprites laden}
 GetSprite(145+38*320,145,81,Sprite[150]); {(203/114), 58*48}
 GetSprite(9+52*320,73,57,Sprite[151]); {(203/114), 58*48}

 asm
  mov ax,0;
  int $33;
 end;
 for i:=1 to 79 do sprite[i].ja:=false;
 for i:=82 to 96 do begin
  sprite[i].px:=random(100)+120;
  sprite[i].le:=15;sprite[i].py:=random(200);
 end;
 for i:=97 to 136 do sprite[i].ja:=false;
 c:=0;
 streu:=false;
 sprite[150].sx:=1;
 sprite[150].py:=100;
 sprite[150].px:=160;
 sprite[150].sy:=-1;
 spiele_vocdatei('gong.voc');
 repeat
  sterne;
  inc(sprite[150].px,sprite[150].sx);
  inc(sprite[150].py,sprite[150].sy);
if (sprite[150].px>=200) or (sprite[150].px<=0) then sprite[150].sx:=-sprite[150].sx;
if (sprite[150].py>=100)  or (sprite[150].py<=0)then sprite[150].sy:=-sprite[150].sy;
  putsprite(28000,sprite[150].px,sprite[150].py,sprite[150]);
  if random(10000)>9995 then spiele_vocdatei('plapper.voc');
  WaitRetrace;                {Bildschirm darf erst nach nÑchstem Retrace}
  CopyScreen(vpage,24000);     {Hintergrundbild auf aktuelle Seite}
  copyscreen(24000,48000);
  zeichnesonstiges;
  putship(mausy,MAUSX,80);
  if bew then putsprite(24000,sprite[81].px,sprite[81].py,sprite[149]) else putship(sprite[81].py,sprite[81].px,81);
  if mauspressed=1 then begin
   for qq:=2 to boni do begin
    if power1>10 then begin dec(power1,10);schuss(80);end;
   end;
  end;
  normal;
  missil;
  gegner;
  tastat;
  if power1<500+(boni*100) then inc(power1,plus1);
  if power2<500+(boni*100) then inc(power2,plus2);
   for c:=138 to 146 do begin
   if sprite[c].ja then begin
    if sprite[c].px<5 then sprite[c].ja:=false;dec(sprite[c].px,1);
    putsprite(24000,sprite[c].px,sprite[c].py,sprite[138]);
    if (sprite[c].px<=sprite[81].px+10) and (sprite[c].py<=sprite[81].py+10) and (sprite[i].px>=sprite[81].px-10)
    and (sprite[c].py>=sprite[81].py-10) then begin dec(ship2le);sprite[c].ja:=false;end;
    if (sprite[c].px<=sprite[80].px+10) and (sprite[c].py<=sprite[80].py+10) and (sprite[i].px>=sprite[80].px-10)
    and (sprite[c].py>=sprite[80].py-10) then begin dec(ship1le);sprite[c].ja:=false;end;
   end;
  end;
  for c:=82 to 96 do begin
    if ((sprite[c].px<=sprite[81].px+20) and (sprite[c].py<=sprite[81].py+20) and (sprite[i].px>=sprite[81].px-10)
    and (sprite[c].py>=sprite[81].py-10)) then begin dec(ship2le);hitem(c);end;
    if ((sprite[c].px<=sprite[80].px+20) and (sprite[c].py<=sprite[80].py+20) and (sprite[i].px>=sprite[80].px-10)
    and (sprite[c].py>=sprite[80].py-10)) then begin dec(ship1le);hitem(c);end;
  end;
 if ship1le<=0 then begin ship1le:=20;dec(leben);end;
 if ship2le<=0 then begin ship2le:=20;dec(leben);end;
until (keydown[1]) or (leben<=0);
 nosound;
 TextMode(3);
 textbackground(red);
 textcolor(green);
 writeln('Erreichtes Level: ',boni-1);
 writeln('Points: ',p*100);
 writeln('Anzahl abgefeuerter SchÅsse: ',schus);
 writeln('Anzahl getroffener  SchÅsse: ',hit);
 if schus>0 then begin
 writeln('Trefferquote: ',round((hit/schus)*100),' %');
 if round((hit/schus)*100)>100 then begin writeln('Wow! You got many ships with a double hit!');Spiele_Vocdatei('flalles.voc');
 end;
 end else begin
 writeln('BUUU! You have NO Trefferquote! Play it again without press escape!');Spiele_Vocdatei('hehehe.voc');end;
 if (boni-1>10) and (boni-1<20) then begin writeln('Oh super! You was in a high level!');Spiele_Vocdatei('super.voc');end;
 if boni>20 then begin writeln('Oh dear, you had cracked my wonderful game. I must hide the Variables');
 Spiele_Vocdatei('fatality.voc');end;
 spiele_vocdatei('ende.voc');
 readln;
 spiele_vocdatei('complete.voc');
 write('Deinstalliere TemporÑre Daten ...');
 assign(f,'voc3.voc');reset(f);
 if sb then init_voc('zwichen.voc');
 for filt:=1 to 100000 do begin gotoxy(1,20);write(filt div 1000,'%    ');end;
 repeat
 if sb then begin if voc_ready then begin voc_done;init_voc('zwichen.voc');end;end;
 until keypressed;
 if sb then voc_done;
 spiele_vocdatei('stored.voc');
  clrscr;
End.
