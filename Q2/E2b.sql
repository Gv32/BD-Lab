select NomeT, P1.NomeP, P1.Indirizzo, P1.Citta
from Istruttore I1, Palestra P1, Lezione L1
where I1.CodFiscale = L1.CodFiscale
    and L1.CodP = P1.CodP
    and I1.CodFiscale NOT IN(
        Select I2.CodFiscale
        from Specialita S2, Istruttore I2, Lezione L2
        where S2.CodS = L2.CodS
            and L2.CodFiscale = I2.CodFiscale
            and S2.NomeS <> 'Yoga'
    )
group by NomeT, P1.NomeP, P1.Indirizzo, P1.Citta
having count(P1.CodP) = (   select max(Npalestra)
                            from (  select NomeT, P1.Indirizzo, P1.Citta, count (P1.CodP) as Npalestra
                                    from Istruttore I1, Palestra P1, Lezione L1
                                    where I1.CodFiscale = L1.CodFiscale
                                        and L1.CodP = P1.CodP
                                        and I1.CodFiscale NOT IN(
                                            Select I2.CodFiscale
                                            from Specialita S2, Istruttore I2, Lezione L2
                                            where S2.CodS = L2.CodS
                                                and L2.CodFiscale = I2.CodFiscale
                                                and S2.NomeS <> 'Yoga'
                                        )
                                    group by NomeT, P1.Indirizzo, P1.Citta
                                )
                        )   