SET storage_engine=InnoDB;
SET FOREIGN_KEY_CHECKS=1;

-- Creazione Base Dati
CREATE DATABASE IF NOT EXISTS Campionato_Ciclistico;
USE Campionato_Ciclistico;


-- Cancellazione vecchie tabelle se presenti
DROP TABLE IF EXISTS CICLISTA;
DROP TABLE IF EXISTS SQUADRA;
DROP TABLE IF EXISTS TAPPA;
DROP TABLE IF EXISTS CLASSIFICA_INDIVIDUALE;



-- Creazione Tabelle
CREATE TABLE CICLISTA(
    CodC smallint PRIMARY KEY,
    Nome varchar(50) NOT NULL,
    Cognome varchar(50) NOT NULL,
    Nazionalita varchar(50) NOT NULL,
    CodS smallint NOT NULL REFERENCES SQUADRA(CodS),
    AnnoNascita integer NOT NULL,
    CONSTRAINT chk_AnnoNascita CHECK (AnnoNascita>=1900 AND AnnoNascita<=2000)
);


CREATE TABLE SQUADRA (
    CodS smallint PRIMARY KEY,
    NomeS varchar(50) NOT NULL,
    AnnoFondazione integer NOT NULL,
    SedeLegale varchar(50),
    CONSTRAINT chk_AnnoFondazione CHECK (AnnoFondazione>=1900 AND AnnoFondazione<=2000)
);


CREATE TABLE TAPPA (
  Edizione smallint NOT NULL,
  CodT smallint NOT NULL,
  CittaPartenza varchar(50) NOT NULL,
  CittaArrivo varchar(50) NOT NULL,
  Lunghezza smallint NOT NULL,
  Dislivello smallint NOT NULL,
  GradoDifficolta smallint NOT NULL,
  CONSTRAINT chk_GradoDifficolta CHECK (GradoDifficolta>=1 AND GradoDifficolta<=10),
  PRIMARY KEY(Edizione, CodT)
);

CREATE TABLE CLASSIFICA_INDIVIDUALE (
  CodC smallint NOT NULL REFERENCES CICLISTA(CodC),
  CodT smallint NOT NULL REFERENCES TAPPA(CodT),
  Edizione smallint NOT NULL REFERENCES TAPPA(Edizione),
  Posizione smallint NOT NULL,
  PRIMARY KEY(CodC, CodT,Edizione)
);


-- Inserimento Dati

INSERT INTO CICLISTA(CodC, Nome, Cognome, Nazionalita, CodS, AnnoNascita)
VALUES (1,'Francesco','Rossi', 'Italiana','1', 1993);
INSERT INTO CICLISTA(CodC, Nome, Cognome, Nazionalita, CodS, AnnoNascita)
VALUES (2,'Giovanni','Bianchi', 'Francese','2', 1994);

INSERT INTO SQUADRA(CodS, NomeS, AnnoFondazione, SedeLegale)
VALUES(1, 'Mitici', 1943, 'Torino');
INSERT INTO SQUADRA(CodS, NomeS, AnnoFondazione, SedeLegale)
VALUES(2, 'Potenti', 1920, 'Milano');

INSERT INTO TAPPA(Edizione, CodT, CittaPartenza, CittaArrivo, Lunghezza, Dislivello, GradoDifficolta)
VALUES(1,1,'Milano','Torino',2000,20,3);
INSERT INTO TAPPA(Edizione, CodT, CittaPartenza, CittaArrivo, Lunghezza, Dislivello, GradoDifficolta)
VALUES(1,2,'Torino','Genova',1500,10,7);
INSERT INTO TAPPA(Edizione, CodT, CittaPartenza, CittaArrivo, Lunghezza, Dislivello, GradoDifficolta)
VALUES(2,1,'Torino','Firenze',5000,5,9);


INSERT INTO CLASSIFICA_INDIVIDUALE (CodC, CodT, Edizione, Posizione)
VALUES(1, 1, 1, 2);
INSERT INTO CLASSIFICA_INDIVIDUALE (CodC, CodT, Edizione, Posizione)
VALUES(1, 2, 1, 1);