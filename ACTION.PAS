Uses Crt,dos,Gif,ModeXLib,Sprites,enh256;

Const Sprite_Anzahl=50;          {Anzahl im Programm verwendeter Sprites}

Var Sprite:Array[1..Sprite_Anzahl] of SpriteTyp;
    p,z,ii,n,i:Word;                     {Z„hler}
    c:byte;
    bomben,leben:integer;
    palette1,
    origpal,
    zielpal:Array[0..767] of Byte;
    back,streu:boolean;
    a:char;
    tastx,tasty:integer;
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
var g:registers;
temp:word;
begin
g.ax:=3;
intr($33,g);
temp:=g.dx;
if temp>192 then temp:=190;
if temp<1 then temp:=4;
mausy:=temp;
end;


function mausx:word;
var g:registers;
temp:word;
begin
g.ax:=3;
intr($33,g);
temp:=g.cx;
if temp>312 then temp:=310;
if temp<1 then temp:=4;
mausx:=temp;
end;
{procedure putmaus(y:word);
begin
if (y>200) then y:=200;
if (y<1) then y:=1;
sprite[11].py:=y;
PutSprite(vpage,30,sprite[11].py,Sprite[11]);
end;}

procedure schuss;
begin
if back=false then begin
for i:=1 to 19 do begin
if sprite[i].ja=false then begin
sprite[i].ja:=true;
sprite[i].px:=tastx-7;
if streu then sprite[i].py:=tasty+random(40)-20 else sprite[i].py:=tasty+1;
sound(600);delay(10);nosound;
exit;
end;
end;
end else begin
for i:=28 to 44 do begin
if sprite[i].ja=false then begin
sprite[i].ja:=true;
sprite[i].px:=tastx-7;
sprite[i].py:=tasty+1;
sound(400);delay(10);nosound;
exit;
end;
end;
end;end;
procedure bomb;
var q:integer;
begin
if bomben>=1 then begin
  dec(bomben);
  GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
  Move(Palette,OrigPal,768);    {Palette sichern}
  for q:=1 to 767 do
  palette1[q]:=random(256);
  Move(Palette1,Zielpal,768);    {Ziel-Palette bestimmen}
  Make_bw(ZielPal);             {ZielPal auf schwarz/weiá ziehen}
  fade_to(ZielPal,1);           {schwarz/weiáe Palette einblenden}
  fade_to(OrigPal,1);           {Original-Palette einblenden}
for q:=21 to 35 do begin
sprite[q].px:=300;
sprite[q].py:=random(180);end;inc(p,7);
end;end;
Begin
  bomben:=3;
  writeln('Steuerung mit Maus. Schuss mit Maustaste. Ende mit bel. Taste');
  readln;
  leben:=3;
  randomize;
  Init_ModeX;                   {Mode X einschalten}
    LoadGif('install');             {Hintergrundbild laden}
  p13_2_ModeX(vpage,24000);     {und auf Hintergrundseite kopieren}
chdir('c:\pcunder\grafik');
  LoadGif('ships3');           {Bild mit den drei Sprites laden}
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
  GetSprite(18+2*320,11,9,Sprite[20]); {(203/114), 58*48}
  {GetSprite(7+17*320,13,9,Sprite[13]); {(203/114), 58*48}
  GetSprite(18+2*320,11,9,Sprite[21]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[22]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[23]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[24]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[25]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[26]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[27]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[28]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[29]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[30]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[31]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[32]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[33]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[34]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[35]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[36]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[37]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[38]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[39]); {(203/114), 58*48}
 GetSprite(7+17*320,13,9,Sprite[30]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[31]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[32]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[33]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[34]); {(203/114), 58*48}
  GetSprite(7+17*320,13,9,Sprite[35]); {(203/114), 58*48}

 GetSprite(30+19*320,12,14,Sprite[36]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[37]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[38]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[39]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[40]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[41]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[42]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[43]); {(203/114), 58*48}
 GetSprite(30+19*320,12,14,Sprite[44]); {(203/114), 58*48}

asm
mov ax,0;
int $33;
end;
 for i:=1 to 19 do sprite[i].ja:=false;
 for i:=36 to 44 do sprite[i].ja:=false;
 for i:=21 to 35 do begin sprite[i].px:=200;sprite[i].py:=100;end;
 c:=0;
 streu:=false;
 repeat
  WaitRetrace;                {Bildschirm darf erst nach n„chstem Retrace}
  CopyScreen(vpage,24000);     {Hintergrundbild auf aktuelle Seite}
  copyscreen(24000,48000);
  putship(tasty,tastX,20);
  {if mauspressed=1 then schuss;
  if mauspressed=2 then begin
  if back then back:=false;
  if streu then begin
  streu:=false;back:=true;end else streu:=true;
  end;}

  for i:=1 to 19 do begin
  if sprite[i].ja=true then begin
inc(sprite[i].px,10);
if sprite[i].px>=320 then sprite[i].ja:=false;
  putsprite(24000,sprite[i].px,sprite[i].py,sprite[i]);
  for ii:=21 to 35 do begin
if sprite[ii].px<=1 then begin sprite[ii].py:=random(180)+1;sprite[ii].px:=310;end;
if (sprite[i].px<=sprite[ii].px+10) and (sprite[i].py<=sprite[ii].py+10) and (sprite[i].px>=sprite[ii].px-10)
  and (sprite[i].py>=sprite[ii].py-10) then begin
  sound(700);delay(20);nosound;inc(p);sprite[i].ja:=false;sprite[ii].py:=random(180)+1;sprite[ii].px:=300;end;
  end;end;end;
  for i:=36 to 44 do begin
  if sprite[i].ja=true then begin
dec(sprite[i].px,20);
if sprite[i].px<=5 then sprite[i].ja:=false;
  putsprite(24000,sprite[i].px,sprite[i].py,sprite[i]);
  for ii:=21 to 35 do begin
if (sprite[i].px<=sprite[ii].px+10) and (sprite[i].py<=sprite[ii].py+10) and (sprite[i].px>=sprite[ii].px-10)
  and (sprite[i].py>=sprite[ii].py-10) then begin
  sound(700);delay(20);nosound;inc(p);sprite[i].ja:=false;sprite[ii].py:=random(180)+1;sprite[ii].px:=300;end;
  end;end;end;
{if (sprite[ii].px<=sprite[13].px+10) and (sprite[ii].py<=sprite[13].py+10) and (sprite[ii].px>=sprite[13].px-10)
  and (sprite[ii].py>=sprite[13].py-10) then begin}
  for ii:=21 to 35 do begin
{ if (sprite[ii].px=sprite[13].px) and (sprite[ii].py=sprite[13].py) then begin
sound(500);delay(100);nosound;sprite[13].px:=1;sprite[13].py:=100;dec(leben);
if leben<=0 then begin
textmode(3);halt;end;end;}
 dec(sprite[ii].px);
    putsprite(24000,sprite[ii].px,sprite[ii].py,sprite[ii]);
  if sprite[ii].px<=5 then begin
  dec(leben);sprite[ii].py:=random(180)+1;sprite[ii].px:=310;if leben<1 then begin
  for z:=15000 downto 0 do
  sound(z);nosound;
textmode(3);writeln('Points: ',p*100);readlN;halt;end;end;
  end;
  if keypressed then begin
  a:=readkey;
  if upcase(a)=('B') then bomb;
  case a of
  #75:if tastx>1 then dec(tastx,10);
  #77:if tastx<320 then inc(tastx,10);
  #80:if tasty<200 then inc(tasty,10);
  #72:if tasty>1 then dec(tasty,10);
  #32:schuss;
  end;
  end;
  until a=#27;

nosound;

  port[$60]:=$f5;port[$60]:=$f4;
  TextMode(3);
  writeln('POINTS: ',p*100);readlN;
End.
