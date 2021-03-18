unit uAPI;

interface

/// <summary>
/// Retourne l'adresse du serveur selon la configuration de l'appareil et le système d'exploitation
/// </summary>
function getAPIURL: string;

implementation

function getAPIURL: string;
begin
{$IFDEF DEBUG}
  result := 'http://localhost:8080/';
{$ELSE}
  result := 'https://api.cctrb.fr/';
{$ENDIF}
end;

end.
