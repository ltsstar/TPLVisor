// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  Parser

*)

unit TPLParser;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, StrUtils,  TPLErrors, TPLBefehle;
type
  TParser = class
  private
    FehlerMemo : TMemo;
    procedure KommentarZeilenEntferner(zeile : pstring);
    function Tokenizieren(zeile : pstring) : TStringList;
    function GetZustand(Zustand : string; Fehler : pstring) : integer;
    function GetBefehl(Befehl : string; Fehler : pstring) : CBefehl;
    function BefehlsZeilenParser(token : TStringList; Start : integer; Ende : integer) : string;
  public
    Befehle : array of TBefehl;
    constructor Create(FehlerMemo : TMemo);
    function Parse(Code : TStrings) : boolean;
  end;

implementation

{TParse}

constructor TParser.Create(FehlerMemo : TMemo);
begin
  self.FehlerMemo := FehlerMemo;
end;

// Entfernt Kommentare
procedure TParser.KommentarZeilenEntferner(zeile : pstring);
var
  i : integer;
  LetztesZeichenSlash : boolean;
begin
  LetztesZeichenSlash := False;
  for i:=1 to Length(zeile^)-1 do
  begin
    if (Zeile^[i] = '/') and (LetztesZeichenSlash = False) then
      LetztesZeichenSlash := True
    else if (Zeile^[i] = '/') and (LetztesZeichenSlash = True) then
    begin
      zeile^ := LeftStr(zeile^,i-2);
      break;
    end;
  end;
end;

function TParser.Tokenizieren(Zeile : pstring) : TStringList;
var
  Token : TStringList;
begin
  Token := TStringList.Create;
  Token.Delimiter := ' ';
  Token.DelimitedText := Zeile^;
  Result := Token;
end;

function TParser.GetZustand(Zustand : string; Fehler : pstring) : integer;
begin
  Try
    Result := strtoint(Zustand);
  Except
    Fehler^ := Format(ParserError.UngZustand, [Zustand]);
    Result := -1;
  End;
end;

(*
  Findet für den jeweiligen Befehlsnamen die passende Befehlsklasse.
  Sollte kein Befehl gefunden werden wird die Klasse "TBefehl"
  als dummy verwendet.
  Befehl : Befehlsnamen
  Fehler : Zeiger auf Fehlerstring
*)
function TParser.GetBefehl(Befehl : string; Fehler : pstring) : CBefehl;
var
  i : integer;
begin
  Result := TBefehl;
  for i:=0 to High(BefehlsListe) do
  begin
    if LowerCase(BefehlsListe[i].Name) = Befehl then
    begin
      Result := BefehlsListe[i].Befehl;
      break;
    end;
  end;
  if Result = TBefehl then
    Fehler^ := Format(ParserError.UngBefehl, [Befehl])
end;

(*
  Parst eine Befehlszeile.
  Arbeitet nach der Idee einer endlichen Maschine.
  Token : Tokenisierte Form der Zeile.
  Start : Startposition im Code.
  Ende  : Endposition im Code.
*)
function TParser.BefehlsZeilenParser(Token : TStringList; Start : integer; Ende : integer) : string;
type
  TStatus = (SNull, SZustand);
var
  Status : TStatus;
  Zustand : integer;
  Befehl : CBefehl;
  i : integer;
  Fehler : pstring;
begin
  New(Fehler);
  Status := SNull;
  Zustand := 0;
  while Token.Count > 0 do
  begin
    case Status of
      SNull :
      begin
        Zustand := self.GetZustand(Token[0], Fehler);
        Token.Delete(0);
        if Zustand < 0 then
          break;
        Status := SZustand;
      end;
      SZustand :
      begin
        Befehl := self.GetBefehl(Token[0], Fehler);
        Token.Delete(0);
        i := Length(self.Befehle)+1;
        SetLength(self.Befehle, i);
        self.Befehle[i-1] := Befehl.Create;
        
        self.Befehle[i-1].Zustand := Zustand;
        self.Befehle[i-1].Parameter := Token;
        self.Befehle[i-1].Fehler := Fehler;
        self.Befehle[i-1].Start := Start;  // Fuer spaetere markierungen
        self.Befehle[i-1].Ende := Ende;    //           -||-

        self.Befehle[i-1].Parsen();
        break;
      end;
    end;
  end;
  if Status = SNull then
    Fehler^ := ParserError.KeinBefehl;
  Result := Fehler^;
  Dispose(Fehler);
end;

(*
  Parst eine Codeingabe.
  code : Zeilen eines Codememos.
*)
function TParser.Parse(code : TStrings) : boolean;
var
  i : integer;
  Position : integer;
  Ende : integer;
  Zeile : pstring;
  Token : TStringList;
  Fehler : string;
begin
  position := 0;
  new(Zeile);
  Result := True;
  Fehler := '';
  for i:=0 to code.Count-1 do
  begin
    Ende := Position+Length(code[i]);
    Zeile^ := code[i];
    self.KommentarZeilenEntferner(Zeile);                       // Kommentare entfernen
    
    if Length(Zeile^) = 0 then
    begin
      position := Ende+2;
      Continue;
    end;

    Token := self.Tokenizieren(Zeile);                          // Tokenisieren
    Fehler := self.BefehlsZeilenParser(Token,Position,Ende);    // Befehle parsen

    if Length(Fehler) > 0 then
    begin
      self.FehlerMemo.Lines.add(Format(ParserError.InZeile+Fehler, [i+1]));
      Result := False;
    end;
    
    position := Ende+2;
  end;
  Dispose(Zeile);
end;



end.
