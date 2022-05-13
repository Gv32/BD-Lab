select I0.NomeT, I0.Cognome, Spec
from Istruttore I0, (   select P1.Citta NomiCitta, count(P1.CodP) as NP
                        from Palestra P1
                        group by P1.Citta),(    select I.Citta as Cit, I.CodFiscale as CodF, I.NomeT, I.Cognome, count(distinct P.CodP) as PA, count(distinct S.CodS) as Spec
                                                from Istruttore I, Palestra P, Lezione L, Specialita S
                                                where I.CodFiscale = L.CodFiscale
                                                    and S.codS = L.CodS
                                                    and P.CodP = L.CodP
                                                    and P.Citta = I.Citta
                                                group by I.Citta, I.CodFiscale, I.NomeT, I.Cognome)
where NomiCitta = Cit
    and CodF = I0.CodFiscale
    and PA = NP
group by I0.NomeT, I0.Cognome, Spec