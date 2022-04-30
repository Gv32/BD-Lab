select distinct G.CodFiscale, Cognome, COUNT(Distinct TipologiaCausa)
from Giudice G, Causa C1
where G.CodFiscale = C1.CodFiscale
    and G.CodFiscale NOT IN (
        select CodFiscale
        from Causa C2, Udienza U
        where TipologiaCausa = 'Diffamazione'
        and C2.CodCausa = U.CodCausa
        and Data >= to_date('01/01/2020','DD/MM/YYYY')
        and Data <= to_date('31/12/2020','DD/MM/YYYY')
    )
GROUP BY G.CodFiscale, Cognome