unit FastEditorMain;

interface

uses
  Classes, Forms, frxClass, frxDBSet, frxPreview, SysUtils, DB
{IFDEF FASTSCRIPT_RTTI}
  , fs_iinterpreter
{ENDIF}
  , frxDesgn, frxRich, frxChBox, frxGZip, frxDCtrl
  , frxExportImage, frxExportXLS, frxExportXML, frxExportMail, frxExportPDF, frxExportRTF, frxExportTXT, frxExportHTML;

type
  TFRShowStyle = (frsNormal, frsModal, frsMDIChild, frsPrint);

  TFastEditorFrm = class(TfrxPreviewForm)
//    procedure OpenBClick(Sender: TObject);
    procedure SaveBClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    DefaultSaveName: String;
  public
    { Public declarations }
    frxReport     : TfrxReport;

    constructor Create(AOwner: TComponent); override;
  end;

var
  FastEditorFrm: TFastEditorFrm;

implementation

const
  SRegistryPath_Software  : String = '\Software';
  SConst_FastReport       : String = 'FastReport';
  SVar_CaptionPathDelimeter : String = ' :: ';

{ Полноценный конструктор }
constructor TFastEditorFrm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Position      := poDefaultPosOnly;
  FreeOnClose   := True;

//  if ADataModule = nil then
//    ADataModule := AOwner;

  frxReport := TfrxReport.Create(Self);
  with frxReport do begin
    IniFile := SRegistryPath_Software + '\' + Application.ExeName + '\' + SConst_FastReport;
    with PreviewOptions do begin
      Maximized := False;
      MDIChild  := False;
      Modal     := False;
      Buttons   := Buttons + [pbExport];
    end;

    with Script do begin
      AutoDeclareClasses        := True;

      Parent                    := fsGlobalUnit;
      Parent.AutoDeclareClasses := True;

//        if AOwner <> nil then
//          DataModule              := ADataModule;
    end;
  end;

  OnShow        := FormShow;
  SaveB.OnClick := SaveBClick;
  // SaveB.OnClick := SaveBClick;
end;

procedure TFastEditorFrm.FormShow(Sender: TObject);
var
  LFileName: String;
begin
  inherited;

  Preview.Report       := frxReport;
  Preview.PreviewPages := frxReport.PreviewPages;
  LFileName := ParamStr(1);
  if LFileName.IsEmpty then begin
    Preview.LoadFromFile;
  end else
    Preview.LoadFromFile(LFileName);

  if Preview.PageCount = 0 then
    Application.Terminate;

  Caption := 'Редактирование отчёта FastReport';

//  if not frxReport.ReportOptions.Name.IsEmpty then
//    Caption := Caption + SVar_CaptionPathDelimeter + frxReport.ReportOptions.Name;

  Init;
end;

procedure TFastEditorFrm.SaveBClick(Sender: TObject);
begin
  Preview.SaveToFileDefault(DefaultSaveName);
end;

initialization
  RegisterClasses
  (
    [
      TfrxXLSExport, TfrxXMLExport, TfrxMailExport, TfrxPDFExport, TfrxHTMLExport, TfrxRTFExport,
      TfrxBMPExport, TfrxJPEGExport, TfrxGIFExport, TfrxPNGExport, TfrxTXTExport
    ]
  );

finalization
  UnRegisterClasses
  (
    [
      TfrxXLSExport, TfrxXMLExport, TfrxMailExport, TfrxPDFExport, TfrxHTMLExport, TfrxRTFExport,
      TfrxBMPExport, TfrxJPEGExport, TfrxGIFExport, TfrxPNGExport, TfrxTXTExport
    ]
  );

end.

