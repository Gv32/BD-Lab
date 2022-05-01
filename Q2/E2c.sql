select NomeT, Cognome, COUNT(Distinct CodS)
from Istruttore I, Palestra P, Lezione L
where I.CodFiscale = L.CodFiscale
    and P.CodP = L.CodP
    and P.Città = I.Città
group by NomeT, Cognome
having COUNT(CodP) = (
    select COUNT(P1.CodP)
    from Palestra P1
    where P1.Città = P.Città
    group by P1.CodP
)