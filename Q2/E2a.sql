select DISTINCT p.nomep, count(l.codfiscale)
from specialita s, lezione l, palestra p
where p.citta='Torino' 
    and l.codp not in(
        select codp
        from lezione l, specialita s
        where s.nomes='Yoga' and l.cods=s.cods
        ) 
    and p.codp=l.codp
    and l.cods=s.cods
    and l.codp in(
        select codp
        from lezione l, specialita s
        where s.nomes='Judo' and l.cods=s.cods
        )
group by l.codp,p.nomep
having count(*)>=5