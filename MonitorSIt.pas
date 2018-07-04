unit MonitorSIt;

// TODO "Renomear componentes"
// TODO "Colocar op��o pra diret�rio inicial na aba Options"
// TODO "Filtro por M�todo"
// TODO "Substituir DBEdit por DBLabel"

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  FireDAC.Comp.BatchMove.Text, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FDSitViewer,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.FileCtrl, Vcl.Mask;

type
  TfrmSitViewer = class(TForm)
    dsSitViewer: TDataSource;
    openDialog: TOpenDialog;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDSitViewer: TFDSitViewer;
    FDSitViewerData: TStringField;
    FDSitViewerHora: TStringField;
    FDSitViewerIpServidor: TStringField;
    FDSitViewerBase: TStringField;
    FDSitViewerServico: TStringField;
    FDSitViewerClasse: TStringField;
    FDSitViewerMetodo: TStringField;
    FDSitViewerEventoLog: TStringField;
    FDSitViewerTexto: TStringField;
    pcTop: TPageControl;
    tsDirectory: TTabSheet;
    tsSitViewer: TTabSheet;
    grSitViewer: TDBGrid;
    tsDataOptions: TTabSheet;
    pnlTop: TPanel;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    dlBox: TDirectoryListBox;
    flBox: TFileListBox;
    splMiddleDirectory: TSplitter;
    grpGridFilter: TGroupBox;
    cbSitViewer: TComboBox;
    lblFilterEventoLog: TLabel;
    pnlBot: TPanel;
    splSitViewer: TSplitter;
    pcBottom: TPageControl;
    tsTexto: TTabSheet;
    tsDetalhes: TTabSheet;
    lbdfData: TLabel;
    lbdfIpServidor: TLabel;
    lbdfBase: TLabel;
    lbdfHora: TLabel;
    lbdfServico: TLabel;
    lbdfClasse: TLabel;
    lbdfMetodo: TLabel;
    lbdfEventoLog: TLabel;
    dbMmTexto: TDBMemo;
    lblFilterMetodo: TLabel;
    lblData: TLabel;
    lblHora: TLabel;
    lblIpServidor: TLabel;
    lblBase: TLabel;
    lblMetodo: TLabel;
    lblServico: TLabel;
    lblClasse: TLabel;
    lblEventoLog: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure cbSitViewerSelect(Sender: TObject);
    procedure grSitViewerDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure flBoxDblClick(Sender: TObject);
    procedure dlBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FDSitViewerAfterScroll(DataSet: TDataSet);
  private
    procedure SetLabelValueInDetailsTab;
  end;

var
  frmSitViewer: TfrmSitViewer;

implementation

uses
  IniFiles;

{$R *.dfm}

procedure TfrmSitViewer.BitBtn1Click(Sender: TObject);
begin
  If openDialog.Execute then
    FDSitViewer.ReadLogTxt(openDialog.FileName);
end;

procedure TfrmSitViewer.cbSitViewerSelect(Sender: TObject);
begin
  FDSitViewer.Filter := EmptyStr;
  if cbSitViewer.ItemIndex <> 0 then
    FDSitViewer.Filter := Format('eventoLog = %s', [QuotedStr(cbSitViewer.Text)]);
  FDSitViewer.Filtered := True;
end;

procedure TfrmSitViewer.dlBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RIGHT then
    dlBox.OpenCurrent;
end;

procedure TfrmSitViewer.FDSitViewerAfterScroll(DataSet: TDataSet);
begin
  SetLabelValueInDetailsTab;
end;

procedure TfrmSitViewer.flBoxDblClick(Sender: TObject);
begin
  if flBox.ItemIndex < 0 then
    Exit;

  FDSitViewer.ReadLogTxt(flBox.FileName);
  FDSitViewer.First;
  pcTop.ActivePage := tsSitViewer;
end;

procedure TfrmSitViewer.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
  lFileName: string;
  sInitialDirectory: string;
begin
  sInitialDirectory := 'C:\Logsit';
  lFileName := ExtractFilePath(ParamStr(0)) + 'SitViewer.ini';
  IniFile := TIniFile.Create(lFileName);

  dlBox.Directory := IniFile.ReadString('Options', 'Directory', sInitialDirectory);
  IniFile.Free;
  pcTop.ActivePage := tsDirectory;
  pcBottom.ActivePage := tsTexto;
end;

procedure TfrmSitViewer.grSitViewerDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if FDSitViewer.FieldByName('EventoLog').AsString = 'Erro' then
    grSitViewer.Canvas.Brush.Color := $006262FF;
  grSitViewer.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TfrmSitViewer.SetLabelValueInDetailsTab;
begin
  lblData.Caption := FDSitViewer.FieldByName('Data').AsString;
  lblHora.Caption := FDSitViewer.FieldByName('Hora').AsString;
  lblIpServidor.Caption := FDSitViewer.FieldByName('IpServidor').AsString;
  lblBase.Caption := FDSitViewer.FieldByName('Base').AsString;
  lblMetodo.Caption := FDSitViewer.FieldByName('Metodo').AsString;
  lblServico.Caption := FDSitViewer.FieldByName('Servico').AsString;
  lblClasse.Caption := FDSitViewer.FieldByName('Classe').AsString;
  lblEventoLog.Caption := FDSitViewer.FieldByName('EventoLog').AsString;
end;

end.
