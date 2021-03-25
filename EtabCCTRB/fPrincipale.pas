unit fPrincipale;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDM,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, FMX.Bind.DBEngExt,
  FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, FMX.StdCtrls, FMX.ListBox,
  FMX.Edit, FMX.Layouts;

type
  TfrmPrincipale = class(TForm)
    ecranInitialisation: TLayout;
    lblRaisonSociale: TLabel;
    edtRaisonSociale: TEdit;
    lblTypeEtablissement: TLabel;
    cbTypeEtablissement: TComboBox;
    Layout2: TLayout;
    btnAnnuleCreation: TButton;
    btnCreerEtablissemen: TButton;
    ecranUtilisationCourante: TLayout;
    Label1: TLabel;
    cbTypeEtablissementAnimation: TAniIndicator;
    procedure FormCreate(Sender: TObject);
    procedure btnAnnuleCreationClick(Sender: TObject);
    procedure btnCreerEtablissemenClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure afficheEcranInitialisation;
    procedure afficheEcranUtilisation;
  public
    { Déclarations publiques }
  end;

var
  frmPrincipale: TfrmPrincipale;

implementation

{$R *.fmx}

uses uConfig, uParam, uAPI_etb, System.Threading;

procedure TfrmPrincipale.afficheEcranInitialisation;
begin
  ecranInitialisation.Visible := true;
  ecranUtilisationCourante.Visible := false;
  cbTypeEtablissement.items.Clear;
  cbTypeEtablissement.ListItems
    [cbTypeEtablissement.items.Add('-- en attente --')].tag := -1;
  edtRaisonSociale.Text := TConfig.RaisonSociale;

  cbTypeEtablissementAnimation.Enabled := true;
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
              cbTypeEtablissement.beginupdate;
              cbTypeEtablissement.items.Clear;
              dm.tabTypesEtablissements.first;
              idxitem := -1;
              while not dm.tabTypesEtablissements.eof do
              begin
                idx := cbTypeEtablissement.items.Add
                  (dm.tabTypesEtablissements.fieldbyname('label').asstring);
                cbTypeEtablissement.ListItems[idx].tag :=
                  dm.tabTypesEtablissements.fieldbyname('id').asinteger;
                if (TConfig.IDTypeEtablissement = cbTypeEtablissement.ListItems
                  [idx].tag) then
                  idxitem := idx;
                dm.tabTypesEtablissements.next;
              end;
              if (idxitem < 0) then
                cbTypeEtablissement.ItemIndex := 0
              else
                cbTypeEtablissement.ItemIndex := idxitem;
              cbTypeEtablissement.endupdate;
              cbTypeEtablissementAnimation.Enabled := false;
              cbTypeEtablissementAnimation.Visible := false;
            end);
      end;
    end);
end;

procedure TfrmPrincipale.afficheEcranUtilisation;
begin
  ecranInitialisation.Visible := false;
  ecranUtilisationCourante.Visible := true;
end;

procedure TfrmPrincipale.btnAnnuleCreationClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPrincipale.btnCreerEtablissemenClick(Sender: TObject);
begin
  if edtRaisonSociale.Text.trim.IsEmpty then
  begin
    edtRaisonSociale.SetFocus;
    raise exception.create('Veuillez saisir votre nom d''établissement.');
  end;
  if (cbTypeEtablissement.ItemIndex < 0) or
    (cbTypeEtablissement.ListItems[cbTypeEtablissement.ItemIndex].tag < 0) then
  begin
    cbTypeEtablissement.SetFocus;
    raise exception.create('Veuillez choisir un type d''établissement.');
  end;
  TConfig.RaisonSociale := edtRaisonSociale.Text.trim;
  TConfig.IDTypeEtablissement := cbTypeEtablissement.ListItems
    [cbTypeEtablissement.ItemIndex].tag;
  tparams.save;
  API_EtbAddASync(TConfig.RaisonSociale, TConfig.IDTypeEtablissement,
    procedure(id: integer)
    begin
      if (id < 0) then
        raise exception.create
          ('Erreur à la création de l''établissement. Merci de retenter dans quelques secondes.')
      else
      begin
        TConfig.id := id;
        tparams.save;
        afficheEcranUtilisation;
      end;
    end);
end;

procedure TfrmPrincipale.FormCreate(Sender: TObject);
begin
  if (TConfig.id < 0) then
    afficheEcranInitialisation
  else
    afficheEcranUtilisation;
end;

end.
