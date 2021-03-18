unit uAPI_typesetb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite;

/// <summary>
/// API "types" - Retourne la liste des types d'établissements
/// </summary>
function API_ListeTypeEtablissements: tfdmemtable;

implementation

uses
  system.net.HttpClient, uAPI, system.json;

function API_ListeTypeEtablissements: tfdmemtable;
var // TODO : passer en asynchrone
  serveur: thttpclient;
  reponse: ihttpresponse;
  jsa: tjsonarray;
  jso: tjsonobject;
  jsv: tjsonvalue;
  id: integer;
  libelle: string;
begin
  result := tfdmemtable.Create(nil);
  result.FieldDefs.Add('id', tfieldtype.ftInteger);
  result.FieldDefs.Add('label', tfieldtype.ftString, 100);
  result.open;
  serveur := thttpclient.Create;
  try
    reponse := serveur.get(getAPIURL + 'types');
    if (reponse.StatusCode = 200) then
    begin
      try
        jsa := tjsonobject.ParseJSONValue(reponse.ContentAsString)
          as tjsonarray;
      except
        jsa := tjsonarray.Create;
      end;
      if assigned(jsa) then
      begin
        for jsv in jsa do
          try
            jso := jsv as tjsonobject;
            try
              id := (jso.GetValue('id') as tjsonnumber).AsInt;
              try
                libelle := (jso.GetValue('label') as TJSONString).Value;
                result.Insert;
                result.FieldByName('id').AsInteger := id;
                result.FieldByName('label').Asstring := libelle;
                result.post;
              except

              end;
            except

            end;
          except

          end;
        jsa.free;
      end;
    end;
  finally
    serveur.free;
  end;
end;

end.
