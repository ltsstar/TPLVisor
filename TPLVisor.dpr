program TPLVisor;

uses
  Forms,
  interpreter in 'interpreter.pas',
  befehle in 'befehle.pas',
  parsererrors in 'parsererrors.pas',
  parser in 'parser.pas',
  TPLVisorMain in 'TPLVisorMain.pas' {TPLVisorForm},
  turingmaschine in 'turingmaschine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTPLVisorForm, TPLVisorForm);
  Application.Run;
end.
