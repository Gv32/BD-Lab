from flask import Flask, render_template, request
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError


app = Flask(__name__)


@app.route("/")
def home():
    return render_template("home.html")


@app.route("/NewCiclista", methods=["GET"])
def Ins_Ciclista():
    dialect = "mysql"
    username = "root"
    password = ""
    host = "127.0.0.1"
    dbname = "Campionato_Ciclistico"
    engine = create_engine("%s://%s:%s@%s/%s" % (dialect, username, password, host, dbname))
    try:
        con = engine.connect()
        query = "SELECT CodS\
                FROM SQUADRA"
        CodiciS = con.execute(query)
        con.close()
        return render_template("Ciclista_inserimento.html", CodiciS=CodiciS)
    except SQLAlchemyError as e:
        errore = str(e.__dict__['orig'])
        return render_template('errore.html', error_message=errore)


@app.route("/inserimentoC", methods=["GET"])
def InserimentoC():
    dialect = "mysql"
    username = "root"
    password = ""
    host = "127.0.0.1"
    dbname = "Campionato_Ciclistico"
    engine = create_engine("%s://%s:%s@%s/%s" % (dialect, username, password, host, dbname))
    
    codC = request.args.get('CodC')
    nome = request.args.get('Nome')
    cognome = request.args.get('Cognome')
    naz = request.args.get('Nazionalita')
    codS = request.args.get('CodS')
    annoN = request.args.get('AnnoNascita')

    if codC.isnumeric() == False or codS.isnumeric() == False or annoN.isnumeric() == False:
        errore = "Inserire un campo numerico"
        return render_template("errore.html", error_message=errore)
        
    codC = int(codC)
    codS = int(codS)
    annoN = int(annoN)

    if codC <=0 or codS <=0:
        errore = "I Parametri non possono essere negativi o nulli"
        return render_template("errore.html", error_message=errore)

    if annoN > 2000 or annoN < 1900:
        errore = "L'anno inserito non e' valido, inserire una data tra il 1900 e il 2000"
        return render_template("errore.html", error_message=errore)

    try:
        con = engine.connect()
        query = "SELECT CodS\
                FROM SQUADRA"
        CodiciS = con.execute(query)
        con.close()
    except SQLAlchemyError as e:
        errore = str(e.__dict__['orig'])
        return render_template('errore.html', error_message=errore)

    x = False
    for elem in CodiciS:
        if elem['CodS'] == codS:
            x = True
            break
            

    if x:
        try:
            con = engine.connect()
            query = "INSERT INTO Ciclista (CodC, Nome, Cognome, Nazionalita, CodS, AnnoNascita)\
                    VALUES ('%s','%s','%s','%s','%s','%d')" % (codC, nome, cognome, naz, codS, annoN)
            con.execute(query)
            con.close()
            return render_template("Conferma.html")
        except SQLAlchemyError as e:
            errore = str(e.__dict__['orig'])
            return render_template('errore.html', error_message=errore)
    else:
        errore = "Qualcosa e' andato storto"
        return render_template('errore.html', error_message=errore)


@app.route("/NewTappa", methods=["GET"])
def Ins_Tappa():
    dialect = "mysql"
    username = "root"
    password = ""
    host = "127.0.0.1"
    dbname = "Campionato_Ciclistico"
    engine = create_engine("%s://%s:%s@%s/%s" % (dialect, username, password, host, dbname))
    try:
        con = engine.connect()
        query = "SELECT CodC\
                FROM CICLISTA"
        Ciclista = con.execute(query)


        query = "SELECT DISTINCT CodT\
                FROM TAPPA"
        Tappa = con.execute(query)


        query = "SELECT DISTINCT Edizione\
                FROM TAPPA"
        Edizioni = con.execute(query)

        
        con.close()
        return render_template("Tappa_inserimento.html", Ciclista=Ciclista, Edizioni=Edizioni, Tappa=Tappa)
        
    except SQLAlchemyError as e:
        errore = str(e.__dict__['orig'])
        return render_template('errore.html', error_message=errore)



@app.route("/inserimentoT", methods=["GET"])
def InserimentoT():
    dialect = "mysql"
    username = "root"
    password = ""
    host = "127.0.0.1"
    dbname = "Campionato_Ciclistico"
    engine = create_engine("%s://%s:%s@%s/%s" % (dialect, username, password, host, dbname))

    codC = request.args.get('CodC')
    codT = request.args.get('CodT')
    ed = request.args.get('Edizione')
    pos = request.args.get('Posizione')

    if codC.isnumeric() == False or codT.isnumeric() == False or ed.isnumeric() == False or pos.isnumeric() == False:
        errore = "Inserire un campo numerico"
        return render_template("errore.html", error_message=errore)
        
    codC = int(codC)
    codT = int(codT)
    ed = int(ed)
    pos = int(pos)  

    if codC <= 0 or codT <= 0 or ed <= 0 or pos <= 0:
        errore = "I Parametri non possono essere negativi o nulli"
        return render_template("errore.html", error_message=errore)
    

    try:
        con = engine.connect()
        query = "SELECT CodC\
                FROM CICLISTA"
        Ciclista = con.execute(query)


        query = "SELECT DISTINCT CodT\
                FROM TAPPA"
        Tappa = con.execute(query)


        query = "SELECT DISTINCT Edizione\
                FROM TAPPA"
        Edizioni = con.execute(query)

        con.close()
    except SQLAlchemyError as e:
        errore = str(e.__dict__['orig'])
        return render_template('errore.html', error_message=errore)
    
    x = False
    for elem in Ciclista:
        if elem['CodC'] == codC:
            x = True
            break

    y = False
    for elem in Tappa:
        if elem['CodT'] == codT:
            y = True
            break
        
    z = False
    for elem in Edizioni:
        if elem['Edizione'] == ed:
            z = True
            break

    if x == True and y == True and z == True:
        try:
            con = engine.connect()
            query = "INSERT INTO CLASSIFICA_INDIVIDUALE (CodC, CodT, Edizione, Posizione)\
                    VALUES ('%s','%d','%d','%d') " % (codC, codT, ed, pos)
            con.execute(query)
            con.close()
            return render_template("Conferma.html")
        except SQLAlchemyError as e:
            errore = str(e.__dict__['orig'])
            return render_template('errore.html', error_message=errore)

    else:
        errore = "Qualcosa e' andato storto"
        return render_template('errore.html', error_message=errore)


@app.route("/IntCiclista", methods=["GET"])
def Visualizza_Pos():
    dialect = "mysql"
    username = "root"
    password = ""
    host = "127.0.0.1"
    dbname = "Campionato_Ciclistico"
    engine = create_engine("%s://%s:%s@%s/%s" % (dialect, username, password, host, dbname))

    try:
        con = engine.connect()
        query = "SELECT CodC\
                FROM CICLISTA"
        Ciclista = con.execute(query)
        con.close()

        return render_template("Ricerca.html", Ciclista = Ciclista)
    
    except SQLAlchemyError as e:
        errore = str(e.__dict__['orig'])
        return render_template('errore.html', error_message=errore)


@app.route("/ricercaC", methods=["GET"])
def Ricerca():
    dialect = "mysql"
    username = "root"
    password = ""
    host = "127.0.0.1"
    dbname = "Campionato_Ciclistico"
    engine = create_engine("%s://%s:%s@%s/%s" % (dialect, username, password, host, dbname))

    codC = request.args.get('CodC')
    codT = request.args.get('CodT')
    
    if codT == "" or codC == "":
        errore = "Campo non inserito correttamente"
        return render_template("errore.html", error_message=errore)
    
    
    if codC.isnumeric() == False or codT.isnumeric() == False:
        errore = "Inserire un campo numerico"
        return render_template("errore.html", error_message=errore)


    codC = int(codC)
    codT = int(codT)

    try:
        con = engine.connect()
        query = "Select Nome, Cognome, NomeS, Posizione, Edizione\
                 From CLASSIFICA_INDIVIDUALE as CI, CICLISTA as C, SQUADRA S\
                 Where C.CodC = ('%d')\
                    and CodT = ('%d')\
                    and C.CodC = CI.CodC\
                    and C.CodS = S.CodS\
                 Order By Edizione Asc" % (codC,codT)
        risultato = con.execute(query)
        header = risultato.keys()
        con.close()
        return render_template("Visualizza.html", risultato=risultato, header = header)
    except SQLAlchemyError as e:
        errore = str(e.__dict__['orig'])
        return render_template('errore.html', error_message=errore)



app.run(host="localhost", port=8080, debug=True)