unit fAPropos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmAPropos = class(TForm)
    ToolBar1: TToolBar;
    btnBack: TButton;
    lblTitre: TLabel;
    VertScrollBox1: TVertScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAPropos: TfrmAPropos;

implementation

{$R *.fmx}

procedure TfrmAPropos.btnBackClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAPropos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      Self.Free;
    end);
end;

end.
