SELECT * 
  FROM empsalary
 ORDER BY empno;


SELECT depname, 
       empno, 
	   salary, 
	   AVG(salary) OVER (PARTITION BY depname)
  FROM empsalary;
  

SELECT depname, 
       empno, 
	   salary, 
	   AVG(salary) OVER (PARTITION BY depname ORDER BY salary)
  FROM empsalary;
  

SELECT depname, 
       empno, 
	   salary,
       RANK() OVER (PARTITION BY depname ORDER BY salary DESC)
  FROM empsalary;
	

SELECT depname, 
       empno, 
	   salary,
	   SUM(SALARY) OVER (PARTITION BY DEPNAME)
  FROM EMPSALARY;


SELECT depname, 
       empno, 
	   salary,
	   SUM(SALARY) OVER (PARTITION BY DEPNAME ORDER BY SALARY)
  FROM EMPSALARY;


SELECT depname, 
       empno, 
	   salary,
	   SUM(SALARY) OVER ()
  FROM EMPSALARY;


SELECT salary,
       SUM(salary) OVER (ORDER BY SALARY) 
  FROM empsalary;


--:USING SUBQUERY -- BECAUSE WINDOWS dosn't work in WHERE....

SELECT depname, 
       empno, 
	   salary
  FROM (SELECT depname, 
               empno, 
			   salary,
               RANK() OVER (PARTITION BY depname ORDER BY salary DESC, empno) AS pos
          FROM empsalary)
WHERE pos < 3;


SELECT SUM(salary) OVER w, 
       AVG(salary) OVER w
  FROM empsalary
WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);











	
  

  
  
  
 







