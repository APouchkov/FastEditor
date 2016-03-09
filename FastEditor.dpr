program FastEditor;

uses
  Vcl.Forms,
  FastEditorMain in 'FastEditorMain.pas' {FastEditorFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFastEditorFrm, FastEditorFrm);
  Application.Run;
end.
