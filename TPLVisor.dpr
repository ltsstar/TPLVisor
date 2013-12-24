program TPLVisor;

uses
  Forms,
  TPLInterpreter in 'TPLInterpreter.pas',
  TPLBefehle in 'TPLBefehle.pas',
  TPLErrors in 'TPLErrors.pas',
  TPLParser in 'TPLParser.pas',
  TPLTuringmaschine in 'TPLTuringmaschine.pas',
  TPLMagnetband in 'TPLMagnetband.pas',
  TPLZeichen in 'TPLZeichen.pas',
  TPLVisorMain in 'TPLVisorMain.pas' {TPLVisorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTPLVisorForm, TPLVisorForm);
  Application.Run;
end.
