select g.nome, g.cognome, g.datanascita
from giudice g, udienza u, causa c
where g.codfiscale=c.codfiscale and c.codcausa=u.codcausa and 
    u.codtribunale in (
        select u1.codtribunale
        from causa c1, udienza u1
        where c1.tipologiacausa = 'Divorzio' and c1.codcausa=u1.codcausa
        group by u1.codtribunale
        having count(*)>=5
         )
group by g.codfiscale, g.nome, g.cognome, g.datanascita
having count(*) >= (
    select  count(NTribunali)
    from (  select count(DISTINCT u2.codtribunale) as NTribunali
            from causa c2, udienza u2
            where c2.tipologiacausa = 'Divorzio' and c2.codcausa=u2.codcausa
            group by u2.codtribunale
            having count(*)>=5)
)