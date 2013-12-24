// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  In dieser Unit wird die Klasse TZeichen und TZeichenKette definiert.
  TZeichen enthält ein TShape und ein TEdit Objekt,
  ein TZeichenKette Objekt ist jeweils ein Glied in der Zeichenkette des Magnetbandes
  mit einem Zeiger auf das nächste und aus Performancegründen auch auf das vorherige Objekt.

  Da in Delphi/ObjektPascal Klassenvariabeln als TObject oder Pointer dargestellt werden
  muss an manchen stellen ein Cast durchgeführt werden, damit der Delphi 7 Parser/Compiler weiß,
  dass die Verwendung eines anderen Typs gewünscht ist.
*)


unit TPLZeichen;

interface
uses
  Classes,
  StdCtrls, // TEdit
  ExtCtrls, // TShape
  Dialogs,  // Show Message
  SysUtils; // Format

type
  TZeichen = class
    private
      Form : TObject;
    public
      ZShape : TShape;
      ZEdit : TEdit;
      procedure ZEditChange(Sender : TObject);
      procedure Anzeigen(Form : TObject; Left : integer);
  end;
  TZeichenKette = class
    Zeichen : TZeichen;
    // Vorheriges und Naechstes Element vom Typ TZeichenKette
    Vorheriges : TObject; // dient der Performance
    Naechstes : TObject;
    Constructor Create;
    Destructor Destroy; Reintroduce;
  end;

implementation

uses TPLVisorMain;

{ TZeichen }

(*
  Zeigt das Zeichenelement an einer bestimmten Position im Magnetbandpanel
  Form : TTPLVisorForm
  Left : Abstand vom linken Rand des Magnetfeldpanels.
*)
procedure TZeichen.Anzeigen(Form : TObject; Left : integer);
begin
  self.Form := Form;

  self.ZShape := TShape.Create(TTPLVisorForm(self.Form).Band);
  self.ZEdit := TEdit.Create(TTPLVisorForm(self.Form).Band);
  self.ZEdit.OnChange := self.ZEditChange;

  TTPLVisorForm(Form).CreateZeichen(self.ZShape, self.ZEdit, Left);
end;

(*
  Event, das beim ändern des TEdit Texts des Zeichens aufgerufen wird.

  Da das TEdit Objekt im Zeichen grundsätzlich beliebig beschrieben werden kann,
  muss sichergestellt werden, dass es maximal 1 Zeichen groß bleibt.
*)
procedure TZeichen.ZEditChange(Sender : TObject);
begin
  if Length(self.ZEdit.Text) > 1 then
    self.ZEdit.Text := self.ZEdit.Text[Length(self.ZEdit.Text)];
end;

{ TZeichenKette }

Constructor TZeichenKette.Create;
begin
  self.Zeichen := TZeichen.Create;
  self.Naechstes := nil;
  self.Vorheriges := nil;
end;

Destructor TZeichenKette.Destroy;
begin
  self.Zeichen.ZShape.Destroy;
  self.Zeichen.ZEdit.Destroy;
end;
end.
