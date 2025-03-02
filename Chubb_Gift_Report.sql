SELECT ProductName, ProductOptionValue, OrderHistoryAddresses.*, OrderHistory.*
FROM OrderHistoryAddresses
JOIN OrderHistory
	ON 
	OrderHistoryAddresses.OrderHistoryAddressId = OrderHistory.BillingAddressId
JOIN OrderHistoryProducts
	ON OrderHistoryProducts.OrderHistoryId = OrderHistory.OrderHistoryId
LEFT JOIN OrderHistoryProductOptions
	ON OrderHistoryProducts.OrderHistoryProductId = OrderHistoryProductOptions.OrderHistoryProductId
WHERE Pending = 0
AND FirstName != 'Test';
