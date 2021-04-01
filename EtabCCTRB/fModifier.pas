unit fModifier;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmModifier = class(TForm)
    ecranInitialisation: TLayout;
    lblRaisonSociale: TLabel;
    edtRaisonSociale: TEdit;
    lblTypeEtablissement: TLabel;
    cbTypeEtablissement: TComboBox;
    cbTypeEtablissementAnimation: TAniIndicator;
    Layout2: TLayout;
    btnAnnuleCreation: TButton;
    btnCreerEtablissemen: TButton;
    procedure btnAnnuleCreationClick(Sender: TObject);
    procedure btnCreerEtablissemenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure RemplissageListeTypeEtablissements(cb: TComboBox;
      cbAnim: TAniIndicator);
  public
    { Déclarations publiques }
  end;

var
  frmModifier: TfrmModifier;

implementation

{$R *.fmx}

uses uConfig, uParam, uAPI_etb, uDM, System.Threading;

procedure TfrmModifier.btnAnnuleCreationClick(Sender: TObject);
begin
  close; // TODO : demander confirmation avant annulation
end;

procedure TfrmModifier.btnCreerEtablissemenClick(Sender: TObject);
begin
  if edtRaisonSociale.Text.trim.IsEmpty then
  begin
    edtRaisonSociale.SetFocus;
    raise exception.Create('Veuillez saisir votre nom d''établissement.');
  end;
  if (cbTypeEtablissement.ItemIndex < 0) or
    (cbTypeEtablissement.ListItems[cbTypeEtablissement.ItemIndex].tag < 0) then
  begin
    cbTypeEtablissement.SetFocus;
    raise exception.Create('Veuillez choisir un type d''établissement.');
  end;
  TConfig.RaisonSociale := edtRaisonSociale.Text.trim;
  TConfig.IDTypeEtablissement := cbTypeEtablissement.ListItems
    [cbTypeEtablissement.ItemIndex].tag;
  tparams.save;
  API_EtbChgASync(TConfig.id, TConfig.RaisonSociale,
    TConfig.IDTypeEtablissement,
    procedure
    begin
      close;
    end);
end;

procedure TfrmModifier.FormCreate(Sender: TObject);
begin
  edtRaisonSociale.Text := TConfig.RaisonSociale;
  RemplissageListeTypeEtablissements(cbTypeEtablissement,
    cbTypeEtablissementAnimation);
end;

procedure TfrmModifier.RemplissageListeTypeEtablissements(cb: TComboBox;
cbAnim: TAniIndicator);
begin
  cb.items.Clear;
  cb.ListItems[cb.items.Add('-- en attente --')].tag := -1;
  cb.ItemIndex := 0;
  cbAnim.Enabled := true;
  cbAnim.Visible := true;
  cbAnim.BringToFront;
  ttask.run(
    procedure
    begin
      if assigned(dm) then
      begin
        while not(dm.ChargementTypesEtablissementsTermine or
          TThread.CheckTerminated) do
          sleep(100);
        if (not TThread.CheckTerminated) and dm.ChargementTypesEtablissementsTermine
        then
          TThread.queue(nil,
            procedure
            var
              idx, idxitem: integer;
            begin
              cb.beginupdate;
              cb.items.Clear;
              dm.tabTypesEtablissements.first;
              idxitem := -1;
              while not dm.tabTypesEtablissements.eof do
              begin
                idx := cb.items.Add(dm.tabTypesEtablissements.fieldbyname
                  ('label').asstring);
                cb.ListItems[idx].tag := dm.tabTypesEtablissements.fieldbyname
                  ('id').asinteger;
                if (TConfig.IDTypeEtablissement = cb.ListItems[idx].tag) then
                  idxitem := idx;
                dm.tabTypesEtablissements.next;
              end;
              if (idxitem < 0) then
                cb.ItemIndex := 0
              else
                cb.ItemIndex := idxitem;
              cb.endupdate;
              cbAnim.Enabled := false;
              cbAnim.Visible := false;
            end);
      end;
    end);
end;

end.
