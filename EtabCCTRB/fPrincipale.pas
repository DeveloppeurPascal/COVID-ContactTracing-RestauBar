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
    cbTypeEtablissementAnimation: TAniIndicator;
    btnConsulter: TButton;
    btnModifier: TButton;
    btnTestCOVIDPositifs: TButton;
    btnGenererQRCode: TButton;
    btnFermer: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAnnuleCreationClick(Sender: TObject);
    procedure btnCreerEtablissemenClick(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
    procedure btnConsulterClick(Sender: TObject);
    procedure btnModifierClick(Sender: TObject);
    procedure btnTestCOVIDPositifsClick(Sender: TObject);
    procedure btnGenererQRCodeClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure afficheEcranInitialisation;
    procedure afficheEcranUtilisation;
    procedure RemplissageListeTypeEtablissements(cb: TComboBox;
      cbAnim: TAniIndicator);
  public
    { Déclarations publiques }
  end;

var
  frmPrincipale: TfrmPrincipale;

implementation

{$R *.fmx}

uses uConfig,  uAPI_etb, System.Threading, fVisualiser, fModifier,
  fTestCasContact, fGenerationQRCode, Olf.RTL.Params;

procedure TfrmPrincipale.afficheEcranInitialisation;
begin
  ecranInitialisation.Visible := true;
  ecranUtilisationCourante.Visible := false;
  edtRaisonSociale.Text := TConfig.RaisonSociale;
  RemplissageListeTypeEtablissements(cbTypeEtablissement,
    cbTypeEtablissementAnimation);
end;

procedure TfrmPrincipale.afficheEcranUtilisation;
begin
  ecranInitialisation.Visible := false;
  ecranUtilisationCourante.Visible := true;
end;

procedure TfrmPrincipale.RemplissageListeTypeEtablissements(cb: TComboBox;
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

procedure TfrmPrincipale.btnAnnuleCreationClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPrincipale.btnConsulterClick(Sender: TObject);
var
  f: TfrmVisualiser;
begin
  f := TfrmVisualiser.Create(self);
  try
    f.showmodal;
  finally
    f.free;
  end;
end;

procedure TfrmPrincipale.btnCreerEtablissemenClick(Sender: TObject);
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
  API_EtbAddASync(TConfig.RaisonSociale, TConfig.IDTypeEtablissement,
    procedure(id: integer; KPriv, KPub: string)
    begin
      if (id < 0) then
        raise exception.Create
          ('Erreur à la création de l''établissement. Merci de retenter dans quelques secondes.')
      else
      begin
        TConfig.id := id;
        TConfig.PublicKey := KPub;
        TConfig.PrivateKey := KPriv;
        tparams.save;
        afficheEcranUtilisation;
      end;
    end);
end;

procedure TfrmPrincipale.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPrincipale.btnGenererQRCodeClick(Sender: TObject);
var
  f: TfrmGenerationQRCode;
begin
  f := TfrmGenerationQRCode.Create(self);
  try
    f.showmodal;
  finally
    f.free;
  end;
end;

procedure TfrmPrincipale.btnModifierClick(Sender: TObject);
var
  f: TfrmModifier;
begin
  f := TfrmModifier.Create(self);
  try
    f.showmodal;
  finally
    f.free;
  end;
end;

procedure TfrmPrincipale.btnTestCOVIDPositifsClick(Sender: TObject);
var
  f: TfrmTestCasContact;
begin
  f := TfrmTestCasContact.Create(self);
  try
    f.showmodal;
  finally
    f.free;
  end;
end;

procedure TfrmPrincipale.FormCreate(Sender: TObject);
begin
  if (TConfig.id < 0) then
    afficheEcranInitialisation
  else
    afficheEcranUtilisation;

  for var i := 0 to ComponentCount - 1 do
    if (Components[i] is TButton) and
      (not assigned((Components[i] as TButton).onclick)) then
      (Components[i] as TButton).Enabled := false;
end;

end.
