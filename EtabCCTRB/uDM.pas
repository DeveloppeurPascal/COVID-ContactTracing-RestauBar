unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Tdm = class(TDataModule)
    tabTypesEtablissements: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  System.Threading, uAPI_typesetb;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  API_ListeTypeEtablissementsAsync(
    procedure(tab: TFDMemTable)
    begin
      tabTypesEtablissements.CopyDataSet(tab, [coStructure, coRestart,
        coAppend]);
    end);
end;

end.
