unit uAPI_etb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite;

/// <summary>
/// API "etbadd" - inscription de l'établissement
/// </summary>
function API_EtbAdd(RaisonSociale: string;
  IDTypeEtablissement: integer): integer;

/// <summary>
/// API "etbchg" - modification de l'établissement
/// </summary>
procedure API_EtbChange(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer);

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'établissement et retourne la liste des périodes
/// </summary>
function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;

implementation

uses
  System.Net.HttpClient, uAPI;

function API_EtbAdd(RaisonSociale: string;
  IDTypeEtablissement: integer): integer;
begin
  // TODO : à compléter
end;

procedure API_EtbChange(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer);
begin
  // TODO : à compléter
end;

function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;
begin
  // TODO : à compléter
end;

end.
