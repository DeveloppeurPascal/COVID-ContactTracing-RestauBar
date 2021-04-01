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
{$IFDEF MSWINDOWS}
  result := 'http://localhost:8080/';
{$ELSE}
  result := 'http://192.168.1.169:8080/';
{$ENDIF}
{$ELSE}
  result := 'https://api.cctrb.fr/';
  // TODO : gérer éventuellement la version de l'API
{$ENDIF}
end;

end.
