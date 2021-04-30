unit fTestCasContact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope;

type
  TfrmTestCasContact = class(TForm)
    ToolBar1: TToolBar;
    lblTitre: TLabel;
    btnBack: TButton;
    StringGrid1: TStringGrid;
    tabCasContacts: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
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

uses UAPI_cli, uConfig;

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

procedure TfrmTestCasContact.FormCreate(Sender: TObject);
begin
  API_CliCasContactASync(tconfig.id,tconfig.PrivateKey,
    procedure(tab: TFDMemTable)
    begin
      tabCasContacts.CopyDataSet(tab, [coStructure, coRestart, coAppend]);
    end);
end;

end.
