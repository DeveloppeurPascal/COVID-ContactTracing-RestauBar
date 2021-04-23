CREATE TABLE etablissements (
  IDEtablissement BIGINT AUTO_INCREMENT NOT NULL,
  RaisonSociale VARCHAR(255) NOT NULL,
  IDTypeEtablissement BIGINT NOT NULL DEFAULT 0,
  ClePrivee CHAR(64),
  ClePublique CHAR(64),
  PRIMARY KEY (IDEtablissement)
);

CREATE TABLE historiques (
  IDClient BIGINT NOT NULL,
  IDEtablissement BIGINT NOT NULL,
  DateHeureEntree CHAR(12) NOT NULL DEFAULT '000000000000',
  DateHeureSortie CHAR(12) NOT NULL DEFAULT '000000000000',
  CasContact TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (IDClient,IDEtablissement,DateHeureEntree)
);

CREATE TABLE declarations (
  IDClient BIGINT NOT NULL DEFAULT 0,
  DateHeureDeclarationPositif CHAR(12) NOT NULL DEFAULT '000000000000',
  PRIMARY KEY (IDClient,DateHeureDeclarationPositif)
);

CREATE TABLE clients (
  IDClient BIGINT AUTO_INCREMENT NOT NULL,
  ClePrivee CHAR(64),
  ClePublique CHAR(64),
  PRIMARY KEY (IDClient)
);

CREATE TABLE typesetablissements (
  IDTypeEtablissement BIGINT AUTO_INCREMENT NOT NULL,
  libelle VARCHAR(255) NOT NULL,
  PRIMARY KEY (IDTypeEtablissement)
);

CREATE INDEX HistoriqueClieEtbSortie ON historiques
  (IDClient,IDEtablissement,DateHeureSortie,DateHeureEntree);

CREATE INDEX HistoCOVIDEtbEntSor ON historiques
  (CasContact,IDEtablissement,DateHeureEntree,DateHeureSortie,IDClient);

CREATE INDEX HistoCOVIDCliEntSor ON historiques
  (CasContact,IDClient,DateHeureEntree,DateHeureSortie);

CREATE INDEX DeclarationsParDate ON declarations
  (DateHeureDeclarationPositif,IDClient);

CREATE UNIQUE INDEX ClientsParClePublique ON clients
  (ClePublique,IDClient);

CREATE INDEX HistoriquesParDate ON historiques
  (DateHeureEntree,IDClient,IDEtablissement);

CREATE UNIQUE INDEX EtablissementsParClePublique ON etablissements
  (ClePublique,IDEtablissement);
