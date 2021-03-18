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
  ttask.run(
    procedure
    var
      tab: TFDMemTable;
    begin
      tab := API_ListeTypeEtablissements;
      if assigned(tab) then
        tthread.Queue(nil,
          procedure
          begin
            tabTypesEtablissements.CopyDataSet(tab,[coStructure, coRestart, coAppend]);
            tab.free;
          end);
    end);
end;

end.
