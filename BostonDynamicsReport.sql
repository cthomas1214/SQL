WITH OptionsCombined (ProdOptions, ProdName, ProdId, ProdQuantity, NumberOfOptionValues) AS (

SELECT 
	STRING_AGG(po.ProductOptionValue, ', '), ohp.ProductName, ohp.ProductId, AVG(ProductQuantity), COUNT(po.ProductOptionValue)
FROM 
OrderHistory oh
    
JOIN 
    OrderHistoryProducts ohp ON oh.OrderHistoryId = ohp.OrderHistoryId
LEFT JOIN 
    OrderHistoryProductOptions po ON ohp.OrderHistoryProductId = po.OrderHistoryProductId 

WHERE 
    oh.Pending = 0 
	
GROUP BY  ohp.ProductName, ohp.ProductId, ohp.OrderHistoryProductId, oh.OrderTotal)
,
AccurateQuantities (ProdOpQty, SumPrdQty, ProdNameQty, ProdIdQty) AS (
SELECT ProdOptions, (SUM(ProdQuantity)) AS OptionNumberofOrdered, ProdName, ProdId
FROM OptionsCombined
GROUP BY ProdOptions, NumberOfOptionValues, ProdName, ProdId
)
,
TotalQTYFullProds (FProdName, FProductId, SumProductQuantity) AS (
SELECT op.ProductName, op.ProductId, SUM(op.ProductQuantity) AS TotalQuantity
FROM OrderHistoryProducts op
JOIN OrderHistory oh
ON op.OrderHistoryId = oh.OrderHistoryId

WHERE oh.Pending = 0

GROUP BY op.ProductName, op.ProductId
)

SELECT ac.ProdOpQty, ac.SumPrdQty, ac.ProdNameQty, tqp.SumProductQuantity AS TotalQuantity, ac.ProdIdQty AS ProductId
FROM AccurateQuantities ac
JOIN TotalQTYFullProds tqp
ON ac.ProdIdQty = tqp.FProductId
ORDER BY tqp.SumProductQuantity DESC, ac.ProdNameQty ASC, ac.SumPrdQty DESC