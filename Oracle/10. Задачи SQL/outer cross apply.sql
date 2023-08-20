-- CROSS APPLY - Типо как INNER JOIN 
SELECT *, 
      (SELECT MAX(price) 
	     FROM Laptop L2
         JOIN Product P1 ON L2.model = P1.model 
        WHERE maker = (SELECT maker 
		                 FROM Product P2 
						WHERE P2.model= L1.model /*Приходится писать подзапросы в SELECT*/)) max_price,
		
      (SELECT MIN(price) 
	     FROM Laptop L2
         JOIN Product P1 ON L2.model = P1.model 
        WHERE maker = (SELECT maker 
		                 FROM Product P2 
						WHERE P2.model= L1.model /*Приходится писать подзапросы в SELECT*/)) min_price
  FROM Laptop L1;
  
SELECT *
  FROM laptop L1
 CROSS APPLY (SELECT MAX(price) max_price, 
                     MIN(price) min_price  
			    FROM Laptop L2
                JOIN Product P1 ON L2.model=P1.model 
               WHERE maker = (SELECT maker 
			                    FROM Product P2 
							   WHERE P2.model= L1.model /*В блок FROM теперь можно протягивать поля из другой таблицы.*/)) X;
							   


-- OUTER APPLY - Типо как left outer join

SELECT * 
  FROM laptop laptop1
 OUTER APPLY (SELECT * 
                FROM Laptop laptop2
               WHERE laptop1.model < laptop2.model 
			      OR (laptop1.model = laptop2.model AND laptop1.code < laptop2.code) 
               ORDER BY laptop2.model, 
			            laptop2.code) v
 ORDER BY laptop1.model;