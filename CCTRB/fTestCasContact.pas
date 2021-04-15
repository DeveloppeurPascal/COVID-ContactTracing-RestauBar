unit fTestCasContact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TfrmTestCasContact = class(TForm)
    ToolBar1: TToolBar;
    lblTitre: TLabel;
    btnBack: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmTestCasContact: TfrmTestCasContact;

implementation

{$R *.fmx}

procedure TfrmTestCasContact.btnBackClick(Sender: TObject);
begin
  close;
end;

procedure TfrmTestCasContact.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      Self.Free;
    end);
end;

// TODO : remplir l'écran après appel API
end.
