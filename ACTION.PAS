uses keys,crt,dos,vesa;
type
xyz=record
x:integer;
y:integer;
z:integer;
end;
var
a:char;r,c,i:byte;
s:array[0..30] of xyz;
ship:xyz;
schu:byte;
procedure weiter;
begin
for i:=30 downto 1 do begin
s[i].z:=0;if s[i].y>0 then begin
dec(s[i].y);putpix(s[i].x,s[i].y+1,0);end;
if s[i].y=0 then s[i].y:=0 else putpix(s[i].x,s[i].y,14);
end;
end;
procedure schuss;
begin
for i:=30 downto 1 do begin
if s[i].y=0 then begin
s[i].y:=ship.y-1;
s[i].x:=ship.x;
s[i].z:=14;
end;end;end;
procedure shi;
begin
c:=getpix(ship.x,ship.y);
putpix(ship.x,ship.y,10);
{ase r of
0:begin}putpix(ship.x+10,ship.y,0);
putpix(ship.x-10,ship.y,0);
putpix(ship.x,ship.y+10,0);
putpix(ship.x,ship.y-10,0);

{:putpix(ship.x+1,ship.y,c);
2:putpix(ship.x-1,ship.y,c);
3:putpix(ship.x,ship.y+1,c);
4:putpix(ship.x,ship.y-1,c);end;}end;
begin
c:=0;
ship.x:=400;ship.y:=300;
initvesa($103);
repeat
if keypressed then begin
a:=readkey;if a=#0 then a:=readkey;
if a=#13 {(BYTE(Ptr(Seg0040, $18)^) AND $01 = $01)} then schuss;
if a<>#0 then begin
case a of
#75:if ship.x>10 then begin r:=1;dec(ship.x,10);shi;end;
#77:if ship.x<790 then begin r:=2;inc(ship.x,10);shi;end;
#72:if ship.y>10 then begin r:=3;dec(ship.y,10);shi;end;
#80:if ship.y<590 then begin r:=4;inc(ship.y,10);shi;end;
end;
end;
end;
weiter;
delay(10);
until a=#27;
close;
end.
