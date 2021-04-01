unit fVisualiser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfrmVisualiser = class(TForm)
    lblTypeEtablissement: TLabel;
    lblIDEtablissement: TLabel;
    lblRaisonSociale: TLabel;
    btnFermer: TButton;
    lblInfoIDEtablissement: TLabel;
    lblInfoTypeEtablissement: TLabel;
    lblInfoRaisonSociale: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmVisualiser: TfrmVisualiser;

implementation

{$R *.fmx}

uses uconfig, uDM;

procedure TfrmVisualiser.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmVisualiser.FormCreate(Sender: TObject);
begin
  lblInfoIDEtablissement.text := tconfig.id.tostring;
  lblInfoRaisonSociale.text := tconfig.RaisonSociale;
  if dm.ChargementTypesEtablissementsTermine and
    dm.tabTypesEtablissements.Locate('id', tconfig.IDTypeEtablissement) then
    lblInfoTypeEtablissement.text := dm.tabTypesEtablissements.fieldbyname
      ('label').asstring
  else
    lblInfoTypeEtablissement.text := tconfig.IDTypeEtablissement.tostring +
      ' (libellé non récupérable)';
end;

end.
