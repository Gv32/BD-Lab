select C.CodCausa, Max(data)
from Causa C, Udienza U
where C.CodCausa = U.CodCausa
    and DataFine IS NULL
    and CodFiscale IN (
        select CodFiscale
        from Causa C2
        Group By CodFiscale
        having count(*)>=3
    )
group by C.CodCausa