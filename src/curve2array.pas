uses strutils;

const delims = [' ', ')'];
var f, fout : textfile;

procedure openfile(name : string);

begin
assign (f, name);
reset(f);
assign(fout, name + '.pas');
rewrite(fout);
end;

procedure myreadln(var f: textfile; var str: ansistring); //need this because of readln buffer limit
var ch : char;
   eol : boolean;
begin
  eol := false;
  repeat
  read (f, ch);
  if (ch = #13) or (ch = #10) then begin
     eol := true
  end
  else
   begin
    str := str + ch;
   end;
  until eol;
end;

procedure dumparray(var f, fout: textfile; arrayname: string);
var s, s1: ansistring;
  i, j : integer;

begin
  myreadln (f, s);

     //writeln (fout, 'const ' + ParamStr(1) + arrayname + 'Curve : array [0..255] of real = ');
     writeln (fout, 'const ' + ParamStr(1) + arrayname + 'Curve : filmCurve = ');
     write (fout, '( '); 
  i := 3; //wordnum
  j := 0;
  repeat
    s1 := strutils.ExtractWord(i, s, delims);
    write (fout, s1);
	if j <> 255 then begin
	   write (fout, ', ');
	   if j mod 5 = 0 then writeln (fout, '');
	end
   else
	begin
	  writeln (fout, ');'); writeln (fout, '');
	end;
	write (j); writeln (' ' + s1);
	inc (i); inc(j);
  until j = 256;


end;

procedure expect(var f: textfile; str : string);
var s: string;
begin
  repeat
    readln (f, s);
  until s=str; 
 
end;

procedure parse;
var
  s, s1 : ansistring;
begin
 expect(f, '(channel red)');
 expect(f, '    (n-samples 256)');
 dumparray(f, fout, 'Red');

 expect(f, '    (n-samples 256)');
 dumparray(f, fout, 'Green');

 expect(f, '    (n-samples 256)');
 dumparray(f, fout, 'Blue');

 expect(f, '    (n-samples 256)');
 dumparray(f, fout, 'Alpha');


end; //parse

procedure closeall;
begin
flush(fout);
close(f);
close(fout);
end;

begin
writeln ('opening ', ParamStr(1));
  openfile (ParamStr(1));
  parse;
  closeall;
end.
