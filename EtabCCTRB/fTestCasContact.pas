unit fTestCasContact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid, Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmTestCasContact = class(TForm)
    StringGrid1: TStringGrid;
    btnFermer: TButton;
    BindingsList1: TBindingsList;
    tabCasContacts: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    procedure btnFermerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmTestCasContact: TfrmTestCasContact;

implementation

{$R *.fmx}

uses uAPI_etb, uConfig;

procedure TfrmTestCasContact.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmTestCasContact.FormCreate(Sender: TObject);
begin
  API_EtbCasContactASync(tconfig.id,tconfig.PrivateKey,
    procedure(tab: TFDMemTable)
    begin
      tabCasContacts.CopyDataSet(tab, [coStructure, coRestart, coAppend]);
    end);
end;

end.
