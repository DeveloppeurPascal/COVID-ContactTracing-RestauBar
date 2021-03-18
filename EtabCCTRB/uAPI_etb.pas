unit uAPI_etb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite;

/// <summary>
/// API "etbadd" - inscription de l'�tablissement
/// </summary>
function API_EtbAdd(RaisonSociale: string;
  IDTypeEtablissement: integer): integer;

/// <summary>
/// API "etbchg" - modification de l'�tablissement
/// </summary>
procedure API_EtbChange(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer);

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'�tablissement et retourne la liste des p�riodes
/// </summary>
function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;

implementation

uses
  System.Net.HttpClient, uAPI;

function API_EtbAdd(RaisonSociale: string;
  IDTypeEtablissement: integer): integer;
begin
  // TODO : � compl�ter
end;

procedure API_EtbChange(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer);
begin
  // TODO : � compl�ter
end;

function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;
begin
  // TODO : � compl�ter
end;

end.
